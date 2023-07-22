package com.imyuewang.EduCity.model.param;

import com.imyuewang.EduCity.annotation.ExceptionCode;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

/**
 * @ClassName RegisterParam
 * @Description Receive registration-related parameters.
 * @Author Yue Wang
 * @Date 2023/5/3 0:58
 * @Version 1.0
 **/
@Data
public class RegisterParam {


    @NotBlank(message = "Email is required.", groups = emailVerification.class)
    @Length(min = 8, max = 20, message = "Email must be between 8-20 digits in length.")
    @ExceptionCode(value = 100004, message = "Invalid Email.")
    private String email;

    @NotBlank(message = "Verification code is required.")
    @Pattern(regexp = "\\d{6}", message = "Verification code must be 6 digits.")
    @ExceptionCode(value = 100005, message = "Wrong code.")
    private String activecode;

    @NotBlank(message = "Verification code is required.")
    @Length(min = 1, max = 20, message = "Name must be between 1-20 digits in length.")
    private String name;

    @NotBlank(message = "Password is required.")
    @Length(min = 4, max = 20, message = "Password must be between 4-20 characters in length.")
    @ExceptionCode(value = 100003, message = "Invalid password.")
    private String password;


    public interface emailVerification{}



}
