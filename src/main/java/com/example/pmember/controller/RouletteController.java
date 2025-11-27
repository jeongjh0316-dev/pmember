package com.example.pmember.controller;

import com.example.pmember.dto.Pmember;
import com.example.pmember.dto.Roulette;
import com.example.pmember.service.RouletteMapper;
import com.example.pmember.service.DislikeMapper;
import com.example.pmember.service.AlergyMapper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
public class RouletteController {

    @Autowired
    private RouletteMapper rouletteMapper;

    @Autowired
    private DislikeMapper dislikeMapper;  // ⭐ 벤 리스트

    @Autowired
    private AlergyMapper alergyMapper;    // ⭐ 알레르기용 (이미 존재한다고 가정)

    // 룰렛 페이지
    @GetMapping("/roulette")
    public String viewRoulette() {
        return "roulette"; // /WEB-INF/views/roulette.jsp
    }

    // 룰렛 스핀 API (JSP에서 fetch로 호출)
    @GetMapping(value = "/api/roulette/spin", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<?> spin(
            @RequestParam(value = "category", required = false) String category,
            HttpSession session
    ) {

        // 1) 로그인 회원
        Pmember login = (Pmember) session.getAttribute("loginMember");

        // 2) 피해야 할 메뉴 이름들(벤 + 알레르기)
        List<String> blockList = new ArrayList<>();

        if (login != null) {
            String id = login.getId();

            // 2-1) 벤 메뉴
            List<String> dislikeNames = dislikeMapper.selectFoodNamesByMember(id);
            if (dislikeNames != null) {
                blockList.addAll(dislikeNames);
            }

            // 2-2) 알레르기 메뉴
            // ⚠️ 메서드명은 실제 AlergyMapper에 맞게 변경해줘!
            List<String> allergyNames = alergyMapper.selectFoodNamesByMember(id);
            if (allergyNames != null) {
                blockList.addAll(allergyNames);
            }
        }

        // 3) 중복 제거
        List<String> filteredBlockList = new ArrayList<>(new LinkedHashSet<>(blockList));

        // 4) 필터를 적용해서 랜덤 1개 뽑기
        Roulette item = null;

        if (category != null && !category.isBlank()) {
            // 카테고리 + 필터
            item = rouletteMapper.selectRandomByCategoryExcept(category, filteredBlockList);
        }

        if (item == null) {
            // 카테고리 상관없이 전체 + 필터
            item = rouletteMapper.selectRandomAnyExcept(filteredBlockList);
        }

        Map<String, Object> body = new HashMap<>();

        if (item == null) {
            // 🔴 벤/알레르기 때문에 뽑을 메뉴가 없을 때
            body.put("ok", false);
            body.put("reason", "NO_CANDIDATE");
            body.put("message", "더 이상 추천할 메뉴가 없습니다~ (벤/알레르기 제외 결과)");
        } else {
            // 🟢 정상적으로 하나 뽑음
            body.put("ok", true);
            body.put("menu", item);
        }

        return ResponseEntity.ok(body);
    }
}
