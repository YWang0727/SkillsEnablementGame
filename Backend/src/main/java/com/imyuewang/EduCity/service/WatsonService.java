package com.imyuewang.EduCity.service;

import com.imyuewang.EduCity.model.vo.WatsonVO;
import org.springframework.stereotype.Service;

@Service
public interface WatsonService {

    WatsonVO sendMessage(WatsonVO watsonVO);
}
