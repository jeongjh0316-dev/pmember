package com.example.pmember.controller;

import com.example.pmember.dto.FlaskRecommendRequest;
import com.example.pmember.dto.FlaskRecommendResponse;
import com.example.pmember.dto.FlaskRecommendResponse.RecommendedMenu;
import com.example.pmember.dto.FoodResult;
import com.example.pmember.dto.Pmember;
import com.example.pmember.service.DislikeMapper;
import com.example.pmember.service.FoodResultMapper;
import com.example.pmember.service.FoodRecommendationMapper;   // 🔹 추가
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.stream.Collectors;

@Controller
public class RecommandController {

    private static final String FLASK_URL = "http://localhost:5001/recommend";

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private FoodResultMapper foodResultMapper;

    // 🔹 벤(싫어요) 목록 조회용
    @Autowired
    private DislikeMapper dislikeMapper;

    // 🔹 추천 기록 INSERT 용
    @Autowired
    private FoodRecommendationMapper foodRecommendationMapper;

    // 설문 페이지
    @GetMapping("/main-food")
    public String goRecommandPage() {
        return "recommand"; // recommand.jsp
    }

    // 설문 -> Flask -> DB -> 결과 페이지
    @PostMapping("/recommend")
    public String recommendFromFlask(
            @RequestParam("category") String category,
            @RequestParam("main_yn") String mainYn,
            @RequestParam("side_ingredients") String sideIngredients,
            @RequestParam("temp") String temp,
            @RequestParam("recipe") String recipe,
            @RequestParam("hot_level") String hotLevel,
            HttpSession session,
            Model model
    ) {

        // 1) Flask 요청 DTO 생성
        FlaskRecommendRequest requestBody = new FlaskRecommendRequest();
        requestBody.setCategory(category);
        requestBody.setMainYn(mainYn);
        requestBody.setSideIngredients(sideIngredients);
        requestBody.setTemp(temp);
        requestBody.setRecipe(recipe);
        requestBody.setHotLevel(hotLevel);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<FlaskRecommendRequest> entity =
                new HttpEntity<>(requestBody, headers);

        // 2) Flask 호출
        ResponseEntity<FlaskRecommendResponse> response =
                restTemplate.exchange(
                        FLASK_URL,
                        HttpMethod.POST,
                        entity,
                        FlaskRecommendResponse.class
                );

        FlaskRecommendResponse body = response.getBody();
        if (body == null || body.getRecommendedMenuList() == null) {
            model.addAttribute("results", Collections.emptyList());
            return "foodresult";
        }

        // 3) Flask가 준 추천 메뉴 리스트
        List<RecommendedMenu> recList = body.getRecommendedMenuList();
        if (recList.isEmpty()) {
            model.addAttribute("results", Collections.emptyList());
            return "foodresult";
        }

        // 4) 로그인한 회원 정보 & 벤 리스트 조회
        Pmember login = (Pmember) session.getAttribute("loginMember");
        String memberId = (login != null) ? login.getId() : null;

        Set<String> bannedSet = new HashSet<>();
        if (memberId != null) {
            List<String> bannedNames = dislikeMapper.selectFoodNamesByMember(memberId);
            if (bannedNames != null) {
                bannedSet.addAll(bannedNames);
            }
        }

        // 5) Flask 추천 전체 이름 목록 → DB에서 알레르기까지 반영된 메뉴 정보 조회
        List<String> allNames = recList.stream()
                .map(RecommendedMenu::getMenuName)
                .collect(Collectors.toList());

        // memberId 기준 알레르기 필터 적용된 결과라고 가정
        List<FoodResult> dbResults = foodResultMapper.selectByNames(allNames, memberId);

        // 이름 → FoodResult 맵핑
        Map<String, FoodResult> mapByName = dbResults.stream()
                .collect(Collectors.toMap(FoodResult::getFoodmenuName, fr -> fr));

        // 6) 알레르기 / 벤 메뉴 제외한 안전한 후보 리스트
        List<FoodResult> safeList = new ArrayList<>();
        for (RecommendedMenu rm : recList) {
            String name = rm.getMenuName();

            FoodResult fr = mapByName.get(name);
            if (fr == null) {
                continue; // 알레르기로 DB에서 빠진 경우
            }

            if (!bannedSet.isEmpty() && bannedSet.contains(name)) {
                continue; // 벤(싫어요) 메뉴
            }

            fr.setScore(rm.getDistance());
            safeList.add(fr);
        }

        // 7) 후보가 하나도 없으면 빈 결과
        if (safeList.isEmpty()) {
            model.addAttribute("results", Collections.emptyList());
            model.addAttribute("answers", body.getRequestFeatures());
            model.addAttribute("weightsSummary", body.getAppliedWeightsSummary());
            return "foodresult";
        }

        // 8) 남은 메뉴 중 상위 3개만 노출
        List<FoodResult> finalResults = safeList.stream()
                .limit(3)
                .collect(Collectors.toList());

        // 9) 🔹 여기서 추천 기록 테이블에 INSERT
        if (login != null) {
            List<Integer> menuIdxList = finalResults.stream()
                    .map(FoodResult::getFoodmenuIdx)   // FoodResult에 foodmenuIdx 필드 있다고 가정
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList());

            if (!menuIdxList.isEmpty()) {
                foodRecommendationMapper.insertFoodRecommendations(login.getId(), menuIdxList);
            }
        }

        // 10) JSP에 전달
        model.addAttribute("results", finalResults);
        model.addAttribute("answers", body.getRequestFeatures());
        model.addAttribute("weightsSummary", body.getAppliedWeightsSummary());

        return "foodresult"; // foodresult.jsp
    }

    // 🔹 먹게배달 페이지 이동 (추천 결과에서 menuName 전달)
    //    /delivery 와 /mukke-delivery 둘 다 이 메서드로 처리
    @GetMapping({"/delivery", "/mukke-delivery"})
    public String delivery(
            @RequestParam(value = "menuName", required = false) String menuName,
            Model model
    ) {
        System.out.println("[delivery] 전달된 menuName = " + menuName);

        // 🔹 파라미터가 안 넘어온 경우를 대비한 기본값 (디버깅용)
        if (menuName == null || menuName.trim().isEmpty()) {
            menuName = "추천 메뉴";  // 필요하면 "규동(데모)" 등으로 바꿔도 됨
        }

        model.addAttribute("menuName", menuName);
        return "delivery"; // /WEB-INF/views/delivery.jsp
    }

}
