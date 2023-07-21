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
    public void pushComponents(@RequestBody  @Valid MapDictParam param){
        takenmapcellService.buildHouse(param);
    }


}
