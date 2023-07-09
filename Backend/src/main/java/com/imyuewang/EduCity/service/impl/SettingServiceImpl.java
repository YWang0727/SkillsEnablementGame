package com.imyuewang.EduCity.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.imyuewang.EduCity.enums.HouseType;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import com.imyuewang.EduCity.mapper.TakenmapcellMapper;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.entity.Takenmapcell;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.EditUserParam;
import com.imyuewang.EduCity.model.vo.PropertyInfoVO;
import com.imyuewang.EduCity.model.vo.UserInfoVO;
import com.imyuewang.EduCity.service.SettingService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Slf4j
@Service
public class SettingServiceImpl implements SettingService {

    @Resource
    private UserMapper userMapper;

    @Resource
    private CitymapMapper cityMapMapper;

    @Resource
    private TakenmapcellMapper takenMapCellMapper;

    /**
     * get userVO by user id
     */
    @Override
    public UserInfoVO getUserInfo(Long userId) {
        User user = userMapper.selectById(userId);

        UserInfoVO userInfoVO = new UserInfoVO();
        BeanUtils.copyProperties(user, userInfoVO);

        // get cityMap according to map id
        Long cityMapId = user.getCitymap();
        Citymap cityMap = cityMapMapper.selectById(cityMapId);
        userInfoVO.setGold(cityMap.getGold());
        userInfoVO.setProsperity(cityMap.getProsperity());

        return userInfoVO;
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
        propertyInfoVO.setBankAmount(getBuildingAmount(HouseType.BANK, cityMapId));
        propertyInfoVO.setFarmAmount(getBuildingAmount(HouseType.FARM, cityMapId));
        propertyInfoVO.setHospitalAmount(getBuildingAmount(HouseType.HOSPITAL, cityMapId));
        propertyInfoVO.setSupermarketAmount(getBuildingAmount(HouseType.SUPERMARKET, cityMapId));
        propertyInfoVO.setResidentialBuildingAmount(getBuildingAmount(HouseType.RESIDENTIAL_BUILDING, cityMapId));
        propertyInfoVO.setPoliceStationAmount(getBuildingAmount(HouseType.POLICE_STATION, cityMapId));

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
        user.setName(editUserParam.getName());
        user.setEmail(editUserParam.getEmail());
        user.setAvatar(avatar);

        userMapper.updateById(user);
    }

    /**
     * handle the condition of changing password
     */
    @Override
    public void editPassword() {

    }
}