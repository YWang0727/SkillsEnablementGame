package com.imyuewang.EduCity.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.imyuewang.EduCity.config.PasswordEncoder;
import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import com.imyuewang.EduCity.mapper.TakenmapcellMapper;
import com.imyuewang.EduCity.mapper.UserQuizMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.entity.Takenmapcell;
import com.imyuewang.EduCity.model.entity.UserQuiz;
import com.imyuewang.EduCity.model.param.LoginParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.param.UserParam;
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.UserVO;
import com.imyuewang.EduCity.security.JwtManager;
import com.imyuewang.EduCity.service.CitymapService;
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
import java.util.Base64;
import java.util.Objects;
import java.util.Random;
import java.util.UUID;




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
    public UserVO login(LoginParam loginParam) {
        //get user from database
        User user = getUserByEmail(loginParam.getEmail());
        System.out.println(user);

        // Throw error if user or password is wrong
        if(user == null || !Objects.equals(loginParam.getPassword(), user.getPassword())){
            throw new ApiException(ResultCode.PASSWORD_ERROR, "Email or password is incorrect!");
        }
        // Generate token
        //JwtManager.generate(user.getEmail());

        return getUserVOFromUser(user);
    }

    @Override
    public ResultVO checkEmailIsExisted(RegisterParam param) {
        System.out.println(param.getEmail());
        // check if email exists
        if (getUserByEmail(param.getEmail()) != null) {
            return new ResultVO(ResultCode.EMAIL_FOUND,null);
        }else{
            return new ResultVO(ResultCode.EMAIL_NOT_FOUND,null);
        }
    }

    /********************************************/
    /**************    REGISTER    **************/
    /********************************************/
    @Override
    public UserVO register(User newUser) {
        userMapper.insert(newUser);
        //initialize values in tables
        initializeValuesInTable(newUser);

        return getUserVOFromUser(newUser);
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
        citymapMapper.insert(new Citymap(newUser.getId(), "My City", 0L,0L,0));
        //initialize user_quiz table
        userQuizMapper.insert(new UserQuiz(newUser.getId()));
    }

    private User setCityMapId(User newUser){
        User userWithId = getUserByEmail(newUser.getEmail());
        //set citymap id of new user
        newUser.setCitymap(userWithId.getId());
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
        String emailText = "E-mail registration successful! Your activation code is: " + activeCode;
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




