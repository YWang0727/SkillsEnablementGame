package com.imyuewang.EduCity;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.exceptions.ValidateException;
import cn.hutool.jwt.*;
import cn.hutool.jwt.signers.JWTSignerUtil;
import com.google.gson.Gson;
import com.imyuewang.EduCity.controller.api.AuthController;
import com.imyuewang.EduCity.controller.api.UserController;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.LoginParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.vo.UserVO;
import org.junit.jupiter.api.Test;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import springfox.documentation.spring.web.json.Json;

import java.util.HashMap;
import java.util.Map;

@SpringBootTest
class EduCityApplicationTests {

    @Autowired
    private AuthController authController;

    @Test
    void testLogin(){
        LoginParam loginParam = new LoginParam();
        loginParam.setEmail("kathy@gmail.com");
        loginParam.setPassword("1234");

        UserVO LoginV0 = authController.login(loginParam);
        System.out.println(LoginV0);

    }

    @Test
    void testRegister(){
        RegisterParam param = new RegisterParam();
        param.setEmail("kahty6@gmail.com");
        param.setCode("3333");
        param.setName("kathy2");
        param.setPassword("2331");

        User newUser = new User();
        BeanUtil.copyProperties(param, newUser);
        //newUser.setCitymap(2L);
        newUser.setIsactive(1);
        newUser.setAvatar(null);

        UserVO RegisterV0 = authController.register(newUser);
        System.out.println();

    }

    @Test
    void contextLoads() {
    }


    @Test
    void testHutoolsJWT(){

        byte[] secretKeyBytes = "my_secret_key".getBytes();


        DateTime now = DateUtil.date();
        System.out.println(now);
//        DateTime ddl = now.offset(DateField.MINUTE, 30);
        DateTime ddl = DateUtil.offsetMinute(now, 30);
        System.out.println(ddl);

        Map<String, Object> map = new HashMap<String, Object>() {
            {
                put(JWTPayload.ISSUED_AT, now);
                put(JWTPayload.EXPIRES_AT, ddl);
                put(JWTPayload.NOT_BEFORE, now);
                put("username", "sean");
                put("role", "admin");
            }
        };

        String token = JWTUtil.createToken(map, secretKeyBytes);

        final JWT jwt = JWTUtil.parseToken(token);

        Object jwtHeader = jwt.getHeader(JWTHeader.TYPE);
        System.out.println(jwtHeader);
        Object username = jwt.getPayload("username");
        System.out.println(username);
        Object role = jwt.getPayload("role");
        System.out.println(role);


        // 验证签名
        boolean verify = JWTUtil.verify(token, secretKeyBytes);
        System.out.println(verify);

        try {

            JWTValidator validator = JWTValidator.of(jwt);

            // 验证算法
            validator.validateAlgorithm(JWTSignerUtil.hs256(secretKeyBytes));

            // 验证时间
            JWTValidator.of(jwt).validateDate();

        } catch (ValidateException e) {
            System.out.println(e.getMessage());
        }

    }



}
