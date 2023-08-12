package com.imyuewang.EduCity;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.imyuewang.EduCity.controller.api.AuthController;
import com.imyuewang.EduCity.controller.api.MapController;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.Citymap;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.ComponentsParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.vo.ComponentsVO;
import com.imyuewang.EduCity.model.vo.LeaderboardVO;
import com.imyuewang.EduCity.service.impl.UserServiceImpl;
import com.imyuewang.EduCity.util.CommonUtil;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;


/**
 * @ClassName EduCityCityMapTests
 * @Description
 * @Author hanyu
 * @Date 2023/8/9
 **/
@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class EduCityCityMapTests {

    @Autowired
    UserServiceImpl userServiceImpl;

    @Autowired
    MapController mapController;

    @Autowired
    AuthController authController;

    private static CitymapMapper staticCitymapMapper;
    private static UserMapper staticUserMapper;

    static Long id;
    static Long id2;
    static Long id3;

    @BeforeAll
    public static void setUp(@Autowired UserServiceImpl userServiceImpl,
                             @Autowired AuthController authController,
                             @Autowired CitymapMapper citymapMapper,
                             @Autowired UserMapper userMapper) {
        staticCitymapMapper = citymapMapper;
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

        //create two new user
        param.setEmail("test2@gmail.com");
        queryWrapper.eq("email", "test2@gmail.com");
        userCount = userMapper.selectCount(queryWrapper);
        if(userCount != 1){
            authController.register(param);
        }
        User user2 = userServiceImpl.getUserByEmail("test2@gmail.com");
        id2 = user2.getId();

        param.setEmail("test3@gmail.com");
        queryWrapper.eq("email", "test3@gmail.com");
        userCount = userMapper.selectCount(queryWrapper);
        if(userCount != 1){
            authController.register(param);
        }
        User user3 = userServiceImpl.getUserByEmail("test3@gmail.com");
        id3 = user3.getId();
    }


    @Test
    @Order(1)
    void testGetComponents(){
        ComponentsVO componentsVO = mapController.getComponents(id);
        // assert return result
        Assertions.assertEquals(componentsVO.getGold(), 0);
        Assertions.assertEquals(componentsVO.getProsperity(), 0);
        Assertions.assertEquals(componentsVO.getConstruction_speed(), 1);
        //Assertions.assertEquals(componentsVO.getGold_get_time(), 0);
    }

    @Test
    @Order(2)
    void testPushGetComponents(){
        //push
        ComponentsParam param = new ComponentsParam();
        param.setId(id);
        param.setGold(200L);
        param.setProsperity(20L);
        param.setConstruction_speed(2);
        param.setGold_get_time(1691841147L);
        mapController.pushComponents(param);

        // assert database
        Citymap citymap = staticCitymapMapper.selectById(id);
        Assertions.assertEquals(citymap.getGold(),200L);
        Assertions.assertEquals(citymap.getProsperity(),20L);
        Assertions.assertEquals(citymap.getConstructionspeed(),2);
        Assertions.assertEquals(citymap.getGoldgettime(),1691841147L);

        //get
        ComponentsVO componentsVO = mapController.getComponents(id);
        // assert return result
        Assertions.assertEquals(componentsVO.getGold(), 200L);
        Assertions.assertEquals(componentsVO.getProsperity(), 20L);
        Assertions.assertEquals(componentsVO.getConstruction_speed(), 2);
        Assertions.assertEquals(componentsVO.getGold_get_time(), 1691841147L);

        //Prosperity null
        param.setId(id);
        param.setGold(300L);
        mapController.pushComponents(param);
        citymap = staticCitymapMapper.selectById(id);
        Assertions.assertEquals(citymap.getGold(),300L);
        Assertions.assertEquals(citymap.getProsperity(),20L);
    }

    @Test
    @Order(3)
    void testLeaderBoard(){
        //store and clear citymap
        User user = staticUserMapper.selectById(id);
        User user2 = staticUserMapper.selectById(id2);
        User user3 = staticUserMapper.selectById(id3);
        QueryWrapper<Citymap> queryWrapper = new QueryWrapper<>();
        queryWrapper.ne("id", user.getCityMap()).ne("id", user2.getCityMap()).ne("id", user3.getCityMap());
        List citymap = staticCitymapMapper.selectList(queryWrapper);
        staticCitymapMapper.delete(queryWrapper);

        //set user2 user3 Prosperity
        ComponentsParam param = new ComponentsParam();
        param.setId(id);
        param.setProsperity(20L);
        mapController.pushComponents(param);
        param.setId(id2);
        param.setProsperity(200L);
        mapController.pushComponents(param);
        param.setId(id3);
        param.setProsperity(300L);
        mapController.pushComponents(param);
        LeaderboardVO leaderboardVO = mapController.leaderBoard(id);


        // assert return result
        Assertions.assertEquals(leaderboardVO.getTotal_num(), 3);
        Assertions.assertEquals(leaderboardVO.getProsperity(), 20);
        Assertions.assertEquals(leaderboardVO.getName(), "My City");
        String[] all_name = {"My City", "My City", "My City"};
        long[] all_prosperity = {300L, 200L, 20L};
        long[] all_id = {user3.getCityMap(), user2.getCityMap(), user.getCityMap()};
        Assertions.assertEquals(leaderboardVO.getAll_id()[0], all_id[0]);
        Assertions.assertEquals(leaderboardVO.getAll_id()[1], all_id[1]);
        Assertions.assertEquals(leaderboardVO.getAll_id()[2], all_id[2]);
        Assertions.assertEquals(leaderboardVO.getAll_prosperity()[0], all_prosperity[0]);
        Assertions.assertEquals(leaderboardVO.getAll_prosperity()[1], all_prosperity[1]);
        Assertions.assertEquals(leaderboardVO.getAll_prosperity()[2], all_prosperity[2]);
        Assertions.assertEquals(leaderboardVO.getAll_name()[0], all_name[0]);
        Assertions.assertEquals(leaderboardVO.getAll_name()[1], all_name[1]);
        Assertions.assertEquals(leaderboardVO.getAll_name()[2], all_name[2]);

        //reset citymap
        //bug---if test leaderboard fail, database citymap lost
        for (int i = 0; i < citymap.size(); i++) {
            staticCitymapMapper.insert((Citymap) citymap.get(i));
        }

    }


    @AfterAll
    static void cleanDatabase(){
        User user = staticUserMapper.selectById(id);
        staticUserMapper.deleteById(id);
        staticCitymapMapper.deleteById(user.getCityMap());

        User user2 = staticUserMapper.selectById(id2);
        staticUserMapper.deleteById(id2);
        staticCitymapMapper.deleteById(user2.getCityMap());

        User user3 = staticUserMapper.selectById(id3);
        staticUserMapper.deleteById(id3);
        staticCitymapMapper.deleteById(user3.getCityMap());
    }
}
