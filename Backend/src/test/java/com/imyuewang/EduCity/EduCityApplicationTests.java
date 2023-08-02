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
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.UserVO;
import com.imyuewang.EduCity.security.JwtManager;
import org.junit.jupiter.api.Test;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import springfox.documentation.spring.web.json.Json;

import javax.xml.transform.Result;
import java.util.HashMap;
import java.util.Map;

@SpringBootTest
class EduCityApplicationTests {

    @Autowired
    private AuthController authController;

    @Autowired
    private UserController userController;

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
        param.setActivecode("333333");
        param.setName("kathy2");
        param.setPassword("2331");

        ResultVO resultVO  = authController.register(param);
        System.out.println(resultVO);

    }

    @Test
    void testSendEmail(){
        RegisterParam param = new RegisterParam();
        param.setEmail("zhangxinyue3667@gmail.com");
        authController.getActiveCode(param);
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
