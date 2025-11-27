package com.example.pmember.service;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface RatingMapper {

    // 음식 별점 기록
    int insertFoodRating(@Param("id") String id,
                         @Param("foodName") String foodName,
                         @Param("rating") int rating);

    // 음료 별점 기록
    int insertBeverageRating(@Param("id") String id,
                             @Param("beverageName") String beverageName,
                             @Param("rating") int rating);
}
