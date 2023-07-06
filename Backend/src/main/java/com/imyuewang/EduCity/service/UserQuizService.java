package com.imyuewang.EduCity.service;

import com.imyuewang.EduCity.model.entity.UserQuiz;
import com.baomidou.mybatisplus.extension.service.IService;
import com.imyuewang.EduCity.model.param.QuizParam;
import com.imyuewang.EduCity.model.vo.QuizVO;
import org.springframework.stereotype.Service;

/**
* @author Yue Wang
* @description 针对表【user_quiz】的数据库操作Service
* @createDate 2023-06-21 15:42:32
*/
@Service
public interface UserQuizService extends IService<UserQuiz> {

    void completeLesson(QuizParam param);

    QuizVO submitQuiz(QuizParam param);

    QuizVO getStatus(QuizParam param);
}
