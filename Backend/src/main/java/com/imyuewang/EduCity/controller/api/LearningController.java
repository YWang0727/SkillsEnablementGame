package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.annotation.Auth;
import com.imyuewang.EduCity.model.param.QuizParam;
import com.imyuewang.EduCity.model.param.UserParam;
import com.imyuewang.EduCity.model.vo.QuizVO;
import com.imyuewang.EduCity.service.UserQuizService;
import com.imyuewang.EduCity.service.UserService;
import com.imyuewang.EduCity.util.CommonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * @ClassName LearningController
 * @Description
 * @Author Yue Wang
 * @Date 2023/7/2 12:53
 **/
@Slf4j
@RestController
@RequestMapping("/learn")
@Api(tags = "Learning Management Interface")
public class LearningController {

    @Autowired
    private UserQuizService userQuizService;

    @PostMapping("/complete")
    @ApiOperation(value = "Lesson completed")
    public String completeLesson(@RequestBody QuizParam param) {
        userQuizService.completeLesson(param);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

    @PostMapping("/submit")
    @ApiOperation(value = "Submit quiz")
    public QuizVO submitQuiz(@RequestBody QuizParam param) {
        return userQuizService.submitQuiz(param);
    }

    @PostMapping("/status")
    @ApiOperation(value = "get user's learning status")
    public QuizVO getStatus(@RequestBody QuizParam param) {
        return userQuizService.getStatus(param);
    }

}
