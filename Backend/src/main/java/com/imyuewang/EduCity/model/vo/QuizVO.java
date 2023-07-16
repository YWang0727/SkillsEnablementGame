package com.imyuewang.EduCity.model.vo;

import com.imyuewang.EduCity.model.entity.UserQuiz;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;

/**
 * @ClassName QuizVO
 * @Description
 * @Author Yue Wang
 * @Date 2023/7/2 19:29
 **/
@Data
@Accessors(chain = true)
public class QuizVO {

    private int attempts;

    private int scoreDifference;

    // each module's status
    private List<UserQuiz> completeList;

    // each knowledge's status: 0-not started, 1-in progress, 2-completed
    private int[] statusList;
}
