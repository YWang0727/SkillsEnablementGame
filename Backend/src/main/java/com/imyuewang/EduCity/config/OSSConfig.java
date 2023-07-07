package com.imyuewang.EduCity.config;

import lombok.Data;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "aws.s3")
public class OSSConfig implements InitializingBean {

    private String region;
    private String bucket;
    private String accessKey;
    private String secretKey;

    public static String REGION;
    public static String BUCKET;
    public static String ACCESS_KEY;
    public static String SECRET_KEY;

    @Override
    public void afterPropertiesSet() throws Exception {
        REGION = region;
        BUCKET = bucket;
        ACCESS_KEY = accessKey;
        SECRET_KEY = secretKey;
    }
}

