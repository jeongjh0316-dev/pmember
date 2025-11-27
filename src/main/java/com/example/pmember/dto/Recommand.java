package com.example.pmember.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Recommand {
    private int    foodmenu_idx;
    private String foodmenu_name;
    private String category;
    private String main_yn;
    private String side_ingredients;
    private String temp;
    private String recipe;
    private String hot_level;
    private String foodmenu_image;
}
