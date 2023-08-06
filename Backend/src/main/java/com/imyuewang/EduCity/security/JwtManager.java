package com.imyuewang.EduCity.security;

import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.jwt.*;
import cn.hutool.jwt.signers.JWTSignerUtil;
import lombok.extern.slf4j.Slf4j;
import java.util.HashMap;
import java.util.Map;

/**
 * @ClassName JwtManager
 * @Description Generation and management util for jwt token
 * @Author Yue Wang
 * @Date 2023/5/3 16:23
 * @Version 1.0
 **/
@Slf4j
public final class JwtManager {
    /**
     * This secret key is crucial to prevent tampering of the JWT.
     */
    private final static byte[] secretKeyBytes = "my_secret_key".getBytes();

    /**
     * Generate jwt token
     * @author Yue Wang
     * @date 14:54 2023/5/7
     * @param userId userid
     * @return jwt token
     **/
    public static String generate(Long userId, Integer expiration){
        DateTime now = DateUtil.date();
        DateTime ddl = DateUtil.offsetMinute(now, expiration);
        Map<String, Object> map = new HashMap<String, Object>() {
            {
                put(JWTPayload.ISSUED_AT, now);
                put(JWTPayload.EXPIRES_AT, ddl);
                put(JWTPayload.NOT_BEFORE, now);
                put(JWTPayload.SUBJECT, userId); //put userId in 'sub'
            }
        };
        //return "Bearer " + JWTUtil.createToken(map, secretKeyBytes);
        return JWTUtil.createToken(map, secretKeyBytes);
    }

    public static String generate(String userPw) {
        Map<String, Object> map = new HashMap<String, Object>(){
            {
                put(JWTPayload.SUBJECT, userPw);
            }
        };
        return JWTUtil.createToken(map, secretKeyBytes);
    }


    /**
     * Verify token
     * @author Yue Wang
     * @date 14:54 2023/5/7
     * @param token jwt token
     * @throws RuntimeException Throw an exception if verification fails.
     **/
    public static JWT parse(String token) {
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        if(StrUtil.isBlank(token)){
            return null;
        }
        JWT jwt = null;
        // If parsing fails, an exception is thrown, so catch it. expired tokens and illegal tokens can cause parsing to fail.
        try {
            // Parsing (including verification of signatures)
            jwt = JWTUtil.parseToken(token);

            // Validation algorithms and timing
            JWTValidator validator = JWTValidator.of(jwt);
            // Validation Algorithms
            validator.validateAlgorithm(JWTSignerUtil.hs256(secretKeyBytes));
            // Verification time
            JWTValidator.of(jwt).validateDate();
        } catch (Exception e) {
            log.error("Failed token parsing and validation");
            return null;
        }
        return jwt;
    }
    public static JWT parsePwToken(String token) {
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        if(StrUtil.isBlank(token)){
            return null;
        }
        JWT jwt = null;
        // If parsing fails, an exception is thrown, so catch it. expired tokens and illegal tokens can cause parsing to fail.
        try {
            // Parsing (including verification of signatures)
            jwt = JWTUtil.parseToken(token);

            // Validation algorithms and timing
            JWTValidator validator = JWTValidator.of(jwt);
            // Validation Algorithms
            validator.validateAlgorithm(JWTSignerUtil.hs256(secretKeyBytes));
        } catch (Exception e) {
            log.error("Failed token parsing and validation");
            return null;
        }
        return jwt;
    }



}