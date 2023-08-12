package com.imyuewang.EduCity;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.imyuewang.EduCity.controller.api.AuthController;
import com.imyuewang.EduCity.controller.api.MapController;
import com.imyuewang.EduCity.controller.api.TakenmapcellController;
import com.imyuewang.EduCity.mapper.TakenmapcellMapper;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Takenmapcell;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.MapDictParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.vo.MapDictVO;
import com.imyuewang.EduCity.service.impl.UserServiceImpl;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;


/**
 * @ClassName EduCityTakenMapCellTests
 * @Description
 * @Author hanyu
 * @Date 2023/8/9
 **/
@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class EduCityTakenMapCellTests {

    @Autowired
    UserServiceImpl userServiceImpl;

    @Autowired
    MapController mapController;

    @Autowired
    TakenmapcellController takenmapcellController;

    @Autowired
    AuthController authController;

    private static TakenmapcellMapper staticTakenmapcellMapper;
    private static UserMapper staticUserMapper;

    static Long id;
    static Long mapId;

    @BeforeAll
    public static void setUp(@Autowired UserServiceImpl userServiceImpl,
                             @Autowired AuthController authController,
                             @Autowired UserMapper userMapper,
                             @Autowired TakenmapcellMapper takenmapcellMapper) {
        staticTakenmapcellMapper = takenmapcellMapper;
        staticUserMapper = userMapper;

        //Register user
        RegisterParam param = new RegisterParam();
        param.setEmail("test@gmail.com");
        param.setActivecode("111111");
        param.setName("testUser");
        param.setPassword("123456");

        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("email", "test@gmail.com");
        int userCount = userMapper.selectCount(queryWrapper);
        if(userCount != 1){
            authController.register(param);
        }
        User user = userServiceImpl.getUserByEmail("test@gmail.com");
        id = user.getId();
        mapId = user.getCityMap();

        //build house1---131
        Takenmapcell takenmapcell = new Takenmapcell();
        takenmapcell.setMapid(id);
        takenmapcell.setPositionx(13);
        takenmapcell.setPositiony(1);
        takenmapcell.setHousetype(0);
        takenmapcell.setFinishtime(1691870691L);
        takenmapcellMapper.insert(takenmapcell);
        //build house2---104
        takenmapcell.setPositionx(10);
        takenmapcell.setPositiony(4);
        takenmapcell.setHousetype(1);
        takenmapcell.setFinishtime(1691870691L);
        takenmapcellMapper.insert(takenmapcell);
    }


    @Test
    @Order(1)
    void testOtherMap(){
        MapDictVO mapDictVO = takenmapcellController.otherMap(mapId);
        // assert return result
        Assertions.assertEquals(mapDictVO.getNum(), 2);
        Assertions.assertEquals(mapDictVO.getX()[0], 10);
        Assertions.assertEquals(mapDictVO.getX()[1], 13);
        Assertions.assertEquals(mapDictVO.getY()[0], 4);
        Assertions.assertEquals(mapDictVO.getY()[1], 1);
        Assertions.assertEquals(mapDictVO.getHouseType()[0], 1);
        Assertions.assertEquals(mapDictVO.getHouseType()[1], 0);
        Assertions.assertEquals(mapDictVO.getFinishTime()[0], 1691870691L);
        Assertions.assertEquals(mapDictVO.getFinishTime()[1], 1691870691L);
    }

    @Test
    @Order(2)
    void testReadMap(){
        MapDictVO mapDictVO = takenmapcellController.readMap(id);
        // assert return result
        Assertions.assertEquals(mapDictVO.getNum(), 2);
        Assertions.assertEquals(mapDictVO.getX()[0], 10);
        Assertions.assertEquals(mapDictVO.getX()[1], 13);
        Assertions.assertEquals(mapDictVO.getY()[0], 4);
        Assertions.assertEquals(mapDictVO.getY()[1], 1);
        Assertions.assertEquals(mapDictVO.getHouseType()[0], 1);
        Assertions.assertEquals(mapDictVO.getHouseType()[1], 0);
        Assertions.assertEquals(mapDictVO.getFinishTime()[0], 1691870691L);
        Assertions.assertEquals(mapDictVO.getFinishTime()[1], 1691870691L);
    }

    @Test
    @Order(3)
    void testBuildHouse(){
        MapDictParam param = new MapDictParam();
        param.setX(14);
        param.setY(0);
        param.setHouseType(0);
        param.setId(id);
        param.setFinishTime(1691870691L);
        takenmapcellController.buildHouse(param);

        // assert database
        QueryWrapper<Takenmapcell> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("mapId", mapId).eq("positionX", 14).eq("positionY", 0);
        Takenmapcell takenmapcell = staticTakenmapcellMapper.selectOne(queryWrapper);
        Assertions.assertEquals(takenmapcell.getHousetype(), 0);
        Assertions.assertEquals(takenmapcell.getFinishtime(), 1691870691L);
    }



    @Test
    @Order(4)
    void testLevelUp(){
        MapDictParam param = new MapDictParam();
        param.setX(13);
        param.setY(1);
        param.setHouseType(10);
        param.setId(id);
        param.setFinishTime(1691872166L);
        takenmapcellController.levelUp(param);
        // assert database
        QueryWrapper<Takenmapcell> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("mapId", mapId).eq("positionX", 13).eq("positionY", 1);
        Takenmapcell takenmapcell = staticTakenmapcellMapper.selectOne(queryWrapper);
        Assertions.assertEquals(takenmapcell.getHousetype(), 10);
        Assertions.assertEquals(takenmapcell.getFinishtime(), 1691872166L);
    }

    @Test
    @Order(5)
    void testClearMapTime(){
        MapDictParam param = new MapDictParam();
        param.setX(10);
        param.setY(4);
        param.setHouseType(0);
        param.setId(id);
        //param.setFinishTime(1691872166L);
        takenmapcellController.clearMapTime(param);
        // assert database
        QueryWrapper<Takenmapcell> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("mapId", mapId).eq("positionX", 10).eq("positionY", 4);
        Takenmapcell takenmapcell = staticTakenmapcellMapper.selectOne(queryWrapper);
        Assertions.assertEquals(takenmapcell.getHousetype(), 1);
        Assertions.assertEquals(takenmapcell.getFinishtime(), 0);
    }

    @AfterAll
    static void cleanDatabase(){
        User user = staticUserMapper.selectById(id);
        staticUserMapper.deleteById(id);
        staticTakenmapcellMapper.deleteById(user.getCityMap());
    }
}
