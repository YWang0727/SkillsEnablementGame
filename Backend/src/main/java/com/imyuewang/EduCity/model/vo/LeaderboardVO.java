package com.imyuewang.EduCity.model.vo;

import com.imyuewang.EduCity.model.entity.UserQuiz;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;

/**
 * @ClassName LeaderboardVO
 * @Description
 * @Author hanyu
 * @Date 2023/7/18
 **/
@Data
@Accessors(chain = true)
public class LeaderboardVO {
    /**
     * user's info
     * all info
     */
    private long prosperity;
    private String name;

    private int total_num;

    private String[] all_name;
    private long[] all_prosperity;
    private long[] all_id;

}