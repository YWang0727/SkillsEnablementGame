package com.imyuewang.EduCity.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.apache.ibatis.reflection.MetaObject;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * @ClassName MybatisPlusConfig
 * @Description
 * @Author Yue Wang
 * @Date 2023/6/21 14:27
 **/
@Configuration
//@MapperScan("com.EduCity")
@Component
public class MapCellConfig implements MetaObjectHandler {
    @Override
    public void insertFill(MetaObject metaObject){
        this.setFieldValByName("buildtime",new Date(),metaObject);

    }

    @Override
    public void updateFill(MetaObject metaObject) {

    }
}
