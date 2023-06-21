package com.imyuewang.EduCity.config;

import org.springframework.util.DigestUtils;

/**
 * @ClassName PasswordEncoder
 * @Description
 * @Author Yue Wang
 * @Date 2023/6/21 17:53
 **/
public class PasswordEncoder {

    public static String encode(CharSequence rawPassword) {
        return DigestUtils.md5DigestAsHex(rawPassword.toString().getBytes());
    }

    public static boolean matches(CharSequence rawPassword, String encodedPassword) {
        return encodedPassword.equals(DigestUtils.md5DigestAsHex(rawPassword.toString().getBytes()));
    }
}
