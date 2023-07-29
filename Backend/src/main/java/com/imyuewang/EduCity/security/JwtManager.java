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
     * The expiration time is currently set to 30 minutes,
     * this configuration depends on business requirements.
     */
    private final static Integer EXPIRATION = 30;

    /**
     * Generate jwt token
     * @author Yue Wang
     * @date 14:54 2023/5/7
     * @param userName username
     * @return jwt token
     **/
    public static String generate(String userName) {
        DateTime now = DateUtil.date();
        DateTime ddl = DateUtil.offsetMinute(now, EXPIRATION);
        Map<String, Object> map = new HashMap<String, Object>() {
            {
                put(JWTPayload.ISSUED_AT, now);
                put(JWTPayload.EXPIRES_AT, ddl);
                put(JWTPayload.NOT_BEFORE, now);
                put(JWTPayload.SUBJECT, userName); //put username in 'sub'
            }
        };
        //return "Bearer " + JWTUtil.createToken(map, secretKeyBytes);
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
        // 如果是空字符串直接返回null
        if(StrUtil.isBlank(token)){
            return null;
        }
        JWT jwt = null;
        // 解析失败了会抛出异常，所以要捕捉一下。token过期、token非法都会导致解析失败
        try {
            // 解析（包含验证签名）
            jwt = JWTUtil.parseToken(token);

            // 验证算法和时间
            JWTValidator validator = JWTValidator.of(jwt);
            // 验证算法
            validator.validateAlgorithm(JWTSignerUtil.hs256(secretKeyBytes));
            // 验证时间
            JWTValidator.of(jwt).validateDate();
        } catch (Exception e) {
            log.error("token解析和验证失败");
            return null;
        }
        return jwt;
    }



}