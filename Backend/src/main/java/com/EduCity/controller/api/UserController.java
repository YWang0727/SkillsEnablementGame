package com.EduCity.controller.api;

import com.EduCity.model.entity.User;
import com.EduCity.service.UserService;
import com.EduCity.util.CommonUtil;
import com.EduCity.annotation.Auth;
import com.EduCity.model.param.UserParam;
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
@Auth(id = 1000, name = "Accounts Management")
@Api(tags = "User Management Interface")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/email")
    @Auth(id = 1, name = "email verification")
    @ApiOperation(value = "Email verification")
    public String emailVerification(@RequestBody @Validated(UserParam.emailVerification.class) UserParam param) {
        userService.emailVerification(param);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

    @PostMapping("/active")
    @Auth(id = 2, name = "active code")
    @ApiOperation(value = "Active code")
    public String emailRegister(@RequestBody String activeCode) {
        userService.active(activeCode);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

    @PostMapping("/add")
    @Auth(id = 3, name = "add user")
    @ApiOperation(value = "Add user")
    public String createUser(@RequestBody @Validated(UserParam.CreateUser.class) UserParam param) {
        userService.createUser(param);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

//    @PutMapping("/update")
//    @Auth(id = 4, name = "update user")
//    @ApiOperation(value = "Update user")
//    public String updateUser(@RequestBody @Validated(UserParam.Update.class) UserParam param) {
//        userService.update(param);
//        return CommonUtil.ACTION_SUCCESSFUL;
//    }

    @GetMapping("/get/{id}")
    @Auth(id = 5, name = "get user info based on user ID")
    @ApiOperation(value = "Get user info based on user ID")
    public User getUserById(@ApiParam(value = "User ID", required = true)
                            @PathVariable("id") Long id) {
        return userService.getById(id);
    }


}
