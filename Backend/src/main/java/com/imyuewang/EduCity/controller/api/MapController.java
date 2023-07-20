package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.model.param.LeaderBoardParam;
import com.imyuewang.EduCity.model.vo.ComponentsVO;
import com.imyuewang.EduCity.model.vo.LeaderboardVO;
import com.imyuewang.EduCity.model.vo.UserInfoVO;
import com.imyuewang.EduCity.service.CitymapService;
import com.imyuewang.EduCity.service.SettingService;
import com.imyuewang.EduCity.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Base64;

/**
 * @ClassName MapController
 * @Description
 * @Author Yue Wang
 * @Date 2023/7/2 12:43
 **/
@Slf4j
@Validated
@RestController
@RequestMapping("/map")
@Api(tags = "Map Management Interface")
public class MapController {
    @Autowired
    private CitymapService citymapService;

    @Autowired
    private UserService userService;

    @GetMapping("/leaderBoard/{id}")
    @ApiOperation("return leaderboard information")
    public LeaderboardVO leaderBoard(@PathVariable Long id) {
        LeaderboardVO leaderBoardVO = citymapService.leaderBoard(id);
        return leaderBoardVO;
    }

    @GetMapping("/components/{id}")
    @ApiOperation("return leaderboard information")
    public ComponentsVO components(@PathVariable Long id) {
        ComponentsVO componentsVO = citymapService.components(id);
        return componentsVO;
    }


}
