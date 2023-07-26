package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.model.entity.User;
import com.imyuewang.EduCity.model.param.ComponentsParam;
import com.imyuewang.EduCity.model.vo.ComponentsVO;
import com.imyuewang.EduCity.model.vo.LeaderboardVO;
import com.imyuewang.EduCity.model.vo.UserVO;
import com.imyuewang.EduCity.service.CitymapService;
import com.imyuewang.EduCity.service.SettingService;
import com.imyuewang.EduCity.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
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

    @GetMapping("/getComponents/{id}")
    @ApiOperation("return components information")
    public ComponentsVO getComponents(@PathVariable Long id) {
        ComponentsVO componentsVO = citymapService.getComponents(id);
        return componentsVO;
    }


    @PostMapping("/pushComponents")
    @ApiOperation("game manager to database")
    public void pushComponents(@RequestBody  @Valid ComponentsParam param){
        citymapService.pushComponents(param);
        return;
    }


}
