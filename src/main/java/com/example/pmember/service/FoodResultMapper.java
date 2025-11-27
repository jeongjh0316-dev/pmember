package com.example.pmember.service;

import com.example.pmember.dto.FoodResult;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FoodResultMapper {

    // Flask 결과 이름 리스트로 메뉴 조회 (+ 회원 알레르기 고려)
    List<FoodResult> selectByNames(
            @Param("names") List<String> names,
            @Param("memberId") String memberId
    );

    // 🔹 예비 메뉴: 상위 몇 개(예: foodmenu_idx 순) 가져오기
    List<FoodResult> selectTopResults();
}
