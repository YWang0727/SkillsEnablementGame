package com.imyuewang.EduCity.model.vo;

import lombok.Data;
import lombok.experimental.Accessors;

/**
 * @hanyu
 * Components
 */
@Data
@Accessors(chain = true)
public class ComponentsVO {

    private long prosperity;
    private long gold;
    private int construction_speed;

}