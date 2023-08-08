package com.imyuewang.EduCity;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.imyuewang.EduCity.controller.api.AuthController;
import com.imyuewang.EduCity.controller.api.LearningController;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.mapper.UserQuizMapper;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.entity.UserQuiz;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.service.UserQuizService;
import com.imyuewang.EduCity.service.impl.UserServiceImpl;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;

/**
 * @ClassName EduCityCityMapTests
 * @Description
 * @Author hanyu
 * @Date 2023/8/9
 **/
@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class EduCityTakenMapCellTests {

    @Autowired
    UserQuizService userQuizService;

    @Resource
    UserQuizMapper userQuizMapper;

    @Autowired
    UserServiceImpl userServiceImpl;

    @Autowired
    LearningController learningController;

    @Autowired
    AuthController authController;

    private static UserQuizMapper staticUserQuizMapper;

    static Long id;

    @BeforeAll
    public static void setUp(@Autowired UserServiceImpl userServiceImpl,@Autowired AuthController authController,@Autowired UserQuizMapper userQuizMapper, @Autowired UserMapper userMapper) {
        staticUserQuizMapper = userQuizMapper;

        RegisterParam param = new RegisterParam();
        param.setEmail("test@gmail.com");
        param.setActivecode("111111");
        param.setName("testUser");
        param.setPassword("123456");

        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("email", "test@gmail.com");
        int userCount = userMapper.selectCount(queryWrapper);
        if(userCount != 1){
            authController.register(param);
        }
        User user = userServiceImpl.getUserByEmail("test@gmail.com");
        id = user.getId();
    }


    @Test
    @Order(1)
    void testCompleteLesson1(){

    }

    @Test
    @Order(2)
    void testCompleteLesson2(){

    }

    @Test
    @Order(3)
    void testSubmitQuiz1(){

    }


    @Test
    @Order(4)
    void testSubmitQuiz2(){

    }

    // SubmitQuiz exception
    @Test
    @Order(5)
    void testSubmitQuiz3(){

    }


    @AfterAll
    static void cleanDatabase(){
        staticUserQuizMapper.delete(new QueryWrapper<UserQuiz>().eq("id", id));
    }
}
