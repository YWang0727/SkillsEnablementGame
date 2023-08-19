package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.LoginParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.UserVO;
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

import javax.validation.Valid;


@Slf4j
@RestController
@RequestMapping("/user")
@Api(tags = "User Management Interface")
public class UserController {

    @Autowired
    private UserService userService;


    @GetMapping("/get/{id}")
    @ApiOperation(value = "Get user info based on user ID")
    public User getUserById(@ApiParam(value = "User ID", required = true)
                            @PathVariable("id") Long id) {
        return userService.getById(id);
    }

    @PostMapping("/refresh-access-token")
    @ApiOperation(value = "Refresh access token")
    public ResultVO refreshAccessToken(@RequestHeader("Authorization") String refreshToken) {
        return userService.refreshAccessToken(refreshToken);
    }

    @PostMapping("/set-user-not-first")
    @ApiOperation(value = "Set user not first")
    public ResultVO setUserNotFirst(@RequestBody UserParam param) {
        return userService.setUserNotFirst(param);
    }


}
