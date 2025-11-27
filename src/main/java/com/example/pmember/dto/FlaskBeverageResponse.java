package com.example.pmember.dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class FlaskBeverageResponse {

    // { "request_features": {...}, ... }  (필요 없으면 나중에 삭제 가능)
    private Map<String, Object> request_features;

    // { "applied_weights_summary": {...}, ... }
    private Map<String, Object> applied_weights_summary;

    // { "recommended_menu_list": [ {...}, {...}, {...} ] }
    private List<RecommendedMenu> recommended_menu_list;

    @Data
    public static class RecommendedMenu {
        private int rank;         // 1, 2, 3
        private String menu_name; // JSON의 "menu_name"
        private double distance;  // 유사도 거리
    }
}
