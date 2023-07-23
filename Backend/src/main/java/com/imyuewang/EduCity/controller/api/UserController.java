package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.model.entity.User;
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


@Slf4j
@RestController
@RequestMapping("/user")
@Api(tags = "User Management Interface")
public class UserController {

    @Autowired
    private UserService userService;


    @PostMapping("/email")
    @ApiOperation(value = "Email verification")
    public ResultVO checkEmailIsExisted(@RequestBody @Validated(RegisterParam.emailVerification.class) RegisterParam param) {
        return userService.checkEmailIsExisted(param);
    }

    @PostMapping("/active")
    @ApiOperation(value = "Active code")
    public ResultVO getActiveCode(@RequestBody RegisterParam param) {
        return userService. getActiveCode(param);
    }



    @GetMapping("/get/{id}")
    @ApiOperation(value = "Get user info based on user ID")
    public User getUserById(@ApiParam(value = "User ID", required = true)
                            @PathVariable("id") Long id) {
        return userService.getById(id);
    }


}
