package com.imyuewang.EduCity.model.param;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class MapDictParam {
    private int x;
    private int y;
    private int houseType;
    //private Timestamp buildTime;
    private Long id;
}
