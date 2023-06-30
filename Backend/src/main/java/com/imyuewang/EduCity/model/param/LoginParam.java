package com.imyuewang.EduCity.model.param;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * @ClassName LoginParam
 * @Description Receive login-related parameters.
 * @Author Yue Wang
 * @Date 2023/5/3 0:58
 * @Version 1.0
 **/
@Data
public class LoginParam {

    @NotBlank(message = "Email is required.")
    //@Length(min = 4, max = 20, message = "Username must be between 4-20 characters in length.")
    //@ExceptionCode(value = 100001, message = "Invalid username.")
    private String email;

    @NotBlank(message = "Password is required.")
    //@Length(min = 4, max = 20, message = "Password must be between 4-20 characters in length.")
    //@ExceptionCode(value = 100003, message = "Invalid password.")
    private String password;

}