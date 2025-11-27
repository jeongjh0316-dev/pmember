package com.example.pmember.controller;

import com.example.pmember.dto.Pmember;
import com.example.pmember.service.DislikeMapper;
import com.example.pmember.service.WishlistMapper; // ✅ 추가
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/dislike")
public class DislikeController {

    @Autowired
    private DislikeMapper dislikeMapper;

    // ✅ 추가: 벤 ↔ 찜 상호 배타 보장을 위해 WishlistMapper 주입
    @Autowired
    private WishlistMapper wishlistMapper;

    // 🔹 벤 추가 (추천 결과에서 "싫어요(X)" AJAX 호출)
    @PostMapping("/add")
    @ResponseBody
    public String addDislike(@RequestParam("foodName") String foodName,
                             HttpSession session) {

        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            System.out.println("⚠ [DISLIKE-ADD] 로그인 정보 없음 → NOT_LOGIN");
            return "NOT_LOGIN";
        }

        String id = login.getId();
        System.out.println("✅ [DISLIKE-ADD] id=" + id + ", foodName=" + foodName);

        // ✅ 1) 이 메뉴가 '찜 리스트'에 있다면 먼저 제거
        int removedWish = wishlistMapper.deleteWish(id, foodName);
        System.out.println("   └ 기존 WISH 삭제 시도: removedWish = " + removedWish);

        // ✅ 2) 벤 추가
        int inserted = dislikeMapper.insertDislike(id, foodName);
        System.out.println("✅ [DISLIKE-ADD] DISLIKE insert 결과 row 수 = " + inserted);

        return "OK";
    }

    // 🔹 마이페이지에서: 체크된 벤 항목들 삭제
    @PostMapping("/removeSelected")
    public String removeSelected(
            @RequestParam(value = "foodName", required = false) List<String> foodNames,
            HttpSession session) {

        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            System.out.println("⚠ [DISLIKE-REMOVE] 로그인 정보 없음 → /login 리다이렉트");
            return "redirect:/login";
        }

        String id = login.getId();
        System.out.println("📌 [DISLIKE-REMOVE] id = " + id);

        if (foodNames == null || foodNames.isEmpty()) {
            System.out.println("⚠ [DISLIKE-REMOVE] 선택된 메뉴 없음 → /mypage 리다이렉트");
            return "redirect:/mypage";
        }

        System.out.println("📌 [DISLIKE-REMOVE] 선택된 메뉴 목록 = " + foodNames);

        for (String foodName : foodNames) {
            int deleted = dislikeMapper.deleteDislike(id, foodName);
            System.out.println("   └ 삭제 시도: foodName = " + foodName + ", deleted = " + deleted);
        }

        return "redirect:/mypage";
    }
}
