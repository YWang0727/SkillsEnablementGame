package com.imyuewang.EduCity.model.param;

import lombok.Data;

import java.util.List;

/**
 * @ClassName SaveParam
 * @Description
 * @Author Yue Wang
 * @Date 2023/7/26 19:16
 **/
@Data
public class SaveParam {

    private Long id;
    private Long cityid;

    private Long gold;
    private Long prosperity;
    private int construction_speed;

    private List<MapDictParam> takenmapcell;

}
