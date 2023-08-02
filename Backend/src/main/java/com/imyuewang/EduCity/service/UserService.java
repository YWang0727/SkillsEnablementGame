package com.imyuewang.EduCity.service;

import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.LoginParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.param.UserParam;
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.UserVO;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;

/**

* @description 针对表【user】的数据库操作Service
* @createDate 2023-06-21 15:42:32
*/
@Service
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

    ResultVO checkEmailIsExisted(RegisterParam param);

    ResultVO getActiveCode(RegisterParam param);

    ResultVO register(RegisterParam newUser);

}
