package com.imyuewang.EduCity.config;

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
     * @return current user id
     */
    public static String getCurrentUserName() {
        return user.get();
    }
}
