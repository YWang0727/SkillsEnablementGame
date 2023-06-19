package com.EduCity.util;

import com.EduCity.model.entity.User;
import com.EduCity.model.vo.UserDetailsVO;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

/**
 * @ClassName SecurityContextUtil
 * @Description TODO
 * @Author Yue Wang
 * @Date 2023/5/7 12:44
 * @Version 1.0
 **/
public class SecurityContextUtil {

    /**
     * Get user ID from spring security context
     * @author Yue Wang
     * @date 14:52 2023/5/7
     * @return User ID
     **/
    public static String getCurrentUserEmail(){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
        return userDetails.getEmail();
    }

    /**
     * Get user object from spring security context
     * @author Yue Wang
     * @date 12:14 2023/5/9
     * @return User Object
     **/
    public static User getCurrentUser(){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
        return userDetails.getUser();
    }

}
