package com.imyuewang.EduCity.service;

import com.imyuewang.EduCity.model.param.EditPasswordParam;
import com.imyuewang.EduCity.model.param.EditUserParam;
import com.imyuewang.EduCity.model.vo.PropertyInfoVO;
import com.imyuewang.EduCity.model.vo.UserInfoVO;
import org.springframework.stereotype.Service;

@Service
public interface SettingService {

    UserInfoVO getUserInfo(Long userId);

    PropertyInfoVO getPropertyInfo(Long userId);

    void editUserInfo(byte[] avatar, EditUserParam editUserParam);

    void editPassword(EditPasswordParam passwordParam);
}
