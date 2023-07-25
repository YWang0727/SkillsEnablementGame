package com.imyuewang.EduCity.util;

import com.ibm.cloud.sdk.core.security.IamAuthenticator;
import com.ibm.watson.assistant.v2.Assistant;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class WatsonConfig {

    @Value("${ibm.watson.api-key}")
    private String apiKey;

    @Value("${ibm.watson.url}")
    private String url;

    @Bean
    public Assistant assistant() {
        IamAuthenticator authenticator = new IamAuthenticator.Builder()
                .apikey(apiKey)
                .build();
        Assistant assistant = new Assistant("2021-11-27", authenticator);
        assistant.setServiceUrl(url);

        return assistant;
    }

}
