package com.imyuewang.EduCity.service.impl;

import cn.hutool.jwt.JWT;
import cn.hutool.jwt.JWTPayload;
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
import com.imyuewang.EduCity.security.JwtManager;
import com.imyuewang.EduCity.service.SettingService;
import com.imyuewang.EduCity.util.MailUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Base64;
import java.util.Objects;

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
        Long cityMapId = user.getCityMap();

        // get number of each type of buildings
        PropertyInfoVO propertyInfoVO = new PropertyInfoVO();
        Integer residentialNum = getBuildingAmount(HouseType.RESIDENTIAL_BUILDING_1, cityMapId) +
                getBuildingAmount(HouseType.RESIDENTIAL_BUILDING_2, cityMapId) +
                getBuildingAmount(HouseType.RESIDENTIAL_BUILDING_3, cityMapId);
        Integer supermarketNum = getBuildingAmount(HouseType.SUPERMARKET_1, cityMapId) +
                getBuildingAmount(HouseType.SUPERMARKET_2, cityMapId) +
                getBuildingAmount(HouseType.SUPERMARKET_3, cityMapId);
        Integer bankNum = getBuildingAmount(HouseType.BANK_1, cityMapId) +
                getBuildingAmount(HouseType.BANK_2, cityMapId) +
                getBuildingAmount(HouseType.BANK_3, cityMapId);
        Integer farmNum = getBuildingAmount(HouseType.FARM_1, cityMapId) +
                getBuildingAmount(HouseType.FARM_2, cityMapId) +
                getBuildingAmount(HouseType.FARM_3, cityMapId);
        Integer constructionSiteNum = getBuildingAmount(HouseType.CONSTRUCTION_SITE_1, cityMapId) +
                getBuildingAmount(HouseType.CONSTRUCTION_SITE_2, cityMapId) +
                getBuildingAmount(HouseType.CONSTRUCTION_SITE_3, cityMapId);
        Integer hospitalNum = getBuildingAmount(HouseType.HOSPITAL_1, cityMapId) +
                getBuildingAmount(HouseType.HOSPITAL_2, cityMapId) +
                getBuildingAmount(HouseType.HOSPITAL_3, cityMapId);

        propertyInfoVO.setResidentialBuildingAmount(residentialNum);
        propertyInfoVO.setSupermarketAmount(supermarketNum);
        propertyInfoVO.setBankAmount(bankNum);
        propertyInfoVO.setFarmAmount(farmNum);
        propertyInfoVO.setConstructionSiteAmount(constructionSiteNum);
        propertyInfoVO.setHospitalAmount(hospitalNum);

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
        String oldPassword = passwordParam.getOldPassword();
        String newPassword = passwordParam.getNewPassword();
        User user = userMapper.selectById(passwordParam.getId());
        String pwToken = user.getPassword();
        JWT jwt = JwtManager.parsePwToken(pwToken);
        String userPassword = jwt.getPayload(JWTPayload.SUBJECT).toString();

        // check if old password is correct
        if (!Objects.equals(oldPassword, userPassword)) {
            System.out.println("old password: " + oldPassword);
            System.out.println("user password: " + userPassword);
            throw new ApiException(ResultCode.VALIDATE_FAILED, "Password is incorrect!");
        }

        user.setPassword(PasswordEncoder.encode(newPassword));
        userMapper.updateById(user);
    }
}
