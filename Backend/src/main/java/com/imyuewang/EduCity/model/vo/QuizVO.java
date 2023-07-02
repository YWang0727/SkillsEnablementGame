package com.imyuewang.EduCity.model.vo;

import lombok.Data;
import lombok.experimental.Accessors;

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
}
