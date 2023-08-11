package com.imyuewang.EduCity;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.imyuewang.EduCity.controller.api.AuthController;

import com.imyuewang.EduCity.controller.api.UserController;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.LoginParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.security.JwtManager;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;

/**
 * @Author: Kathy
 */
@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class EduCityLoginRegisterTests {

    @Resource
    private AuthController authController;
    @Resource
    private UserController userController;

    private static UserMapper userMapper;

    private static CitymapMapper citymapMapper;

    @BeforeAll
    public static void setUp(@Autowired UserMapper userMapper, @Autowired CitymapMapper citymapMapper) {
        EduCityLoginRegisterTests.userMapper = userMapper;
        EduCityLoginRegisterTests.citymapMapper = citymapMapper;
    }
    /**********************    Success Cases    ***********************/
    @Test
    @Order(1)
    void testActiveEmail() {
        RegisterParam param = new RegisterParam();
        param.setEmail("test@gmail.com");
        ResultVO resultVO = authController.getActiveCode(param);
        Assertions.assertEquals(4002, resultVO.getCode());
    }

    @Test
    @Order(2)
    void testRegister() {
        RegisterParam param = new RegisterParam();
        param.setEmail("test@gmail.com");
        ResultVO resultVO = authController.getActiveCode(param);
        String activeCode = (String) resultVO.getData();
        param.setActivecode(activeCode);
        param.setName("test");
        param.setPassword("123456");
        resultVO = authController.register(param);
        Assertions.assertEquals(0000, resultVO.getCode());
    }

    @Test
    @Order(3)
    void testLogin() {
        LoginParam param = new LoginParam();
        param.setEmail("test@gmail.com");
        param.setPassword("123456");
        ResultVO resultVO = authController.login(param);
        Assertions.assertEquals(0000, resultVO.getCode());
        Assertions.assertNotNull(resultVO.getData());
    }

    @Test
    @Order(4)
    void testRefreshToken() {
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>().eq(User::getEmail, "test@gmail.com"));
        String refreshToken = JwtManager.generate(user.getId(), 24 * 60);
        System.out.println(refreshToken);
        ResultVO resultVO = userController.refreshAccessToken(refreshToken);
        Assertions.assertEquals(0000, resultVO.getCode());
        System.out.println(resultVO.getData());
    }


    /**********************    Error Cases    ***********************/
    @Test
    @Order(5)
    void testActiveEmailExisted() {
        RegisterParam param = new RegisterParam();
        param.setEmail("test@gmail.com");
        ResultVO resultVO = authController.checkEmailIsExisted(param);
        Assertions.assertEquals(4000, resultVO.getCode());
    }

    @Test
    @Order(6)
    void testLoginWrongPassword() {
        LoginParam loginParam = new LoginParam();
        loginParam.setEmail("test@gmail.com");
        loginParam.setPassword("1234567");
        ApiException apiException = Assertions.assertThrows(ApiException.class, () -> {
            authController.login(loginParam);
        });
        Assertions.assertEquals(4003, apiException.getResultCode().getCode());
    }

//    @AfterAll
//    static void cleanDatabase(){
//        // Get the test user's id
//        User user = userMapper.selectOne(new LambdaQueryWrapper<User>().eq(User::getEmail, "test@gmail.com"));
//        // Delete the test user
//        userMapper.delete(new LambdaQueryWrapper<User>().eq(User::getEmail, "test@gmail.com"));
//        // Delete the test user's map
//        citymapMapper.delete(new LambdaQueryWrapper<Citymap>().eq(Citymap::getId, user.getId()));
//
//    }
}
