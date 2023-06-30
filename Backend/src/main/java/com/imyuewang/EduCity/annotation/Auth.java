package com.imyuewang.EduCity.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;


@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD, ElementType.TYPE}) // Indicates that this annotation can be applied to both classes and methods.
public @interface Auth {
    /**
     * permission ID，unique
     */
    long id();
    /**
     * permission name
     */
    String name();
}