package com.imyuewang.EduCity.service;

import com.imyuewang.EduCity.model.entity.Takenmapcell;
import com.baomidou.mybatisplus.extension.service.IService;
import com.imyuewang.EduCity.model.param.MapDictParam;
import com.imyuewang.EduCity.model.vo.MapDictVO;

/**
* @author Sarah Wang
* @description 针对表【takenmapcell】的数据库操作Service
* @createDate 2023-06-21 15:42:32
*/
public interface TakenmapcellService extends IService<Takenmapcell> {

    MapDictVO readMap(Long id);

    void buildHouse(MapDictParam param);

    MapDictVO otherMap(Long mapId);

    void levelUp(MapDictParam param);

    void clearMapTime(MapDictParam param);


}
