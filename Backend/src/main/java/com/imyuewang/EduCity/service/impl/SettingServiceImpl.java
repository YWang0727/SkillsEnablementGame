package com.imyuewang.EduCity.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.imyuewang.EduCity.config.PasswordEncoder;
import com.imyuewang.EduCity.enums.HouseType;
import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.mapper.TakenmapcellMapper;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Takenmapcell;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.EditPasswordParam;
import com.imyuewang.EduCity.model.param.EditUserParam;
import com.imyuewang.EduCity.model.vo.PropertyInfoVO;
import com.imyuewang.EduCity.model.vo.UserVO;
import com.imyuewang.EduCity.service.SettingService;
import com.imyuewang.EduCity.util.MailUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Base64;

@Slf4j
@Service
public class SettingServiceImpl implements SettingService {

    @Resource
    private UserMapper userMapper;

    @Resource
    private TakenmapcellMapper takenMapCellMapper;

    /**
     * get userVO by user id
     */
    @Override
    public UserVO getUserInfo(Long userId) {
        User user = userMapper.selectById(userId);
        UserVO userVO = new UserVO();
        BeanUtils.copyProperties(user, userVO);

        // convert avatar byte to encoded string
        if (user.getAvatar() != null) {
            String avatarStr = Base64.getEncoder().encodeToString(user.getAvatar());
            userVO.setAvatarStr(avatarStr);
        }

        return userVO;
    }

    /**
     * get property information by user id
     */
    @Override
    public PropertyInfoVO getPropertyInfo(Long userId) {
        // get cityMap according to map id
        User user = userMapper.selectById(userId);
        Long cityMapId = user.getCitymap();

        // get gold and prosperity
        PropertyInfoVO propertyInfoVO = new PropertyInfoVO();
        propertyInfoVO.setResidentialBuildingAmount(getBuildingAmount(HouseType.RESIDENTIAL_BUILDING, cityMapId));
        propertyInfoVO.setSupermarketAmount(getBuildingAmount(HouseType.SUPERMARKET, cityMapId));
        propertyInfoVO.setBankAmount(getBuildingAmount(HouseType.BANK, cityMapId));
        propertyInfoVO.setFarmAmount(getBuildingAmount(HouseType.FARM, cityMapId));
        propertyInfoVO.setConstructionSiteAmount(getBuildingAmount(HouseType.CONSTRUCTION_SITE, cityMapId));
        propertyInfoVO.setHospitalAmount(getBuildingAmount(HouseType.HOSPITAL, cityMapId));

        return propertyInfoVO;
    }

    /**
     * calculate amount of different type of buildings
     */
    private Integer getBuildingAmount(HouseType houseType, Long mapId) {
        QueryWrapper<Takenmapcell> queryWrapper = new QueryWrapper<>();
        queryWrapper.
                eq("mapId", mapId).
                eq("houseType", houseType.getCode());
        Integer count = takenMapCellMapper.selectCount(queryWrapper);

        return count;
    }

    /**
     * handle the condition of edit user info and update avatar
     */
    @Override
    public void editUserInfo(byte[] avatar, EditUserParam editUserParam) {
        User user = userMapper.selectById(editUserParam.getId());
        // check size of avatar
        if (avatar.length > 65536) {
            throw new ApiException(ResultCode.UPLOAD_ERROR);
        }

        // check email format
        MailUtil mailUtil = new MailUtil();
        String email = editUserParam.getEmail();
        if(!mailUtil.isEmail(email)){
            throw new ApiException(ResultCode.FAILED,"Incorrect email format.");
        }
        // check if email exists
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("email", email).
                ne("id", user.getId());
        if (userMapper.selectCount(queryWrapper) != 0) {
            throw new ApiException(ResultCode.FAILED,"Email already exists.");
        }

        user.setName(editUserParam.getName());
        user.setEmail(email);
        // don't update avatar if input is empty
        if (avatar.length != 0) {
            user.setAvatar(avatar);
        }

        userMapper.updateById(user);
    }

    /**
     * handle the condition of changing password
     */
    @Override
    public void editPassword(EditPasswordParam passwordParam) {
        User user = userMapper.selectById(passwordParam.getId());
        String oldPassword = passwordParam.getOldPassword();
        String newPassword = passwordParam.getNewPassword();

        // check if old password is correct
        if (!PasswordEncoder.matches(oldPassword, user.getPassword())) {
            throw new ApiException(ResultCode.VALIDATE_FAILED, "Password is incorrect!");
        }

        user.setPassword(PasswordEncoder.encode(newPassword));
        userMapper.updateById(user);
    }
}
