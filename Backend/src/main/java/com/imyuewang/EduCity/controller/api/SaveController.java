package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.model.param.QuizParam;
import com.imyuewang.EduCity.model.param.SaveParam;
import com.imyuewang.EduCity.model.vo.QuizVO;
import com.imyuewang.EduCity.service.CitymapService;
import com.imyuewang.EduCity.service.SaveService;
import com.imyuewang.EduCity.service.TakenmapcellService;
import com.imyuewang.EduCity.service.UserQuizService;
import com.imyuewang.EduCity.util.CommonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @ClassName SaveController
 * @Description
 * @Author Yue Wang
 * @Date 2023/7/26 19:13
 **/
@Slf4j
@RestController
@RequestMapping("/save")
@Api(tags = "Saving Interface")
public class SaveController {
    @Autowired
    private SaveService saveService;

    @PostMapping("/save")
    @ApiOperation(value = "save all dynamic data")
    public String save(@RequestBody SaveParam param) {
        saveService.save(param);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

    @PostMapping("/save_auto")
    @ApiOperation(value = "save all dynamic data")
    public String save_auto(@RequestBody SaveParam param) {
        saveService.save(param);
        return CommonUtil.ACTION_SUCCESSFUL;
    }

}
