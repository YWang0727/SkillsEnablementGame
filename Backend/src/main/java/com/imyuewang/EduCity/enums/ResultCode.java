package com.imyuewang.EduCity.enums;

import lombok.Getter;

/**
 * 响应码
 * @Author: Yue Wang
 * @Date: 2023/5/3 9:10
 */
@Getter
public enum ResultCode {

    //操作成功
    SUCCESS(0000, "操作成功"),
    // token相关
    UNAUTHORIZED(1001, "没有登录"),
    INVALID_TOKEN(1002, "无效的token"),
    TOKEN_EXPIRED(1003, "token已过期"),
    // 权限相关
    FORBIDDEN(1004, "没有相关权限"),
    UNAUTHORIZED_OPERATION(1005, "未授权的操作"),
    // 参数校验相关
    VALIDATE_FAILED(1006, "参数校验失败"),

    // 未找到资源
    RESOURCE_NOT_FOUND(1007, "资源不存在"),
    USER_NOT_FOUND(1008, "用户不存在"),
    ROLE_NOT_FOUND(1009, "角色不存在"),
    PERMISSION_NOT_FOUND(1010, "权限不存在"),
    // 其他错误
    FAILED(2001, "操作失败"),
    DATABASE_ERROR(2002, "数据库操作异常"),

    ERROR(5000, "未知错误"),

    METHOD_NOT_ALLOWED(405, "Method not allowed!"),
    BAD_REQUEST(400, "Bad Request"),

    // setting
    UPLOAD_ERROR(3001, "File for avatar is too large!"),

    //email and password
    EMAIL_FOUND(4000,"Email is already existed!\nPlease Try another one!"),
    EMAIL_NOT_FOUND(4001,"It is valid new email！"),
    EMAIL_SENT(4002,"Email sent successfully!\nPlease check your email!"),
    PASSWORD_ERROR(4003,"Password or email is incorrect!\nPlease try again!"),
    ;


    private int code;
    private String msg;

    ResultCode(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }

}
