package com.imyuewang.EduCity;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.imyuewang.EduCity.controller.api.AuthController;
import com.imyuewang.EduCity.controller.api.LearningController;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.mapper.UserQuizMapper;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.entity.UserQuiz;
import com.imyuewang.EduCity.model.param.QuizParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.vo.QuizVO;
import com.imyuewang.EduCity.service.UserQuizService;
import com.imyuewang.EduCity.service.impl.UserServiceImpl;
import com.imyuewang.EduCity.util.CommonUtil;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;
import java.util.List;

/**
 * @ClassName EduCityLearningSceneTests
 * @Description
 * @Author Yue Wang
 * @Date 2023/8/4 13:46
 **/
@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class EduCityLearningSceneTests {

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


    // create a new user_quiz data
    @Test
    @Order(1)
    void testCompleteLesson1(){
        QuizParam param = new QuizParam();
        param.setId(id);
        param.setKnowledgeId(1);
        param.setQuizId(1);

        String result;
        result = learningController.completeLesson(param);

        // assert return result
        Assertions.assertEquals(CommonUtil.ACTION_SUCCESSFUL, result);

        // assert database
        QueryWrapper<UserQuiz> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id", id).eq("knowledgeId", 1).eq("quizId", 1);
        int count = userQuizMapper.selectCount(queryWrapper);
        Assertions.assertEquals(1, count);
    }

    // if this lesson has already completed
    @Test
    @Order(2)
    void testCompleteLesson2(){
        QuizParam param = new QuizParam();
        param.setId(id);
        param.setKnowledgeId(1);
        param.setQuizId(1);

        learningController.completeLesson(param);

        // assert database
        QueryWrapper<UserQuiz> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id", id).eq("knowledgeId", 1).eq("quizId", 1);
        int count = userQuizMapper.selectCount(queryWrapper);
        Assertions.assertEquals(1, count);

        QuizParam param2 = new QuizParam();
        param2.setId(id);
        param2.setKnowledgeId(1);
        param2.setQuizId(1);

        learningController.completeLesson(param2);
        queryWrapper.eq("id", id).eq("knowledgeId", 1).eq("quizId", 1);
        count = userQuizMapper.selectCount(queryWrapper);
        Assertions.assertEquals(1, count);

    }

    // First submission
    @Test
    @Order(3)
    void testSubmitQuiz1(){
        QuizParam param = new QuizParam();
        param.setId(id);
        param.setKnowledgeId(1);
        param.setQuizId(1);
        param.setScore(60);

        learningController.completeLesson(param);
        learningController.submitQuiz(param);

        QueryWrapper<UserQuiz> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id", id).eq("knowledgeId", 1).eq("quizId", 1);

        int count = userQuizMapper.selectCount(queryWrapper);
        UserQuiz userQuiz = userQuizMapper.selectById(id);

        Assertions.assertEquals(1, count);
        Assertions.assertEquals(1, userQuiz.getAttempts());
        Assertions.assertEquals(60, userQuiz.getTopscore());
    }

    // Highest Score Coverage and attempts
    @Test
    @Order(4)
    void testSubmitQuiz2(){
        QuizParam param2 = new QuizParam();
        param2.setId(id);
        param2.setKnowledgeId(1);
        param2.setQuizId(1);
        param2.setScore(90);
        learningController.submitQuiz(param2);
        UserQuiz userQuiz = userQuizMapper.selectById(id);
        Assertions.assertEquals(90, userQuiz.getTopscore());
        Assertions.assertEquals(2, userQuiz.getAttempts());

        QuizParam param3 = new QuizParam();
        param3.setId(id);
        param3.setKnowledgeId(1);
        param3.setQuizId(1);
        param3.setScore(80);
        learningController.submitQuiz(param3);
        userQuiz = userQuizMapper.selectById(id);
        Assertions.assertEquals(90, userQuiz.getTopscore());
        Assertions.assertEquals(3, userQuiz.getAttempts());
    }

    // SubmitQuiz exception
    @Test
    @Order(5)
    void testSubmitQuiz3(){
        QuizParam param = new QuizParam();
        param.setId(id);
        param.setKnowledgeId(2);
        param.setQuizId(1);
        param.setScore(90);

        Assertions.assertThrows(ApiException.class, () -> {
            learningController.submitQuiz(param);
        });
    }

    // check in progess
    @Test
    @Order(6)
    void testGetStatus1(){
        QuizParam param = new QuizParam();
        param.setId(id);

        QuizVO quizVO = learningController.getStatus(param);

        int[] expectedStatusList = {1, 0, 0, 0, 0};
        Assertions.assertArrayEquals(expectedStatusList, quizVO.getStatusList());

        LambdaQueryWrapper<UserQuiz> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(UserQuiz::getId, param.getId());
        List<UserQuiz> expectedCompleteList = userQuizMapper.selectList(queryWrapper);
        Assertions.assertEquals(expectedCompleteList, quizVO.getCompleteList());

    }

    // check completed
    @Test
    @Order(7)
    void testGetStatus2(){
        QuizParam param2 = new QuizParam();
        param2.setId(id);
        param2.setKnowledgeId(1);
        param2.setQuizId(2);
        learningController.completeLesson(param2);

        QuizParam param3 = new QuizParam();
        param3.setId(id);
        param3.setKnowledgeId(1);
        param3.setQuizId(3);
        learningController.completeLesson(param3);

        QuizParam param = new QuizParam();
        param.setId(id);
        QuizVO quizVO = learningController.getStatus(param);

        int[] expectedStatusList = {2, 0, 0, 0, 0};
        Assertions.assertArrayEquals(expectedStatusList, quizVO.getStatusList());

        LambdaQueryWrapper<UserQuiz> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(UserQuiz::getId, param.getId());
        List<UserQuiz> expectedCompleteList = userQuizMapper.selectList(queryWrapper);
        Assertions.assertEquals(expectedCompleteList, quizVO.getCompleteList());

    }

    // check more
    @Test
    @Order(8)
    void testGetStatus3(){
        QuizParam param2 = new QuizParam();
        param2.setId(id);
        param2.setKnowledgeId(2);
        param2.setQuizId(1);
        learningController.completeLesson(param2);

        QuizParam param3 = new QuizParam();
        param3.setId(id);
        param3.setKnowledgeId(2);
        param3.setQuizId(2);
        learningController.completeLesson(param3);

        QuizParam param = new QuizParam();
        param.setId(id);
        QuizVO quizVO = learningController.getStatus(param);

        int[] expectedStatusList = {2, 2, 0, 0, 0};
        Assertions.assertArrayEquals(expectedStatusList, quizVO.getStatusList());

        LambdaQueryWrapper<UserQuiz> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(UserQuiz::getId, param.getId());
        List<UserQuiz> expectedCompleteList = userQuizMapper.selectList(queryWrapper);
        Assertions.assertEquals(expectedCompleteList, quizVO.getCompleteList());

    }


    // clean database
    @AfterAll
    static void cleanDatabase(){
        staticUserQuizMapper.delete(new QueryWrapper<UserQuiz>().eq("id", id));
    }
}
