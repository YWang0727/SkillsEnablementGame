package com.imyuewang.EduCity.model.vo;

import lombok.Data;
import lombok.experimental.Accessors;

/**
 * @ClassName LeaderboardVO
 * @Description
 * @Author hanyu
 * @Date 2023/7/18
 **/
@Data
@Accessors(chain = true)
public class MapDictVO {
    /**
     *
     */
    private int[] x;
    private int[] y;
    private int[] houseType;
    private int[] houseLevel;
    private int num;

}