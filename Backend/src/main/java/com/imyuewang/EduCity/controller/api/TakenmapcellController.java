package com.imyuewang.EduCity.controller.api;
import com.imyuewang.EduCity.model.param.MapDictParam;
import com.imyuewang.EduCity.model.vo.MapDictVO;
import com.imyuewang.EduCity.service.CitymapService;
import com.imyuewang.EduCity.service.TakenmapcellService;
import com.imyuewang.EduCity.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;

/**
 * @ClassName takenmapcellController
 * @Description
 * @Author hanyu
 * @Date 2023/7/21 12:43
 **/
@Slf4j
@Validated
@RestController
@RequestMapping("/map_cell")
@Api(tags = "Map Cell Management Interface")
public class TakenmapcellController {
    @Autowired
    private CitymapService citymapService;

    @Autowired
    private UserService userService;

    @Autowired
    private TakenmapcellService takenmapcellService;

    @GetMapping("/readMap/{id}")
    @ApiOperation("read map info")
    public MapDictVO readMap(@PathVariable Long id) {
        MapDictVO mapDictVO = takenmapcellService.readMap(id);
        return mapDictVO;
    }


    @PostMapping("/buildHouse")
    @ApiOperation("build new house")
    public void buildHouse(@RequestBody  @Valid MapDictParam param){
        takenmapcellService.buildHouse(param);
    }


    @GetMapping("/otherMap/{id}")
    @ApiOperation("leaderBoard jump to other map")
    public MapDictVO otherMap(@PathVariable Long id){
        MapDictVO mapDictVO = takenmapcellService.otherMap(id);
        return mapDictVO;
    }

    @PostMapping("/levelUp")
    @ApiOperation("house level + 1")
    public void levelUp(@RequestBody  @Valid MapDictParam param){
        takenmapcellService.levelUp(param);
    }

    @PostMapping("/clearMapTime")
    @ApiOperation("reset finishTime to 0")
    public void clearMapTime(@RequestBody  @Valid MapDictParam param){
        takenmapcellService.clearMapTime(param);
    }


}

