package com.imyuewang.EduCity.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.vo.ComponentsVO;
import com.imyuewang.EduCity.model.vo.LeaderboardVO;
import com.imyuewang.EduCity.service.CitymapService;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

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
    public LeaderboardVO leaderBoard(Long id) {
        User user = userMapper.selectById(1);
        Citymap citymap = cityMapMapper.selectById(user.getCitymap());
        LeaderboardVO leaderBoardVO = new LeaderboardVO();
        leaderBoardVO.setName(citymap.getName());
        leaderBoardVO.setProsperity(citymap.getProsperity());

        //get total_num of city map
        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.select();
        int total = cityMapMapper.selectCount(queryWrapper);
        leaderBoardVO.setTotal_num(total);

        //order
        queryWrapper.orderByDesc("prosperity");
        List<Citymap> citymaps = cityMapMapper.selectList(queryWrapper);
        long all_prosperity[] = new long[total];
        String all_name[] = new String[total];
        for (int i = citymaps.size() - 1; i >= 0; i--) {
            all_prosperity[i] = citymaps.get(i).getProsperity();
            all_name[i] = citymaps.get(i).getName();
        }
        leaderBoardVO.setAll_name(all_name);
        leaderBoardVO.setAll_prosperity(all_prosperity);
        return leaderBoardVO;
    }


    @Override
    public ComponentsVO components(Long id){
        User user = userMapper.selectById(1);
        Citymap citymap = cityMapMapper.selectById(user.getCitymap());
        ComponentsVO componentsVO = new ComponentsVO();
        componentsVO.setGold(citymap.getGold());
        componentsVO.setProsperity(citymap.getProsperity());
        componentsVO.setConstruction_speed(citymap.getConstructionspeed());
        return componentsVO;
    }

}




