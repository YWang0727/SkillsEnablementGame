package com.imyuewang.EduCity.enums;

import lombok.Getter;

@Getter
public enum HouseType {

    RESIDENTIAL_BUILDING(0, "Residential Building"),
    SUPERMARKET(1, "Supermarket"),
    BANK(2, "Bank"),
    FARM(3, "Farm"),
    CONSTRUCTION_SITE(4, "Construction Site"),
    HOSPITAL(5, "Hospital")
    ;

    private int code;
    private String name;

    HouseType(int code, String name) {
        this.code = code;
        this.name = name;
    }
}
