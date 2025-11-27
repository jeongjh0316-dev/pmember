package com.example.pmember.service;

import com.example.pmember.dto.BeverageResult;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BeverageResultMapper {

    // Flask가 넘겨준 menu_name 리스트로 DB에서 음료를 조회
    List<BeverageResult> findByMenuNames(@Param("names") List<String> names);
}
