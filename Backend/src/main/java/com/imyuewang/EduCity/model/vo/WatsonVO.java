package com.imyuewang.EduCity.model.vo;

import lombok.Data;

import java.util.ArrayList;

@Data
public class WatsonVO {

    // can only have one message if it's sent by user
    private ArrayList<String> messages = new ArrayList<>();

    private ArrayList<String> options = new ArrayList<>();

    private String sessionId;

    private Boolean isNewSession;
}
