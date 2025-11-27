package com.example.pmember.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        registry.addResourceHandler("/profile/**")
                .addResourceLocations("file:/C:/upload/profile/");
        // ↑ C:/upload/profile/ 경로는 네가 실제로 쓸 폴더에 맞게 수정 가능
    }
}
