package com.imyuewang.EduCity.exception;

import com.imyuewang.EduCity.enums.ResultCode;
import lombok.Getter;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @Author: Yue Wang
 * @Date: 2023/5/3 9:25
 */
@Getter
public class ApiException extends RuntimeException{

    private ResultCode resultCode;
    private String msg;

    public ApiException(ResultCode resultCode, String msg) {
        this.resultCode = resultCode;
        this.msg = msg;
    }

    public ApiException(ResultCode resultCode) {
        this.resultCode = resultCode;
        this.msg = resultCode.getMsg();
    }

}
