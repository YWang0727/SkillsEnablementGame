package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.WatsonVO;
import com.imyuewang.EduCity.service.WatsonService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/watson/assistant")
@Api(tags = "Watson assistant controller")
public class WatsonController {

    @Autowired
    private WatsonService watsonService;

    @PostMapping("/message")
    @ApiOperation("receive message sent to watson assistant and return response")
    public ResultVO<WatsonVO> sendMessage(@RequestBody() WatsonVO watsonVO) {
        WatsonVO response = watsonService.sendMessage(watsonVO);
        return new ResultVO<>(response);
    }
}
