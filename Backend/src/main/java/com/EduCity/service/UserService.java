package com.EduCity.service;

import com.EduCity.model.entity.User;
import com.EduCity.model.param.LoginParam;
import com.EduCity.model.param.RegisterParam;
import com.EduCity.model.param.UserParam;
import com.EduCity.model.vo.UserVO;
import com.baomidou.mybatisplus.extension.service.IService;

/**
* @author Yue Wang
* @description 针对表【user】的数据库操作Service
* @createDate 2023-06-19 14:06:50
*/
public interface UserService extends IService<User> {

//    User getUserByUsername(String username);

    /**
     * Log in
     * @author Yue Wang
     * @date 11:49 2023/5/7
     * @param loginParam Login form parameters
     * @return If the login is successful, the VO object is returned, and an exception is thrown if it fails
     **/
    UserVO login(LoginParam loginParam);

    void emailVerification(UserParam param);

    void active(String activeCode);

    /**
     * Add new user
     * @author Yue Wang
     * @date 11:56 2023/5/7
     * @param param user form parameters
     **/
    void createUser(UserParam param);

    /**
     * Update user information
     * @author Yue Wang
     * @date 11:56 2023/5/7
     * @param param user form parameters
     **/
    //void update(UserParam param);

    String updateToken();
}
