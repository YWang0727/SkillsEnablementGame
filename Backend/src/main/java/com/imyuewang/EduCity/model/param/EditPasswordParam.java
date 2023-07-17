package com.imyuewang.EduCity.model.param;

import lombok.Data;

@Data
public class EditPasswordParam {

    private Long id;

    private String oldPassword;

    private String newPassword;
}
