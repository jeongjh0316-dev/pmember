package com.example.pmember.service;

import com.example.pmember.dto.Dislike;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DislikeMapper {

    // 회원별 벤(싫어요) 리스트 조회
    List<Dislike> selectDislikeList(@Param("id") String id);

    // 벤 추가
    int insertDislike(@Param("id") String id,
                      @Param("foodName") String foodName);

    // 벤 삭제 (한 메뉴씩)
    int deleteDislike(@Param("id") String id,
                      @Param("foodName") String foodName);

    // 추천 필터링용: 이 유저가 벤한 메뉴 이름 목록
    List<String> selectFoodNamesByMember(@Param("id") String id);
}
