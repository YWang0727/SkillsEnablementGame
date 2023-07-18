package com.imyuewang.EduCity.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.imyuewang.EduCity.config.PasswordEncoder;
import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.model.param.LoginParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.param.UserParam;
import com.imyuewang.EduCity.model.vo.UserVO;
import com.imyuewang.EduCity.security.JwtManager;
import com.imyuewang.EduCity.util.MailUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.service.UserService;
import com.imyuewang.EduCity.mapper.UserMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.security.SecureRandom;
import java.util.Objects;
import java.util.UUID;

import static com.sun.org.apache.xalan.internal.xsltc.compiler.Constants.CHARACTERS;

/**
* @author Sarah Wang
* @description 针对表【user】的数据库操作Service实现
* @createDate 2023-06-21 15:42:32
*/
@Service
@Slf4j
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
        implements UserService {

    @Autowired
    private MailUtil mailUtil;

    @Resource
    private UserMapper userMapper;

    private User registeringUser;

    @Override
    public UserVO login(LoginParam loginParam) {
        // Verify user from database
        LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<User>();
        lqw.eq(StrUtil.isNotBlank(loginParam.getEmail()), User::getEmail, loginParam.getEmail());

        User user = userMapper.selectOne(lqw);

        System.out.println(user);

        // Throw error if user or password is wrong
        if(user == null || !Objects.equals(loginParam.getPassword(), user.getPassword())){
            throw new ApiException(ResultCode.VALIDATE_FAILED, "Email or password is incorrect！");
        }
        // Generate token
        //JwtManager.generate(user.getEmail());
        return getUserVO(user);
    }

    private UserVO getUserVO(User user) {
        UserVO userVO = new UserVO();
        BeanUtil.copyProperties(user, userVO);
        //userVO.setToken(JwtManager.generate(user.getEmail()));

        return userVO;
    }

    @Override
    public UserVO emailVerification(UserParam param) {
        UserVO uservo = new UserVO();
        // check email format
        if(!mailUtil.isEmail(param.getEmail())){
            uservo.setErroMsg("Incorrect email format.");
            throw new ApiException(ResultCode.FAILED,"Incorrect email format.");
        }

        // check if email exists
        if (lambdaQuery().eq(User::getEmail, param.getEmail()).one() != null) {
            uservo.setErroMsg("Email already exists.");
            throw new ApiException(ResultCode.FAILED,"Email already exists.");
        }
        uservo.setEmail(param.getEmail());
        return uservo;
    }

    @Override
    public void active(UserParam param) {
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
        registeringUser.setPassword(PasswordEncoder.encode(password));

        // set username
        String name = param.getName();
        registeringUser.setName(name);

        // save user
        updateById(registeringUser);
        registeringUser = null;
    }

    @Override
    public UserVO register(User newUser) {
        userMapper.insert(newUser);
        UserVO uservo = getUserVOFromUser(newUser);
        uservo.setFlag(true);
        return uservo;
    }

    private UserVO getUserVOFromUser(User user) {
        UserVO userVO = new UserVO();
        BeanUtil.copyProperties(user, userVO);
        //userVO.setToken(JwtManager.generate(user.getEmail()));

        return userVO;
    }

    public String generateRandomString() {
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(4);

        for (int i = 0; i < 4; i++) {
            int randomIndex = random.nextInt(CHARACTERS.length());
            char randomChar = CHARACTERS.charAt(randomIndex);
            sb.append(randomChar);
        }

        return sb.toString();
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




