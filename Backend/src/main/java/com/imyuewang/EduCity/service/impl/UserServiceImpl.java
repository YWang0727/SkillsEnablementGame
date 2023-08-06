package com.imyuewang.EduCity.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.jwt.JWT;
import cn.hutool.jwt.JWTPayload;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import com.imyuewang.EduCity.mapper.TakenmapcellMapper;
import com.imyuewang.EduCity.mapper.UserQuizMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.param.LoginParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.UserVO;
import com.imyuewang.EduCity.security.JwtManager;
import com.imyuewang.EduCity.util.MailUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.service.UserService;
import com.imyuewang.EduCity.mapper.UserMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Base64;
import java.util.Objects;
import java.util.Random;


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
    /**********   ALL MAPPERS  ************/
    @Resource
    private UserMapper userMapper;
    @Resource
    private CitymapMapper citymapMapper;
    @Resource
    private TakenmapcellMapper takenmapcellMapper;
    @Resource
    private UserQuizMapper userQuizMapper;

    /******************************************/
    /**************    LOG IN    **************/
    /******************************************/
    @Override
    public ResultVO login(LoginParam loginParam) {
        //get user from database
        User user = getUserByEmail(loginParam.getEmail());
        System.out.println(user);
        if(user == null){
            throw new ApiException(ResultCode.PASSWORD_ERROR, "Password or email is incorrect!\nPlease try again!");
        }
        // Throw error if user or password is wrong
        String pwLogin = loginParam.getPassword();
        String pwToken = user.getPassword();
        //parser pwToken
        JWT jwt = JwtManager.parsePwToken(pwToken);
        if(jwt == null){
            throw new ApiException(ResultCode.PASSWORD_ERROR, "Password or email is incorrect!\nPlease try again!");
        }
        String pw = jwt.getPayload(JWTPayload.SUBJECT).toString();
        if(user == null || !Objects.equals(pw, pwLogin)){
            throw new ApiException(ResultCode.PASSWORD_ERROR, "Password or email is incorrect!\nPlease try again!");
        }
        // Generate two tokens
        //1. access token 5min
        String accessToken = JwtManager.generate(user.getId(),5);
        //2. refresh token 24h
        String refreshToken = JwtManager.generate(user.getId(),24 * 60);
        UserVO userVO = getUserVOFromUser(user);
        userVO.setAccessToken(accessToken);
        userVO.setRefreshToken(refreshToken);
        //set isFirst to 0
        user.setIsFirst(0);
        userMapper.updateById(user);
        //return userVO
        return new ResultVO(userVO);
    }

    @Override
    public ResultVO checkEmailIsExisted(RegisterParam param) {
        System.out.println(param.getEmail());
        // check if email exists
        if (getUserByEmail(param.getEmail()) != null) {
            return new ResultVO(ResultCode.EMAIL_FOUND,"Email is already existed!\nPlease Try another one!");
        }else{
            return new ResultVO(ResultCode.EMAIL_NOT_FOUND,"Email is valid!\nPlease continue!");
        }
    }

    /********************************************/
    /**************    REGISTER    **************/
    /********************************************/
    @Override
    public ResultVO<String> register(RegisterParam newUser) {
        String tokenPassword = JwtManager.generate(newUser.getPassword());
        User user = new User();
        BeanUtil.copyProperties(newUser, user);
        user.setPassword(tokenPassword);
        user.setIsFirst(1);
        userMapper.insert(user);
        //initialize values in tables
        initializeValuesInTable(user);

        return new ResultVO<>("             Resgister success! Pleace log in!");
    }

    private UserVO getUserVOFromUser(User user) {
        UserVO userVO = new UserVO();
        BeanUtil.copyProperties(user, userVO);

        if(user.getAvatar() != null){
            String avatarStr = Base64.getEncoder().encodeToString(user.getAvatar());
            userVO.setAvatarStr(avatarStr);
        }
        
        //userVO.setToken(JwtManager.generate(user.getEmail()));
        return userVO;
    }

    private void initializeValuesInTable(User newUser){
        //set city map id == user id
        newUser = setCityMapId(newUser);
        //initialize citymap table
        citymapMapper.insert(new Citymap(newUser.getId(), "My City", 0L,0L,1));
    }

    private User setCityMapId(User newUser){
        User userWithId = getUserByEmail(newUser.getEmail());
        //set citymap id of new user
        newUser.setCityMap(userWithId.getId());
        userMapper.updateById(newUser);
        //return newuser with id and citymap id
        return getUserByEmail(newUser.getEmail());
    }

    /************************************************/
    /**************    ACTIVE EMAIL    **************/
    /************************************************/
    @Override
    public ResultVO getActiveCode(RegisterParam param) {
        // send active code
        int codeLength = 6;
        String activeCode = generateActiveCode(codeLength);
        // Send an email to the user's email address that contains an activation code
        String emailText = "E-mail registration successful! \nYour activation code is: " + activeCode;
        mailUtil.sendMail(param.getEmail(), emailText, "EduCity Activation Email");

        return new ResultVO(ResultCode.EMAIL_SENT, activeCode);
    }

    public String generateActiveCode(int codeLength) {
        StringBuilder sb = new StringBuilder();
        Random random = new Random();

        for (int i = 0; i < codeLength; i++) {
            int digit = random.nextInt(10); // 0~9
            sb.append(digit);
        }

        return sb.toString();
    }

    public User getUserByEmail(String email){
        LambdaQueryWrapper<User> lqw = new LambdaQueryWrapper<>();
        lqw.eq(User::getEmail, email);
        return userMapper.selectOne(lqw);
    }

    /********************************************************/
    /**************    Refresh Access Token    **************/
    /********************************************************/
    public ResultVO refreshAccessToken(String refreshToken) {
        //get userId from refresh token
        JWT jwt = JwtManager.parse(refreshToken);
        Long userId = (Long)jwt.getPayload(JWTPayload.SUBJECT);
        //generate new access token
        String newAccessToken = JwtManager.generate(userId,5);
        //return new access token and refresh token
        return new ResultVO(newAccessToken);
    }

}




