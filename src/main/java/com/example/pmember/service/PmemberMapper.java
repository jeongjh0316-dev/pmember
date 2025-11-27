package com.example.pmember.service;

import com.example.pmember.dto.Pmember;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PmemberMapper {

    int insert(Pmember member);

    // 로그인 / 조회
    Pmember findById(@Param("id") String id);

    int existsById(@Param("id") String id);
    int existsByEmail(@Param("email") String email);
    int countById(@Param("id") String id);

    // 🔹 아이디 찾기: 이메일 + 생년월일로 찾기
    String findIdByEmailAndBirth(@Param("email") String email,
                                 @Param("birth") String birth);

    // 🔹 비밀번호 재설정
    int updatePassword(@Param("id") String id,
                       @Param("pw") String pw);

    // 프로필 이미지
    int updateProfileImage(@Param("id") String id,
                           @Param("profileImage") String profileImage);

    Pmember findFullById(@Param("id") String id);

    // 회원 정보 수정 (비밀번호 제외)
    int updateMemberNoPw(@Param("oldId") String oldId,
                         @Param("member") Pmember member);

    // 회원 정보 수정 (비밀번호 포함)
    int updateMemberWithPw(@Param("oldId") String oldId,
                           @Param("member") Pmember member);
}
