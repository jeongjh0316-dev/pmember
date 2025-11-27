package com.example.pmember.dto;

import lombok.Data;

@Data
public class FlaskBeverageRequest {

    private String sweetness;    // SWEETENED / UNSWEETENED
    private String milk_base;    // MILK / NOMILK
    private String style;        // COFFEE / TEA / SMOOTHIE / NOCOFFEELATTE / ADE ...
    private String fruit_yn;     // fruitY / fruitN
    private String temperature;  // HOT / COLD
}
