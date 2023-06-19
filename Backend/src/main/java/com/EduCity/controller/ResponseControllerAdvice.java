package com.EduCity.controller;

import com.EduCity.enums.ResultCode;
import com.EduCity.exception.ApiException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.EduCity.annotation.NotResponseBody;
import com.EduCity.model.vo.ResultVO;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

/**
 * @ClassName ResponseControllerAdvice
 * @Description 全局统一响应
 * @Author Yue Wang
 * @Date 2023/5/3 9:37
 * @Version 1.0
 **/
@RestControllerAdvice(basePackages = {"com.EduCity.controller"})
public class ResponseControllerAdvice implements ResponseBodyAdvice<Object> {


    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        // If false, won't carry out beforeBodyWrite()
        // If the return type of the interface is already ResultVO, there is no need for additional operations. Return false.
        // If method has annotation @NotResponseBody, return false
        return !(returnType.getParameterType().equals(ResultVO.class) || returnType.hasMethodAnnotation(NotResponseBody.class)) ;
    }

    @Override
    public Object beforeBodyWrite(Object data, MethodParameter returnType, MediaType selectedContentType, Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request, ServerHttpResponse response) {

        if(returnType.getGenericParameterType().equals(String.class)){
            ObjectMapper objectMapper = new ObjectMapper();
            try {
                return objectMapper.writeValueAsString(new ResultVO<>(data));
            } catch (JsonProcessingException e) {
                throw new ApiException(ResultCode.FAILED,"返回String类型错误");
            }
        }
        return new ResultVO<>(data);
    }
}
