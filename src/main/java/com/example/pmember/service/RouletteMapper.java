package com.example.pmember.service;

import com.example.pmember.dto.Roulette;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface RouletteMapper {

    // 주어진 카테고리에서 랜덤 1개 (기존)
    Roulette selectRandomByCategory(@Param("category") String category);

    // 아무거나 랜덤 1개 (기존)
    Roulette selectRandomAny();

    // 🔹 카테고리 + 벤/알레르기 blockList 제외 랜덤
    Roulette selectRandomByCategoryExcept(
            @Param("category") String category,
            @Param("blockList") List<String> blockList
    );

    // 🔹 전체 + blockList 제외 랜덤
    Roulette selectRandomAnyExcept(
            @Param("blockList") List<String> blockList
    );
}
