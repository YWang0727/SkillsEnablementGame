package com.imyuewang.EduCity.model.param;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * @ClassName QuizParam
 * @Description Receive quiz-related parameters.
 * @Author Yue Wang
 * @Date 2023/7/2 18:40
 **/
@Data
public class QuizParam {

    private Long id;

    private int quizId;

    private int attempts;

    private int currScore;
}
