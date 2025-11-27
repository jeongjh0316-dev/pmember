// src/main/java/com/example/pmember/dto/Pmember.java
package com.example.pmember.dto;

import lombok.Data;

@Data
public class Pmember {

    private String id;
    private String pw;
    private String email;
    private String birth;      // "1990-01-01"
    private String gender;     // "male", "female", "private"

    // ⭐ 신규 추가: 프로필 이미지 URL
    // DB의 profile_image 컬럼과 매핑됨
    private String profileImage;
}
