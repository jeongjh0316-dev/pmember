package com.example.pmember.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class MemberAlergy {

    private int user_al_idx;    // 회원 알레르기 고유번호 (PK)
    private String id;          // 회원 아이디 (p_member.id FK)
    private int al_idx;         // 알레르기 고유번호 (p_alergy.al_idx FK)
    private Timestamp created_at; // 생성일시
}
