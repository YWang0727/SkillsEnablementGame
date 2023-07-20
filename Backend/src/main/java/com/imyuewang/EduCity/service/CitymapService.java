package com.imyuewang.EduCity.service;

import com.imyuewang.EduCity.model.entity.Citymap;
import com.baomidou.mybatisplus.extension.service.IService;
import com.imyuewang.EduCity.model.vo.ComponentsVO;
import com.imyuewang.EduCity.model.vo.LeaderboardVO;

/**
* @author Sarah Wang
* @description 针对表【citymap】的数据库操作Service
* @createDate 2023-06-21 15:42:32
*/
public interface CitymapService extends IService<Citymap> {
    /**
     *
     * @param id
     * @return city name
     * ???and prosperity
     */
    LeaderboardVO leaderBoard(Long id);

    ComponentsVO components(Long id);
}
