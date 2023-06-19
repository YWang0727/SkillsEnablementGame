package com.EduCity.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.EduCity.enums.ResultCode;
import com.EduCity.exception.ApiException;
import com.EduCity.mapper.UserMapper;
import com.EduCity.model.entity.User;
import com.EduCity.model.param.LoginParam;
import com.EduCity.model.param.RegisterParam;
import com.EduCity.model.param.UserParam;
import com.EduCity.model.vo.UserDetailsVO;
import com.EduCity.model.vo.UserVO;
import com.EduCity.security.JwtManager;
import com.EduCity.service.UserService;
import com.EduCity.util.MailUtil;
import com.EduCity.util.SecurityContextUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

/**
* @author Yue Wang
* @description 针对表【user】的数据库操作Service实现
* @createDate 2023-06-18 20:43:08
*/
@Slf4j
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
    implements UserService {

    @Autowired
    private MailUtil mailUtil;
    @Value("${project.path}")
    private String projectPath;
    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    private User registeringUser;

    @Override
    public UserVO login(LoginParam loginParam) {
        // Verify user from database
        User user = this.lambdaQuery()
                .eq(StrUtil.isNotBlank(loginParam.getEmail()), User::getEmail, loginParam.getEmail())
                .one();

        // Throw error if user or password is wrong
        if(user == null || !passwordEncoder.matches(loginParam.getPassword(), user.getPassword())){
            throw new ApiException(ResultCode.VALIDATE_FAILED, "Username or password is incorrect！");
        }
        // Generate token
        return getUserVO(user);
    }

    @Override
    public String updateToken() {
        String email = SecurityContextUtil.getCurrentUser().getEmail();
        return JwtManager.generate(email);
    }

    private UserVO getUserVO(User user) {
        UserVO userVO = new UserVO();
        BeanUtil.copyProperties(user, userVO);
        userVO.setToken(JwtManager.generate(user.getEmail()));

        return userVO;
    }

    @Override
    public void emailVerification(UserParam param) {
        // check email format
        if(!mailUtil.isEmail(param.getEmail())){
            throw new ApiException(ResultCode.FAILED,"Incorrect email format.");
        }

        // check if email exists
        if (lambdaQuery().eq(User::getEmail, param.getEmail()).one() != null) {
            throw new ApiException(ResultCode.FAILED,"Email already exists.");
        }

        // new user
        registeringUser = new User();
        registeringUser.setEmail(param.getEmail());
        // set user status to false
        registeringUser.setIsactive(0);

        // send active code
        String activeCode = UUID.randomUUID().toString();
        // Send an email to the user's email address that contains an activation code
        String text = "E-mail registration successful! Your activation code is: " + activeCode;
        mailUtil.sendMail(registeringUser.getEmail(), text, "EduCity Activation Email");

        // Save the activation code and compare it when activating
        registeringUser.setActivecode(activeCode);

        save(registeringUser);
    }

    @Override
    public void active(String activeCode) {
        // Search for users by activation code
        User user = lambdaQuery().eq(User::getActivecode, activeCode).one();

        if (user != null) {
            // Set user status to active
            user.setIsactive(1);
            lambdaUpdate().eq(User::getActivecode, activeCode).update(user);
            // 'Next' button to activate and proceed to the next step of registration
        } else {
            // Delete the original record from the database
            lambdaUpdate().eq(User::getActivecode, activeCode).remove();
            registeringUser = null;
            // ask the user to re-verify by filling in the email address again
        }
    }

    @Override
    public void createUser(UserParam param) {
        // encode password
        String password = param.getPassword();
        registeringUser.setPassword(passwordEncoder.encode(password));

        // set username
        String name = param.getName();
        registeringUser.setName(name);

        // save user
        updateById(registeringUser);
        registeringUser = null;
    }

//    @Override
//    public void update(UserParam param) {
//        updateRoles(param);
//    }
//
//    @Override
//    public User getUserByUsername(String username) {
//        if(StrUtil.isBlank(username)){
//            throw new ApiException(ResultCode.VALIDATE_FAILED);
//        }
//        return this.lambdaQuery().eq(User::getUsername, username).one();
//    }
//
//    @Override
//    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
//        // Get user by username
//        User user = this.getUserByUsername(username);
//        // Get permissionIds and tranfer them to `SimpleGrantedAuthority` Object
//        Set<SimpleGrantedAuthority> authorities = permissionService.getIdsByUserId(user.getId())
//                .stream()
//                .map(String::valueOf)
//                .map(SimpleGrantedAuthority::new)
//                .collect(Collectors.toSet());
//        return new UserDetailsVO(user, authorities);
//    }


}




