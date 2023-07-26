package com.imyuewang.EduCity.service;

import com.imyuewang.EduCity.model.param.SaveParam;
import org.springframework.stereotype.Service;

/**
 * @ClassName SaveService
 * @Description
 * @Author Yue Wang
 * @Date 2023/7/26 21:22
 **/
@Service
public interface SaveService {

    void save(SaveParam param);
}
