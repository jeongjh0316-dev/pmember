package com.example.pmember.dto;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class Roulette {
    private Integer foodmenuIdx;      // foodmenu_idx
    private String  foodmenuName;     // foodmenu_name
    private String  category;         // ENUM('한식','일식','중식','양식')
    private String  mainYn;           // ENUM('밥','빵','면','기타')
    private String  sideIngredients;  // ENUM('육류','해산물','채소','상관없음')
    private String  temp;             // ENUM('COLD','HOT')
    private String  recipe;           // ENUM('튀김','구이볶음','국탕찌개','찜','상관없음')
    private String  hotLevel;         // ENUM('매움','맵지않음')
    private Timestamp createdAt;      // created_at
    private String  foodmenuImage;    // foodmenu_image
}
