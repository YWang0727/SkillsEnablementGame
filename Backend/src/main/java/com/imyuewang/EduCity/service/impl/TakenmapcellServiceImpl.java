package com.imyuewang.EduCity.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.entity.Takenmapcell;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.ComponentsParam;
import com.imyuewang.EduCity.model.param.MapDictParam;
import com.imyuewang.EduCity.model.vo.ComponentsVO;
import com.imyuewang.EduCity.model.vo.LeaderboardVO;
import com.imyuewang.EduCity.model.vo.MapDictVO;
import com.imyuewang.EduCity.service.TakenmapcellService;
import com.imyuewang.EduCity.mapper.TakenmapcellMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

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
        MapDictVO mapDictVO = new MapDictVO();
        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("mapId",user.getCitymap());//map id = user.id
        int num = takenmapcellMapper.selectCount(queryWrapper);
        List<Takenmapcell> takenmapcells = takenmapcellMapper.selectList(queryWrapper);
        int[] x = new int[num];
        int[] y = new int[num];
        int[] houseType = new int[num];
        int[] houseLevel = new int[num];
        for (int i = 0; i < takenmapcells.size(); i++) {
            x[i] = takenmapcells.get(i).getPositionx();
            y[i] = takenmapcells.get(i).getPositiony();
            houseType[i] = takenmapcells.get(i).getHousetype();
            houseLevel[i] = takenmapcells.get(i).getHouselevel();
        }
        mapDictVO.setX(x);
        mapDictVO.setY(y);
        mapDictVO.setHouseType(houseType);
        mapDictVO.setHouseLevel(houseLevel);
        mapDictVO.setNum(num);
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
        takenmapcell.setHouselevel(1);//新房子默认一级
        takenmapcellMapper.insert(takenmapcell);
    }


    public MapDictVO otherMap(Long mapId){
        //通过mapId找到对应的user
        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("mapId",mapId);
        User user = userMapper.selectOne(queryWrapper);
        //d调用readmap返回地图房子信息
        MapDictVO mapDictVO = readMap(user.getId());
        return mapDictVO;
    }


    //通过 mapid x y 找到对应的house level+1
    public void levelUp(MapDictParam param){
        User user = userMapper.selectById(param.getId());
        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("mapId",user.getCitymap());
        queryWrapper.eq("positionX",param.getX());
        queryWrapper.eq("positionY",param.getY());
        Takenmapcell takenmapcell = takenmapcellMapper.selectOne(queryWrapper);
        takenmapcell.setHouselevel(takenmapcell.getHouselevel() + 1);
        takenmapcellMapper.update(takenmapcell,queryWrapper);
    }


}




