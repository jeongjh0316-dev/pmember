package com.example.pmember.service;

import com.example.pmember.dto.Alergy;
import com.example.pmember.dto.MemberAlergy;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AlergyMapper {

    // 1) 마스터 알레르기 전체 조회
    List<Alergy> selectAllAlergy();

    // 2) 특정 회원이 체크한 알레르기 목록 (al_idx 리스트만)
    List<Integer> selectUserAlergyIdxList(@Param("id") String id);

    // 3) 특정 회원의 알레르기 전체 삭제
    int deleteUserAlergyById(@Param("id") String id);

    // 4) 회원 알레르기 1건 insert
    int insertUserAlergy(MemberAlergy memberAlergy);

    // 5) 🔹 이 회원이 알레르기 때문에 피해야 할 음식 이름 목록
    //    => 룰렛/추천에서 제외할 때 사용
    List<String> selectFoodNamesByMember(@Param("id") String id);
}
