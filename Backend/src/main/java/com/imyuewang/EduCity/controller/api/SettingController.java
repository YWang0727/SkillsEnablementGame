package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.model.param.EditPasswordParam;
import com.imyuewang.EduCity.model.param.EditUserParam;
import com.imyuewang.EduCity.model.vo.PropertyInfoVO;
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.UserInfoVO;
import com.imyuewang.EduCity.service.SettingService;
import com.imyuewang.EduCity.service.UserService;
import com.imyuewang.EduCity.util.CommonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;
import java.util.Base64;


@Slf4j
@RestController
@RequestMapping("/setting")
@Api(tags = "Setting Management interface")
public class SettingController {

    @Autowired
    private SettingService settingService;

    @Autowired
    private UserService userService;

    @GetMapping("/getUserInfo/{id}")
    @ApiOperation("return user information")
    public ResultVO<UserInfoVO> getUserInfo(@PathVariable("id") Long id) {
        UserInfoVO userInfoVO = settingService.getUserInfo(id);
        // convert byte to string using base64 encoder
        if (userInfoVO.getAvatar() != null) {
            String avatarStr = Base64.getEncoder().encodeToString(userInfoVO.getAvatar());
            userInfoVO.setAvatarStr(avatarStr);
            userInfoVO.setAvatar(null);
        }

        return new ResultVO<>(ResultCode.SUCCESS, userInfoVO);
    }

    @GetMapping("/getPropertyInfo/{id}")
    @ApiOperation("return user's property information")
    public ResultVO<PropertyInfoVO> getPropertyInfo(@PathVariable("id") Long id) {
        PropertyInfoVO propertyInfo = settingService.getPropertyInfo(id);
        return new ResultVO<>(ResultCode.SUCCESS, propertyInfo);
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

