package com.example.pmember.dto;

import lombok.Data;

@Data
public class BeverageResult {

    private Long id;        // PK (beverage_idx 등) - 이름은 맘대로, SQL에서 alias로 맞출 거야
    private String name;    // 음료 이름  (menu_name 컬럼에서 alias)
    private String imageUrl; // 이미지 URL (image 컬럼에서 alias)
    private String description; // 설명 (있으면 사용, 없으면 null 가능)
}
