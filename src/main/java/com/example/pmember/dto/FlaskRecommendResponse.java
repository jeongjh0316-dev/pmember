package com.example.pmember.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;
import java.util.Map;

// Flask /recommend 응답 JSON 매핑용
public class FlaskRecommendResponse {

    @JsonProperty("request_features")
    private Map<String, Object> requestFeatures;

    @JsonProperty("applied_weights_summary")
    private Map<String, Object> appliedWeightsSummary;

    @JsonProperty("recommended_menu_list")
    private List<RecommendedMenu> recommendedMenuList;

    public Map<String, Object> getRequestFeatures() {
        return requestFeatures;
    }

    public void setRequestFeatures(Map<String, Object> requestFeatures) {
        this.requestFeatures = requestFeatures;
    }

    public Map<String, Object> getAppliedWeightsSummary() {
        return appliedWeightsSummary;
    }

    public void setAppliedWeightsSummary(Map<String, Object> appliedWeightsSummary) {
        this.appliedWeightsSummary = appliedWeightsSummary;
    }

    public List<RecommendedMenu> getRecommendedMenuList() {
        return recommendedMenuList;
    }

    public void setRecommendedMenuList(List<RecommendedMenu> recommendedMenuList) {
        this.recommendedMenuList = recommendedMenuList;
    }

    // 내부 클래스: 추천 한 건
    public static class RecommendedMenu {

        @JsonProperty("rank")
        private int rank;

        @JsonProperty("menu_name")
        private String menuName;

        @JsonProperty("distance")
        private double distance;

        public int getRank() {
            return rank;
        }

        public void setRank(int rank) {
            this.rank = rank;
        }

        public String getMenuName() {
            return menuName;
        }

        public void setMenuName(String menuName) {
            this.menuName = menuName;
        }

        public double getDistance() {
            return distance;
        }

        public void setDistance(double distance) {
            this.distance = distance;
        }
    }
}
