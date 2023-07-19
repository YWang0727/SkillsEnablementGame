package com.imyuewang.EduCity.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.vo.LeaderBoardVO;
import com.imyuewang.EduCity.model.vo.UserInfoVO;
import com.imyuewang.EduCity.service.CitymapService;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
* @author Sarah Wang
* @description 针对表【citymap】的数据库操作Service实现
* @createDate 2023-06-21 15:42:32
*/
@Service
public class CitymapServiceImpl extends ServiceImpl<CitymapMapper, Citymap>
    implements CitymapService{

    @Resource
    private UserMapper userMapper;

    @Resource
    private CitymapMapper cityMapMapper;

    @Override
    public LeaderBoardVO leaderBoard(Long id) {
        User user = userMapper.selectById(1);
        Citymap citymap = cityMapMapper.selectById(user.getCitymap());
        LeaderBoardVO leaderBoardVO = new LeaderBoardVO();
        leaderBoardVO.setName(citymap.getName());
        leaderBoardVO.setProsperity(citymap.getProsperity());
        return leaderBoardVO;
    }
}




