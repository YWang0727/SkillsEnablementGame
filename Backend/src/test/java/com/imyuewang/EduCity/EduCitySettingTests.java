package com.imyuewang.EduCity;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.imyuewang.EduCity.config.PasswordEncoder;
import com.imyuewang.EduCity.controller.api.AuthController;
import com.imyuewang.EduCity.controller.api.SettingController;
import com.imyuewang.EduCity.controller.api.TakenmapcellController;
import com.imyuewang.EduCity.enums.HouseType;
import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.mapper.CitymapMapper;
import com.imyuewang.EduCity.mapper.TakenmapcellMapper;
import com.imyuewang.EduCity.mapper.UserMapper;
import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.EditPasswordParam;
import com.imyuewang.EduCity.model.param.EditUserParam;
import com.imyuewang.EduCity.model.param.MapDictParam;
import com.imyuewang.EduCity.model.param.RegisterParam;
import com.imyuewang.EduCity.model.vo.PropertyInfoVO;
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.UserVO;
import com.imyuewang.EduCity.service.impl.UserServiceImpl;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;

import javax.annotation.Resource;
import java.io.IOException;

@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class EduCitySettingTests {

    @Autowired
    private SettingController settingController;

    @Autowired
    private AuthController authController;

    @Resource
    private UserMapper userMapper;

    private static Long id;
    private static Long anotherId;

    /**
     * initialize the database
     */
    @BeforeAll
    static void setUp(@Autowired AuthController authController,
                      @Autowired UserMapper userMapper,
                      @Autowired UserServiceImpl userService,
                      @Autowired TakenmapcellController takenmapcellController) {
       // 1. register a new user
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
        // get and store user id
        User user = userService.getUserByEmail(param.getEmail());
        id = user.getId();
        Long cityMap = user.getCityMap();

        // 2. initialize taken map cell of default user
        MapDictParam mapDictParam = new MapDictParam();
        mapDictParam.setX(2);
        mapDictParam.setY(2);
        mapDictParam.setId(cityMap);
        mapDictParam.setHouseType(HouseType.BANK_1.getCode());

        takenmapcellController.buildHouse(mapDictParam);

        mapDictParam.setX(3);
        mapDictParam.setY(3);
        mapDictParam.setId(cityMap);
        mapDictParam.setHouseType(HouseType.BANK_2.getCode());

        takenmapcellController.buildHouse(mapDictParam);

        mapDictParam.setX(4);
        mapDictParam.setY(4);
        mapDictParam.setId(cityMap);
        mapDictParam.setHouseType(HouseType.CONSTRUCTION_SITE_1.getCode());

        takenmapcellController.buildHouse(mapDictParam);

        // 3. register another user for tests
        RegisterParam registerParam = new RegisterParam();
        registerParam.setEmail("testduplicate@gmail.com");
        registerParam.setActivecode("834945");
        registerParam.setName("testUser2");
        registerParam.setPassword("123456");

        queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("email", "testduplicate@gmail.com");
        if(userMapper.selectCount(queryWrapper) != 1){
            authController.register(registerParam);
        }
        anotherId = userService.getUserByEmail("testduplicate@gmail.com").getId();
    }

    /**
     * get user information
     */
    @Test
    @Order(1)
    void testGetUserInfo() {
        ResultVO<UserVO> userInfo = settingController.getUserInfo(id);
        String name = userInfo.getData().getName();
        String email = userInfo.getData().getEmail();

        // check result code
        assertEquals(ResultCode.SUCCESS.getCode(), userInfo.getCode());
        // check user information
        assertEquals("testUser", name, "Username is incorrect.");
        assertEquals("test@gmail.com", email, "User's email is incorrect.");
    }

    /**
     * get user's property information
     */
    @Test
    @Order(2)
    void testGetUserProperty(){
        ResultVO<PropertyInfoVO> propertyInfo = settingController.getPropertyInfo(id);

        // check result code
        assertEquals( ResultCode.SUCCESS.getCode(), propertyInfo.getCode());
        // check user property information
        assertEquals(2, propertyInfo.getData().getBankAmount());
        assertEquals(1,  propertyInfo.getData().getConstructionSiteAmount());
        assertEquals(0, propertyInfo.getData().getFarmAmount());
    }

    /**
     * edit user's information
     * @throws IOException
     */
    @Test
    @Order(3)
    void testEditUserInfo() throws IOException {
        EditUserParam editUserParam = new EditUserParam();
        editUserParam.setId(id);
        editUserParam.setName("newName");
        editUserParam.setEmail("new@gmail.com");
        // create a mock multipartFile which is empty
        MockMultipartFile mockMultipartFile =
                    new MockMultipartFile("avatar", new byte[0]);

        ResultVO resultVO = settingController.editUserInfo(mockMultipartFile, editUserParam);
        // check result code
        assertEquals(ResultCode.SUCCESS.getCode(), resultVO.getCode());
        // check user information again
        ResultVO<UserVO> userInfo = settingController.getUserInfo(id);
        assertEquals("newName", userInfo.getData().getName());
        assertEquals("new@gmail.com", userInfo.getData().getEmail());
        assertEquals(null, userInfo.getData().getAvatarStr());
    }

    /**
     * edit user's password
     */
    @Test
    @Order(4)
    void testEditPassword() {
        EditPasswordParam editPasswordParam = new EditPasswordParam();
        editPasswordParam.setId(id);
        editPasswordParam.setOldPassword("123456");
        editPasswordParam.setNewPassword("654321");

        ResultVO resultVO = settingController.editPassword(editPasswordParam);
        // check result code
        assertEquals(ResultCode.SUCCESS.getCode(), resultVO.getCode());
        // check new password value
        User user = userMapper.selectById(id);
        String password = user.getPassword();
        assertTrue(PasswordEncoder.matches("654321", password), "Fail to change password");
    }

    /**
     * email format is incorrect
     */
    @Test
    @Order(5)
    void testInvalidEmail() throws IOException {
        // invalid email address
        EditUserParam editUserParam = new EditUserParam();
        editUserParam.setId(id);
        editUserParam.setName("newName");
        editUserParam.setEmail("newnewgmail.com");
        assertThrows(ApiException.class, () -> {
            settingController.editUserInfo(new MockMultipartFile("avatar", new byte[0]), editUserParam);
        });
    }

    /**
     * try to update email address to an existed email
     */
    @Test
    @Order(6)
    void testDuplicatedEmail() throws IOException {
        EditUserParam editUserParam = new EditUserParam();
        editUserParam.setId(id);
        editUserParam.setName("newName");
        editUserParam.setEmail("testduplicate@gmail.com");
        assertThrows(ApiException.class, () -> {
            settingController.editUserInfo(new MockMultipartFile("avatar", new byte[0]), editUserParam);
        });
    }

    @AfterAll
    static void clean(@Autowired UserMapper userMapper,
                      @Autowired CitymapMapper citymapMapper,
                      @Autowired TakenmapcellMapper takenmapcellMapper) {
        User user = userMapper.selectById(id);
        userMapper.deleteById(id);
        citymapMapper.deleteById(user.getCityMap());
        // clear taken map cells data
        takenmapcellMapper.deleteById(user.getCityMap());

        User user2 = userMapper.selectById(anotherId);
        userMapper.deleteById(anotherId);
        citymapMapper.deleteById(user2.getCityMap());
    }
}
