// src/main/java/com/example/pmember/PmemberApplication.java
package com.example.pmember;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication(scanBasePackages = "com.example.pmember")
public class PmemberApplication {

    public static void main(String[] args) {
        SpringApplication.run(PmemberApplication.class, args);
    }

    // 🔥 Flask 서버와 통신하기 위한 RestTemplate Bean
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

//  http://localhost:8089/login
