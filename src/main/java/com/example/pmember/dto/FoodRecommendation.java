// src/main/java/com/example/pmember/dto/FoodRecommendation.java
package com.example.pmember.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class FoodRecommendation {

    // p_food_recommendation 컬럼
    private Integer recoIdx;          // reco_idx (PK)
    private String id;                // 사용자 아이디
    private Integer foodmenuIdx;      // 음식메뉴 고유번호
    private Integer foodmenuRatings;  // 음식메뉴 별점 (처음엔 null)
    private LocalDateTime createdAt;  // 등록 일자

    // p_foodmenu 조인해서 가져올 메뉴 이름
    private String foodmenuName;      // 기록 탭에서 보여줄 메뉴 이름

    // ⭐ DB의 p_foodmenu.foodmenu_image 컬럼: 이미지 "파일명" (예: 규동.jpg)
    //    실제 경로는 JSP에서 /images/food/${foodmenuImage} 형태로 완성해서 사용
    private String foodmenuImage;
}
