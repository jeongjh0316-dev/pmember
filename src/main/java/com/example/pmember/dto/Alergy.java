package com.example.pmember.dto;

import lombok.Data;

@Data
public class Alergy {

    private int al_idx;         // 알레르기 고유번호
    private String al_name;     // 알레르기 이름 (예: 갑각류, 유제품 등)
    private String al_symptom;  // 증상 설명
    private String al_severity; // 위험도 (경증/중증 등)
}
