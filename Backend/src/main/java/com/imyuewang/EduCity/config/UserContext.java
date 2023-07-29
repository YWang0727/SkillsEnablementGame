package com.imyuewang.EduCity.config;

import org.springframework.context.annotation.Configuration;

/**
 * @ClassName UserContext
 * @Description
 * @Author Yue Wang
 * @Date 2023/6/21 17:46
 **/
public final class UserContext {
    private static final ThreadLocal<String> user = new ThreadLocal<String>();
    public static void add(String userName) {
        user.set(userName);
    }
    public static void remove() {
        user.remove();
    }
    /**
     * @return 当前登录用户的用户名
     */
    public static String getCurrentUserName() {
        return user.get();
    }
}
