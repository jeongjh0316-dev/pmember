package com.example.pmember.controller;

import com.example.pmember.dto.Pmember;
import com.example.pmember.service.WishlistMapper;
import com.example.pmember.service.DislikeMapper; // ✅ 추가
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/wish")
public class WishlistController {

    @Autowired
    private WishlistMapper wishlistMapper;

    // ✅ 추가: 찜 ↔ 벤 상호 배타 보장을 위해 DislikeMapper 주입
    @Autowired
    private DislikeMapper dislikeMapper;

    // 🔹 찜 추가 (추천 결과에서 호출 - AJAX)
    @PostMapping("/add")
    @ResponseBody
    public String addWish(@RequestParam("foodName") String foodName,
                          HttpSession session) {

        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            System.out.println("⚠ [WISH-ADD] 로그인 정보 없음, NOT_LOGIN 반환");
            return "NOT_LOGIN";
        }

        String memberId = login.getId();
        System.out.println("✅ [WISH-ADD] memberId=" + memberId + ", foodName=" + foodName);

        // ✅ 1) 이 메뉴가 '벤 리스트'에 있으면 먼저 제거
        int removedDislike = dislikeMapper.deleteDislike(memberId, foodName);
        System.out.println("   └ 기존 DISLIKE 삭제 시도: removedDislike = " + removedDislike);

        // ✅ 2) 찜 추가
        int inserted = wishlistMapper.insertWish(memberId, foodName);
        System.out.println("✅ [WISH-ADD] WISHLIST insert 결과 row 수 = " + inserted);

        return "OK";
    }

    // 🔹 찜 삭제 (마이페이지에서 호출 - 여러 개 한 번에 삭제)
    @PostMapping("/remove")
    public String removeWish(
            @RequestParam(value = "foodName", required = false) List<String> foodNames,
            HttpSession session) {

        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            System.out.println("⚠ [WISH-REMOVE] 로그인 정보 없음 → /login 리다이렉트");
            return "redirect:/login";
        }

        String memberId = login.getId();
        System.out.println("📌 [WISH-REMOVE] memberId = " + memberId);

        if (foodNames == null || foodNames.isEmpty()) {
            System.out.println("⚠ [WISH-REMOVE] 선택된 foodName 없음 → 삭제 없이 /mypage?tab=settings 리다이렉트");
            // ✅ '설정(찜 목록)' 탭으로 보내기
            return "redirect:/mypage?tab=settings";
        }

        System.out.println("📌 [WISH-REMOVE] 선택된 메뉴 목록 = " + foodNames);

        for (String foodName : foodNames) {
            int deleted = wishlistMapper.deleteWish(memberId, foodName);
            System.out.println("   └ 삭제 시도: foodName = " + foodName + ", deleted = " + deleted);
        }

        // ✅ 삭제 후에도 '설정' 탭 유지
        return "redirect:/mypage?tab=settings";
    }
}
