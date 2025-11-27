package com.example.pmember.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Dislike {
    private int dislikeIdx;   // dislike_idx
    private String id;        // 회원 ID (p_dislike.id)
    private String foodName;  // food_name
    private LocalDateTime createdAt; // created_at
}
