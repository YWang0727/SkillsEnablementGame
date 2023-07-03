package com.imyuewang.EduCity.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.conditions.query.LambdaQueryChainWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.entity.UserQuiz;
import com.imyuewang.EduCity.model.param.QuizParam;
import com.imyuewang.EduCity.model.vo.QuizVO;
import com.imyuewang.EduCity.service.UserQuizService;
import com.imyuewang.EduCity.mapper.UserQuizMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

/**
* @author Yue Wang
* @description 针对表【user_quiz】的数据库操作Service实现
* @createDate 2023-06-21 15:42:32
*/
@Service
@Slf4j
public class UserQuizServiceImpl extends ServiceImpl<UserQuizMapper, UserQuiz>
    implements UserQuizService{

    @Override
    public void completeLesson(QuizParam param){

        // if this lesson has already completed
        if (this.lambdaQuery()
                .eq(UserQuiz::getId, param.getId())
                .eq(UserQuiz::getQuizid, param.getQuizId())
                .count() != 0) {
            return;
        }

        // create a new user_quiz data
        UserQuiz userQuiz = new UserQuiz();
        userQuiz.setId(param.getId());
        userQuiz.setQuizid(param.getQuizId());
        userQuiz.setTopscore(0);
        userQuiz.setAttempts(0);

        save(userQuiz);
    }

    @Override
    public QuizVO submitQuiz(QuizParam param){

        UserQuiz userQuiz = this.lambdaQuery().eq(UserQuiz::getId, param.getId()).eq(UserQuiz::getQuizid, param.getQuizId()).one();

        if(userQuiz == null){
            throw new ApiException(ResultCode.FAILED,"This user_quiz record does not exist");
        }

        int scoreDifference = param.getCurrScore() - userQuiz.getTopscore();

        // set attempts and topScore
        userQuiz.setAttempts(userQuiz.getAttempts() + 1);
        userQuiz.setTopscore(Math.max(param.getCurrScore(), userQuiz.getTopscore()));

        // update to database
        UpdateWrapper<UserQuiz> updateWrapper = Wrappers.update();
        updateWrapper.lambda().eq(UserQuiz::getId, userQuiz.getId()).eq(UserQuiz::getQuizid, userQuiz.getQuizid()).
                set(UserQuiz::getAttempts, userQuiz.getAttempts()).set(UserQuiz::getTopscore, userQuiz.getTopscore());
        update(null, updateWrapper);

        QuizVO quizVO = new QuizVO();
        quizVO.setAttempts(userQuiz.getAttempts()).setScoreDifference(scoreDifference);
        return quizVO;
    }

    @Override
    public QuizVO checkQuiz(QuizParam param){
        int knowledge = param.getKnowledge();

        LambdaQueryWrapper<UserQuiz> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.likeRight(UserQuiz::getQuizid, knowledge);

        List<UserQuiz> result = baseMapper.selectList(queryWrapper);

        QuizVO quizVO = new QuizVO();
        quizVO.setCompleteList(result);
        return quizVO;
    }
}




