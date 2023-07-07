package com.imyuewang.EduCity.enums;

import lombok.Getter;

@Getter
public enum HouseType {

    BANK(0, "Bank"),
    FARM(1, "Farm"),
    HOSPITAL(2, "Hospital"),
    POLICE_STATION(3, "Police Station"),
    RESIDENTIAL_BUILDING(4, "Residential Building"),
    SUPERMARKET(5, "Supermarket")
    ;

    private int code;
    private String name;

    HouseType(int code, String name) {
        this.code = code;
        this.name = name;
    }
}
