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

    //DigestUtils.md5DigestAsHex(rawPassword.toString().getBytes()) 将原始密码使用 MD5 算法进行编码，并返回编码后的十六进制字符串。
    //然后通过 encodedPassword.equals(...) 比较编码后的密码和给定的编码密码是否相等，
    //如果相等，返回 true，表示密码匹配；否则返回 false，表示密码不匹配。

    public static boolean matches(CharSequence rawPassword, String encodedPassword) {
        return encodedPassword.equals(DigestUtils.md5DigestAsHex(rawPassword.toString().getBytes()));
    }
}
