package com.example.pmember.controller;

import com.example.pmember.dto.FlaskBeverageRequest;
import com.example.pmember.dto.FlaskBeverageResponse;
import com.example.pmember.dto.FlaskBeverageResponse.RecommendedMenu;
import com.example.pmember.dto.BeverageResult;
import com.example.pmember.dto.Pmember;
import com.example.pmember.service.BeverageResultMapper;
import com.example.pmember.service.BeverageRecommendationMapper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class BeverageController {

    // 🔹 Flask 음료 서버 URL (app.py 기준)
    private static final String FLASK_BEVERAGE_URL = "http://localhost:5002/recommend_beverage";

    @Autowired
    private RestTemplate restTemplate;

    // 🔹 음료 DB 조회용 Mapper
    @Autowired
    private BeverageResultMapper beverageResultMapper;

    // 🔹 음료 추천 기록용 Mapper (마이페이지 history 탭)
    @Autowired
    private BeverageRecommendationMapper beverageRecommendationMapper;

    // ✅ 홈에서 "음료" 카드 클릭 → beverage.jsp 로 이동
    @GetMapping("/beverage")
    public String showBeveragePage() {
        return "beverage";  // /WEB-INF/views/beverage.jsp
    }

    // ✅ 음료 설문 완료 → Flask + DB 거쳐 beverageresult.jsp 로 이동
    @PostMapping("/beverage-result")
    public String showBeverageResult(
            @ModelAttribute FlaskBeverageRequest requestDto,
            HttpSession session,
            Model model
    ) {
        try {
            // 1) Flask 쪽으로 JSON 요청 보내기
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<FlaskBeverageRequest> entity =
                    new HttpEntity<>(requestDto, headers);

            ResponseEntity<FlaskBeverageResponse> response =
                    restTemplate.exchange(
                            FLASK_BEVERAGE_URL,
                            HttpMethod.POST,
                            entity,
                            FlaskBeverageResponse.class
                    );

            FlaskBeverageResponse body = response.getBody();

            // 2) Flask 응답이 없거나 추천 리스트가 비어 있으면 빈 상태로 처리
            if (body == null ||
                    body.getRecommended_menu_list() == null ||
                    body.getRecommended_menu_list().isEmpty()) {

                model.addAttribute("results", null);
                return "beverageresult";
            }

            // 3) Flask 추천 리스트에서 menu_name만 추출
            List<String> menuNames = body.getRecommended_menu_list()
                    .stream()
                    .map(RecommendedMenu::getMenu_name)
                    .collect(Collectors.toList());

            // 4) DB에서 해당 이름들에 해당하는 음료 정보 조회
            List<BeverageResult> results = beverageResultMapper.findByMenuNames(menuNames);

            // 5) 로그인한 회원이면, 추천 결과를 history 테이블에 기록
            Pmember login = (Pmember) session.getAttribute("loginMember");
            if (login != null && results != null && !results.isEmpty()) {

                // DTO의 PK 필드명은 id → getId() 사용 (음식이랑 이름만 다름)
                List<Integer> menuIdxList = results.stream()
                        .filter(r -> r.getId() != null)
                        .map(r -> r.getId().intValue()) // Long → int
                        .distinct()
                        .collect(Collectors.toList());

                if (!menuIdxList.isEmpty()) {
                    beverageRecommendationMapper.insertBeverageRecommendations(
                            login.getId(),
                            menuIdxList
                    );
                }
            }

            // 6) JSP로 전달 (beverageresult.jsp 에서 ${results} 사용)
            model.addAttribute("results", results);

        } catch (Exception e) {
            e.printStackTrace();
            // 에러가 나도 JSP에서 "추천 없음" 화면 뜨도록 null 전달
            model.addAttribute("results", null);
        }

        return "beverageresult"; // /WEB-INF/views/beverageresult.jsp
    }
}
