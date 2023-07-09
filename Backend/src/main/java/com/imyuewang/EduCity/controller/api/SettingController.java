package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.model.param.EditUserParam;
import com.imyuewang.EduCity.model.vo.PropertyInfoVO;
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
    public UserInfoVO getUserInfo(@PathVariable("id") Long id) {
        UserInfoVO userInfoVO = settingService.getUserInfo(id);
        // convert byte to string using base64 encoder
        String strAvatar = Base64.getEncoder().encodeToString(userInfoVO.getAvatar());
        userInfoVO.setAvatarStr(strAvatar);
        userInfoVO.setAvatar(null);
        return userInfoVO;
    }

    @GetMapping("/getPropertyInfo/{id}")
    @ApiOperation("return user's property information")
    public PropertyInfoVO getPropertyInfo(@PathVariable("id") Long id) {
        PropertyInfoVO propertyInfo = settingService.getPropertyInfo(id);
        return propertyInfo;
    }

    @PutMapping("/editUserInfo")
    @ApiOperation("modify user's information")
    public String editUserInfo(@RequestPart("avatar") MultipartFile avatar, @RequestPart("json") EditUserParam editUserParam) throws IOException {
        settingService.editUserInfo(avatar.getBytes(), editUserParam);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

    @PutMapping("/editPassword")
    @ApiOperation("modify user's password")
    public String editPassword() {
        settingService.editPassword();
        return CommonUtil.ACTION_SUCCESSFUL;
    }

}
