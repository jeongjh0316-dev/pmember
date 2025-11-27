// src/main/java/com/example/pmember/service/FoodRecommendationMapper.java
package com.example.pmember.service;

import com.example.pmember.dto.FoodRecommendation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FoodRecommendationMapper {

    // 추천받은 음식 메뉴들을 한 번에 기록 (추천 결과 받을 때)
    void insertFoodRecommendations(
            @Param("id") String id,
            @Param("menuIdxList") List<Integer> menuIdxList
    );

    // 마이페이지: 로그인 사용자의 최근 음식 추천 기록 조회
    List<FoodRecommendation> findRecentFoodRecommendations(@Param("id") String id);

    // 마이페이지: 선택한 reco_idx들 삭제
    void deleteFoodRecommendations(
            @Param("id") String id,
            @Param("recoIdxList") List<Integer> recoIdxList
    );
}
