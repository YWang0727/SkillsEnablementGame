package com.imyuewang.EduCity.model.vo;

import lombok.Data;
import lombok.experimental.Accessors;

/**
 * Data displayed on user profile
 */
@Data
@Accessors(chain = true)
public class PropertyInfoVO {

    private Integer residentialBuildingAmount;

    private Integer bankAmount;

    private Integer supermarketAmount;

    private Integer hospitalAmount;

    private Integer farmAmount;

    private Integer policeStationAmount;
}
