package com.example.pmember.service;

import com.example.pmember.dto.WishItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

// ✅ MyBatis Mapper 라는 것을 스프링에 알려주는 어노테이션
@Mapper
public interface WishlistMapper {

    // 찜 추가
    int insertWish(@Param("id") String id,
                   @Param("foodName") String foodName);

    // 찜 삭제
    int deleteWish(@Param("id") String id,
                   @Param("foodName") String foodName);

    // 회원의 찜 목록 조회
    List<WishItem> selectWishlistByMember(@Param("id") String id);
}
