package com.imyuewang.EduCity.service.impl;

import com.imyuewang.EduCity.service.OSSService;
import com.imyuewang.EduCity.config.OSSConfig;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

@Service
public class OSSServiceImpl implements OSSService {
    private S3Client s3;

    public OSSServiceImpl() {
        AwsBasicCredentials awsBasicCredentials = AwsBasicCredentials.create("AKIASJCBGYOULFO355B4", "fLzOtbLZPON3gac6/4VHKjU1UNybL6mS/JgcZoEr");

        s3 = S3Client.builder().
                credentialsProvider(StaticCredentialsProvider.create(awsBasicCredentials)).
                region(Region.of("eu-north-1")).
                build();
    }

    public String putObject(String bucketName, String key, byte[] file) {
        PutObjectRequest objectRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .build();

        s3.putObject(objectRequest, RequestBody.fromBytes(file));

        String url = "https://" + OSSConfig.BUCKET + ".s3." + OSSConfig.REGION + ".amazonaws.com/" + key;
        return url;
    }
}
