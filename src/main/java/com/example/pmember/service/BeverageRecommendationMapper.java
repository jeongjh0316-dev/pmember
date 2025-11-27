// src/main/java/com/example/pmember/service/BeverageRecommendationMapper.java
package com.example.pmember.service;

import com.example.pmember.dto.BeverageRecommendation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BeverageRecommendationMapper {

    // 추천받은 음료 메뉴들을 한 번에 기록
    void insertBeverageRecommendations(
            @Param("id") String id,
            @Param("menuIdxList") List<Integer> menuIdxList
    );

    // 마이페이지: 로그인 사용자의 최근 음료 추천 기록 조회
    List<BeverageRecommendation> findRecentBeverageRecommendations(@Param("id") String id);

    // 마이페이지: 선택한 reco_bev_idx들 삭제
    void deleteBeverageRecommendations(
            @Param("id") String id,
            @Param("recoIdxList") List<Integer> recoIdxList
    );
}
