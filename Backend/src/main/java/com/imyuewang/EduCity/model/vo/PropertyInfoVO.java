package com.imyuewang.EduCity.model.vo;

import lombok.Data;
import lombok.experimental.Accessors;

/**
 * Data displayed on user profile
 */
@Data
@Accessors(chain = true)
public class PropertyInfoVO {

    private String cityName;

    private Integer residentialBuildingAmount;

    private Integer supermarketAmount;

    private Integer bankAmount;

    private Integer farmAmount;

    private Integer constructionSiteAmount;

    private Integer hospitalAmount;

}
