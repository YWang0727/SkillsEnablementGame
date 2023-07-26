package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.model.param.EditPasswordParam;
import com.imyuewang.EduCity.model.param.EditUserParam;
import com.imyuewang.EduCity.model.vo.PropertyInfoVO;
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.UserVO;
import com.imyuewang.EduCity.service.SettingService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;


@Slf4j
@RestController
@RequestMapping("/setting")
@Api(tags = "Setting Management interface")
public class SettingController {

    @Autowired
    private SettingService settingService;

    @GetMapping("/getUserInfo/{id}")
    @ApiOperation("return user information")
    public ResultVO<UserVO> getUserInfo(@PathVariable("id") Long id) {
        UserVO userVO = settingService.getUserInfo(id);
        return new ResultVO<>(userVO);
    }

    @GetMapping("/getPropertyInfo/{id}")
    @ApiOperation("return user's property information")
    public ResultVO<PropertyInfoVO> getPropertyInfo(@PathVariable("id") Long id) {
        PropertyInfoVO propertyInfo = settingService.getPropertyInfo(id);
        return new ResultVO<>(propertyInfo);
    }

    @PutMapping("/editUserInfo")
    @ApiOperation("modify user's information")
    public ResultVO editUserInfo(@RequestPart("avatar") MultipartFile avatar, @RequestPart("json") @Valid EditUserParam editUserParam) throws IOException {
        settingService.editUserInfo(avatar.getBytes(), editUserParam);
        return new ResultVO(ResultCode.SUCCESS, "Edit user's profile successfully");
    }

    @PutMapping("/editPassword")
    @ApiOperation("modify user's password")
    public ResultVO editPassword(@RequestBody() @Valid EditPasswordParam passwordParam) {
        settingService.editPassword(passwordParam);
        return new ResultVO(ResultCode.SUCCESS, "Change password successfully");
    }

}

