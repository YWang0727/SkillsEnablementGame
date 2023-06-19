package com.EduCity;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import springfox.documentation.oas.annotations.EnableOpenApi;



@EnableOpenApi
@SpringBootApplication
@MapperScan(basePackages = {"com.EduCity.mapper"})
public class EduCityApplication {

    public static void main(String[] args) {
        SpringApplication.run(EduCityApplication.class, args);
    }

}
