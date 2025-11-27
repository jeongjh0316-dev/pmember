// src/main/java/com/example/pmember/dto/BeverageRecommendation.java
package com.example.pmember.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BeverageRecommendation {

    // p_beveragemenu_recommendation 컬럼
    private Integer recoBevIdx;          // reco_bev_idx (PK)
    private String id;                   // 사용자 아이디
    private Integer beveragemenuIdx;     // 음료메뉴 번호
    private Integer beveragemenuRatings; // 음료 평점 (처음엔 null)
    private LocalDateTime createdAt;     // 등록 일자

    // p_beveragemenu 조인해서 가져올 메뉴 이름
    private String beveragemenuName;     // 기록 탭에서 보여줄 메뉴 이름

    // ⭐ DB의 p_beveragemenu.beveragemenu_image 컬럼: 이미지 "파일명" (예: 아메리카노.jpg)
    //    실제 경로는 JSP에서 /images/drink/${beveragemenuImage} 형태로 완성해서 사용
    private String beveragemenuImage;
}
