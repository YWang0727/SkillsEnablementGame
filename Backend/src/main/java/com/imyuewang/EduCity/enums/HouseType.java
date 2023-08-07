package com.imyuewang.EduCity.enums;

import lombok.Getter;

@Getter
public enum HouseType {

    RESIDENTIAL_BUILDING_1(0, "Residential Building"),
    SUPERMARKET_1(1, "Supermarket"),
    BANK_1(2, "Bank"),
    FARM_1(3, "Farm"),
    CONSTRUCTION_SITE_1(4, "Construction Site"),
    HOSPITAL_1(5, "Hospital"),
    RESIDENTIAL_BUILDING_2(10, "Residential Building"),
    SUPERMARKET_2(11, "Supermarket"),
    BANK_2(12, "Bank"),
    FARM_2(13, "Farm"),
    CONSTRUCTION_SITE_2(14, "Construction Site"),
    HOSPITAL_2(15, "Hospital"),
    RESIDENTIAL_BUILDING_3(20, "Residential Building"),
    SUPERMARKET_3(21, "Supermarket"),
    BANK_3(22, "Bank"),
    FARM_3(23, "Farm"),
    CONSTRUCTION_SITE_3(24, "Construction Site"),
    HOSPITAL_3(25, "Hospital"),
    ;

    private int code;
    private String name;

    HouseType(int code, String name) {
        this.code = code;
        this.name = name;
    }
}
