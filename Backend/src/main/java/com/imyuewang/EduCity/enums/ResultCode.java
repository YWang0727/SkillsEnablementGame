package com.imyuewang.EduCity.enums;

import lombok.Getter;

/**
 * Respond code
 * @Author: Yue Wang
 * @Date: 2023/5/3 9:10
 */
@Getter
public enum ResultCode {

<<<<<<< HEAD
    //操作成功
    SUCCESS(0000, "操作成功"),
    // token相关
    UNAUTHORIZED(1001, "Not logged in"),
    TOKEN_EXPIRED(1003, "Expired token"),
    // 权限相关
    FORBIDDEN(1004, "没有相关权限"),
    UNAUTHORIZED_OPERATION(1005, "未授权的操作"),
    // 参数校验相关
    VALIDATE_FAILED(1006, "参数校验失败"),
=======
    // success
    SUCCESS(0000, "Success"),
    // token-related
    UNAUTHORIZED(1001, "UNAUTHORIZED"),
    INVALID_TOKEN(1002, "Invalid token"),
    TOKEN_EXPIRED(1003, "Expired token"),
    // Permission Related
    FORBIDDEN(1004, "No relevant permissions"),
    UNAUTHORIZED_OPERATION(1005, "Unauthorized operation"),
    // Parameter verification related
    VALIDATE_FAILED(1006, "Parameter validation failure"),
>>>>>>> 774130601bf3e6245532aaf4a05e4069071d0deb

    // No resources found
    RESOURCE_NOT_FOUND(1007, "No resources found"),
    USER_NOT_FOUND(1008, "The user does not exist"),
    ROLE_NOT_FOUND(1009, "Characters do not exist"),
    PERMISSION_NOT_FOUND(1010, "Permission does not exist"),
    // Other errors
    FAILED(2001, "Failure of an operation"),
    DATABASE_ERROR(2002, "Database operation exception"),

    ERROR(5000, "Unknown error"),

    METHOD_NOT_ALLOWED(405, "Method not allowed!"),
    BAD_REQUEST(400, "Bad Request"),

    // setting
    UPLOAD_ERROR(3001, "File for avatar is too large!"),

    //email and password
    EMAIL_FOUND(4000,"Email existed"),
    EMAIL_NOT_FOUND(4001,"Valid new email"),
    EMAIL_SENT(4002,"Email sent successfully"),
    PASSWORD_ERROR(4003,"Incorrect password or email"),
    ;


    private int code;
    private String msg;

    ResultCode(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }

}
