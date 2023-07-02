package com.imyuewang.EduCity.controller.api;

import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
}
