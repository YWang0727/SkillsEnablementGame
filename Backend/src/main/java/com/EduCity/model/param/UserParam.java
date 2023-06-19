package com.EduCity.model.param;

import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * @ClassName UserParam
 * @Description Receive user-related parameters.
 * @Author Yue Wang
 * @Date 2023/5/7 11:12
 * @Version 1.0
 **/
@Data
public class UserParam {

    @NotBlank(message = "Email is required.", groups = CreateUser.class)
    private String email;

    @NotBlank(message = "Password is required.", groups = CreateUser.class)
    @Length(min = 8, max = 20, message = "Password must be between 8-20 characters in length.", groups = CreateUser.class)
    private String password;

    @NotBlank(message = "Username is required.", groups = CreateUser.class)
    @Length(min = 8, max = 20, message = "Username must be between 4-20 characters in length.", groups = CreateUser.class)
    private String name;

    private Boolean isActive;

    public interface Update {}

    public interface CreateUser{}

    public interface emailVerification{}
}