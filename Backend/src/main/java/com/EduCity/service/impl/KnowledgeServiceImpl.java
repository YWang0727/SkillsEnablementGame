package com.EduCity.service.impl;

import com.EduCity.service.KnowledgeService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.EduCity.model.entity.Knowledge;
import com.EduCity.mapper.KnowledgeMapper;
import org.springframework.stereotype.Service;

/**
* @author Sarah Wang
* @description 针对表【knowledge】的数据库操作Service实现
* @createDate 2023-06-18 20:42:45
*/
@Service
public class KnowledgeServiceImpl extends ServiceImpl<KnowledgeMapper, Knowledge>
    implements KnowledgeService {

}




