package com.imyuewang.EduCity.service;

public interface OSSService {

    public String putObject(String bucketName, String key, byte[] file);

}
