package com.example.pmember.controller;

import com.example.pmember.dto.Pmember;
import com.example.pmember.service.RatingMapper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class RatingController {

    @Autowired
    private RatingMapper ratingMapper;

    // 🔹 음식 별점 저장
    @PostMapping("/rating/food")
    public String rateFood(@RequestParam("foodName") String foodName,
                           @RequestParam("score") int score,
                           HttpSession session) {
        Pmember loginMember = (Pmember) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "NOT_LOGIN";
        }

        if (score < 1 || score > 5) {
            return "INVALID_SCORE";
        }

        int rows = ratingMapper.insertFoodRating(loginMember.getId(), foodName, score);
        return rows > 0 ? "OK" : "FAIL";
    }

    // 🔹 음료 별점 저장
    @PostMapping("/rating/beverage")
    public String rateBeverage(@RequestParam("beverageName") String beverageName,
                               @RequestParam("score") int score,
                               HttpSession session) {
        Pmember loginMember = (Pmember) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "NOT_LOGIN";
        }

        if (score < 1 || score > 5) {
            return "INVALID_SCORE";
        }

        int rows = ratingMapper.insertBeverageRating(loginMember.getId(), beverageName, score);
        return rows > 0 ? "OK" : "FAIL";
    }
}
