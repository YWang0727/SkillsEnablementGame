package com.imyuewang.EduCity.util;

import cn.hutool.jwt.JWT;
import com.imyuewang.EduCity.config.UserContext;
import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.security.JwtManager;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

/**
 * @ClassName LoginInterceptor
 * @Description
 * @Author Yue Wang
 * @Date 2023/6/21 17:40
 **/
@Component
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        System.out.println(request.getRequestURL());
        System.out.println(request.getHeader("Authorization"));
        String token = request.getHeader("Authorization");
        if(token == null){
            throw new ApiException(ResultCode.UNAUTHORIZED, "You are not logged in, please log in first!");
        }
        // 从请求头中获取token字符串并解析
        JWT result = JwtManager.parse(request.getHeader("Authorization"));
        // 解析成功，result不为空，放行
        if (result != null) {
            System.out.println("拦截器放行了");
            return true;
        }
        System.out.println("拦截");
        throw new ApiException(ResultCode.TOKEN_EXPIRED, "Identity verification failed, please log in again!");
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // 结束后移除上下文对象
        UserContext.remove();
        HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
    }
}
