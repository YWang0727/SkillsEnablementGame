package com.imyuewang.EduCity.controller.api;

import com.imyuewang.EduCity.annotation.Auth;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @ClassName LearningController
 * @Description
 * @Author Yue Wang
 * @Date 2023/7/2 12:53
 **/
@Slf4j
@RestController
@RequestMapping("/learn")
@Api(tags = "Learning Management Interface")
public class LearningController {
}
