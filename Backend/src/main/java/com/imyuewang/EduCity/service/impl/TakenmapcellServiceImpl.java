package com.imyuewang.EduCity.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.entity.Takenmapcell;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.MapDictParam;
import com.imyuewang.EduCity.model.vo.MapDictVO;
import com.imyuewang.EduCity.service.TakenmapcellService;
import com.imyuewang.EduCity.mapper.TakenmapcellMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.xml.crypto.Data;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

/**
* @author Sarah Wang
* @description 针对表【takenmapcell】的数据库操作Service实现
* @createDate 2023-06-21 15:42:32
*/
@Service
public class TakenmapcellServiceImpl extends ServiceImpl<TakenmapcellMapper, Takenmapcell>
    implements TakenmapcellService{

    @Resource
    private UserMapper userMapper;


    @Resource
    private TakenmapcellMapper takenmapcellMapper;


    //进入地图从数据库读取数据     get所有该id对应的数据
    @Override
    public MapDictVO readMap(Long id){
        User user = userMapper.selectById(id);
        MapDictVO mapDictVO = otherMap(user.getCitymap());
        return mapDictVO;
    }


    //建新房子   插入一条新的 mapID = user.getCitymap()的数据
    @Override
    public void buildHouse(MapDictParam param){
        User user = userMapper.selectById(param.getId());
        Takenmapcell takenmapcell = new Takenmapcell();
        takenmapcell.setMapid(user.getCitymap());
        takenmapcell.setPositionx(param.getX());
        takenmapcell.setPositiony(param.getY());
        takenmapcell.setHousetype(param.getHouseType());
        //takenmapcell.setBuildtime();
        takenmapcellMapper.insert(takenmapcell);
    }


    @Override
    public MapDictVO otherMap(Long mapId){
        MapDictVO mapDictVO = new MapDictVO();
        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("mapId",mapId);
        int num = takenmapcellMapper.selectCount(queryWrapper);
        List<Takenmapcell> takenmapcells = takenmapcellMapper.selectList(queryWrapper);
        int[] x = new int[num];
        int[] y = new int[num];
        int[] houseType = new int[num];
        Date[] buildTime = new Date[num];
        for (int i = 0; i < takenmapcells.size(); i++) {
            x[i] = takenmapcells.get(i).getPositionx();
            y[i] = takenmapcells.get(i).getPositiony();
            houseType[i] = takenmapcells.get(i).getHousetype();
            buildTime[i] = takenmapcells.get(i).getBuildtime();
        }
        mapDictVO.setX(x);
        mapDictVO.setY(y);
        mapDictVO.setHouseType(houseType);
        mapDictVO.setNum(num);
        mapDictVO.setBuildTime(buildTime);
        return mapDictVO;
    }


    //通过 mapid x y 找到对应的house level+1
    @Override
    public void levelUp(MapDictParam param){
        User user = userMapper.selectById(param.getId());
        QueryWrapper queryWrapper = new QueryWrapper<Citymap>();
        queryWrapper.eq("mapId",user.getCitymap());
        queryWrapper.eq("positionX",param.getX());
        queryWrapper.eq("positionY",param.getY());
        Takenmapcell takenmapcell = takenmapcellMapper.selectOne(queryWrapper);
        takenmapcell.setHousetype(takenmapcell.getHousetype()+10);
        takenmapcellMapper.update(takenmapcell,queryWrapper);
    }




}




