package com.example.pmember.dto;

import java.sql.Timestamp;

public class WishItem {

    private int wishIdx;        // wish_idx
    private String id;          // 회원 id (p_member.id)
    private String foodName;    // 찜한 메뉴 이름
    private Timestamp createdAt; // 생성 시간

    // ⭐ DB의 p_foodmenu.foodmenu_image 컬럼: 이미지 "파일명" (예: 나가사키짬뽕.jpg)
    //    실제 경로는 JSP에서 /images/food/${foodImage} 형태로 완성해서 사용
    private String foodImage;

    public int getWishIdx() {
        return wishIdx;
    }

    public void setWishIdx(int wishIdx) {
        this.wishIdx = wishIdx;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFoodName() {
        return foodName;
    }

    public void setFoodName(String foodName) {
        this.foodName = foodName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getFoodImage() {
        return foodImage;
    }

    public void setFoodImage(String foodImage) {
        this.foodImage = foodImage;
    }
}
