package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.service.UserService;
import com.imyuewang.EduCity.util.CommonUtil;
import com.imyuewang.EduCity.annotation.Auth;
import com.imyuewang.EduCity.model.param.UserParam;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;


@Slf4j
@RestController
@RequestMapping("/user")
@Api(tags = "User Management Interface")
public class UserController {

    @Autowired
    private UserService userService;


    @PostMapping("/email")
    @ApiOperation(value = "Email verification")
    public String emailVerification(@RequestBody @Validated(UserParam.emailVerification.class) UserParam param) {
        userService.emailVerification(param);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

    @PostMapping("/active")
    @ApiOperation(value = "Active code")
    public String emailRegister(@RequestBody UserParam param) {
        userService. active(param);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

    @PostMapping("/add")
    @ApiOperation(value = "Add user")
    public String createUser(@RequestBody @Validated(UserParam.CreateUser.class) UserParam param) {
        userService.createUser(param);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

    @GetMapping("/get/{id}")
    @ApiOperation(value = "Get user info based on user ID")
    public User getUserById(@ApiParam(value = "User ID", required = true)
                            @PathVariable("id") Long id) {
        return userService.getById(id);
    }


}
