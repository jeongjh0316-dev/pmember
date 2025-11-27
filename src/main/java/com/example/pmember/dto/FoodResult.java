package com.example.pmember.dto;

public class FoodResult {

    private Integer foodmenuIdx;    // foodmenu_idx (PK)
    private String  foodmenuName;   // foodmenu_name
    private String  foodmenuImage;  // foodmenu_image (이미지 URL)
    private Double  score;          // Flask distance 값 저장용

    public Integer getFoodmenuIdx() {
        return foodmenuIdx;
    }

    public void setFoodmenuIdx(Integer foodmenuIdx) {
        this.foodmenuIdx = foodmenuIdx;
    }

    public String getFoodmenuName() {
        return foodmenuName;
    }

    public void setFoodmenuName(String foodmenuName) {
        this.foodmenuName = foodmenuName;
    }

    public String getFoodmenuImage() {
        return foodmenuImage;
    }

    public void setFoodmenuImage(String foodmenuImage) {
        this.foodmenuImage = foodmenuImage;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }


}
