package com.imyuewang.EduCity.controller;

import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.exception.ApiException;
import com.imyuewang.EduCity.annotation.ExceptionCode;
import com.imyuewang.EduCity.model.vo.ResultVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.lang.reflect.Field;

/**
 * @ClassName ExceptionControllerAdvice
 * @Description Global exception handler
 * @Author Yue Wang
 * @Date 2023/5/3 9:22
 * @Version 1.0
 **/
@Slf4j
@RestControllerAdvice
public class ExceptionControllerAdvice {

    /**
     * @author Yue Wang
     * @date 20:33 2023/5/6
     * @param e ApiException
     * @return ResultVO with error message
     **/
    @ExceptionHandler(ApiException.class)
    public ResultVO<String> apiExceptionHandler(ApiException e) {
        // return error msg
        return new ResultVO<>(e.getResultCode(), e.getMsg());
    }

    /**
     *
     * @author Yue Wang
     * @date 20:33 2023/5/6
     * @param e MethodArgumentNotValidException
     * @return ResultVO with error message
     **/
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResultVO<String> methodArgumentNotValidExceptionHandler(MethodArgumentNotValidException e)
            throws NoSuchFieldException{

        String defaultMessage = e.getBindingResult().getAllErrors().get(0).getDefaultMessage();

        Class<?> parameterType = e.getParameter().getParameterType();

        String fieldName = e.getBindingResult().getFieldError().getField();
        Field field = parameterType.getDeclaredField(fieldName);
        ExceptionCode annotation = field.getAnnotation(ExceptionCode.class);

        if(annotation != null){
            return new ResultVO<>(annotation.value(), annotation.message(), defaultMessage);
        }

        return new ResultVO<>(ResultCode.VALIDATE_FAILED, defaultMessage);
    }

    /**
     * @author Yue Wang
     * @date 20:32 2023/5/6
     * @param e RuntimeException
     * @return ResultVO with error message
     **/
    @ExceptionHandler(RuntimeException.class)
    public ResultVO<String> runtimeExceptionHandler(RuntimeException e) {
        return new ResultVO<>(ResultCode.ERROR, "System error, pls try again later");
    }


}
