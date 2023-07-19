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

    private Integer supermarketAmount;

    private Integer bankAmount;

    private Integer farmAmount;

    private Integer constructionSiteAmount;

    private Integer hospitalAmount;

    /**
     * @ClassName LeaderboardVO
     * @Description
     * @Author hanyu
     * @Date 2023/7/18
     **/
    @Data
    @Accessors(chain = true)
    public static class LeaderboardVO {

        private long prosperity;

        private String name;

    }
}
