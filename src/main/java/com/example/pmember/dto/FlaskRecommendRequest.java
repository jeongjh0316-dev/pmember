package com.example.pmember.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

// Flask /recommend 로 보낼 요청 바디
public class FlaskRecommendRequest {

    @JsonProperty("category")
    private String category;

    @JsonProperty("main_yn")
    private String mainYn;

    @JsonProperty("side_ingredients")
    private String sideIngredients;

    @JsonProperty("temp")
    private String temp;

    @JsonProperty("recipe")
    private String recipe;

    @JsonProperty("hot_level")
    private String hotLevel;

    public FlaskRecommendRequest() {}

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getMainYn() {
        return mainYn;
    }

    public void setMainYn(String mainYn) {
        this.mainYn = mainYn;
    }

    public String getSideIngredients() {
        return sideIngredients;
    }

    public void setSideIngredients(String sideIngredients) {
        this.sideIngredients = sideIngredients;
    }

    public String getTemp() {
        return temp;
    }

    public void setTemp(String temp) {
        this.temp = temp;
    }

    public String getRecipe() {
        return recipe;
    }

    public void setRecipe(String recipe) {
        this.recipe = recipe;
    }

    public String getHotLevel() {
        return hotLevel;
    }

    public void setHotLevel(String hotLevel) {
        this.hotLevel = hotLevel;
    }
}
