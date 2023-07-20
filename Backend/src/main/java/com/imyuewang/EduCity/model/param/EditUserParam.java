package com.imyuewang.EduCity.model.param;

import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
public class EditUserParam {

    @NotNull(message = "User id is required")
    private Long id;

    @NotBlank(message = "Email is required")
    @Length(min = 8, max = 20, message = "Email must be between 8-20 digits in length.")
    private String email;

    @NotBlank(message = "Username is required")
    @Length(min = 1, max = 20, message = "Name must be between 1-20 digits in length.")
    private String name;

}
