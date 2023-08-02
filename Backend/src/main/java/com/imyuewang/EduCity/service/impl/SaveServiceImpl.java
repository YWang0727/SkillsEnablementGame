package com.imyuewang.EduCity.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import com.imyuewang.EduCity.mapper.TakenmapcellMapper;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.entity.Takenmapcell;
import com.imyuewang.EduCity.model.param.MapDictParam;
import com.imyuewang.EduCity.model.param.SaveParam;
import com.imyuewang.EduCity.service.CitymapService;
import com.imyuewang.EduCity.service.SaveService;
import com.imyuewang.EduCity.service.TakenmapcellService;
import com.imyuewang.EduCity.service.UserQuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @ClassName SaveServiceImpl
 * @Description
 * @Author Yue Wang
 * @Date 2023/7/26 21:23
 **/
@Service
public class SaveServiceImpl implements SaveService {

    @Resource
    private CitymapMapper cityMapMapper;

    @Resource
    private TakenmapcellMapper takenmapcellMapper;

    public void save(SaveParam param){
        Long id = param.getId();
        Long cityId = param.getCityid();

        // save city map data
        Citymap citymap = cityMapMapper.selectById(cityId);
        if(citymap == null){
            throw new ApiException(ResultCode.FAILED,"This citymap record does not exist");
        }
        citymap.setGold(param.getGold());
        citymap.setProsperity(param.getProsperity());
        citymap.setConstructionspeed(param.getConstruction_speed());
        cityMapMapper.updateById(citymap);

        // save map cell data
        List<MapDictParam> cellList = param.getTakenmapcell();
        for(MapDictParam mapDictParam : cellList){
            QueryWrapper<Takenmapcell> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("mapId",cityId);
            queryWrapper.eq("positionX",mapDictParam.getX());
            queryWrapper.eq("positionY",mapDictParam.getY());

            Takenmapcell takenmapcell = takenmapcellMapper.selectOne(queryWrapper);
//            if(takenmapcell == null){
//                takenmapcell = new Takenmapcell();
//                takenmapcell.setMapid(cityId);
//                takenmapcell.setPositionx(mapDictParam.getX());
//                takenmapcell.setPositiony(mapDictParam.getY());
//                takenmapcell.setHousetype(mapDictParam.getHouseType());
//                takenmapcellMapper.insert(takenmapcell);
//            }else{
                takenmapcell.setPositionx(mapDictParam.getX());
                takenmapcell.setPositiony(mapDictParam.getY());
                takenmapcell.setHousetype(mapDictParam.getHouseType());
                takenmapcellMapper.update(takenmapcell,queryWrapper);
//            }
        }
    }
}
