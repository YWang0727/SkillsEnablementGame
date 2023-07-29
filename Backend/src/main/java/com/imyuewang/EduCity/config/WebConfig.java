package com.imyuewang.EduCity.config;

import com.imyuewang.EduCity.util.LoginInterceptor;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @ClassName WebConfig
 * @Description
 * @Author Yue Wang
 * @Date 2023/6/21 17:44
 **/
@Configuration
//@MapperScan("com.EduCity")
public class WebConfig implements WebMvcConfigurer {
    @Autowired
    LoginInterceptor loginInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // config Interceptors' path
        registry.addInterceptor(loginInterceptor)
                .excludePathPatterns("/auth/**");

    }
}
