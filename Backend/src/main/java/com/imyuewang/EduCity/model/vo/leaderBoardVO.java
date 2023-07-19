package com.imyuewang.EduCity.model.vo;

import com.imyuewang.EduCity.model.entity.UserQuiz;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;

/**
 * @ClassName LeaderBoardVO
 * @Description
 * @Author hanyu
 * @Date 2023/7/18
 **/
@Data
@Accessors(chain = true)
public class LeaderBoardVO {

    private long prosperity;

    private String name;

}
