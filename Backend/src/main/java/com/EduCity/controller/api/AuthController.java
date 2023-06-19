package com.EduCity.controller.api;

import cn.hutool.core.util.RandomUtil;
import com.EduCity.model.param.LoginParam;
import com.EduCity.model.param.RegisterParam;
import com.EduCity.model.vo.UserVO;
import com.EduCity.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import java.util.Set;


@Slf4j
@Validated
@RestController
@RequestMapping("/auth")
@Api(tags = "Auth Management Interface")
public class AuthController {

    @Autowired
    private UserService userService;


    @PostMapping("/login")
    @ApiOperation(value = "Login by password")
    public UserVO login(@RequestBody  @Valid LoginParam param){
        return userService.login(param);
    }

    @GetMapping("/update-token")
    @ApiOperation(value = "Update token")
    public String updateToken(){
        return userService.updateToken();
    }

}
