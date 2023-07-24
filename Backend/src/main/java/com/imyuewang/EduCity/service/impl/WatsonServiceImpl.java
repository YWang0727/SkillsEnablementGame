package com.imyuewang.EduCity.service.impl;

import com.ibm.cloud.sdk.core.service.exception.BadRequestException;
import com.ibm.watson.assistant.v2.Assistant;
import com.ibm.watson.assistant.v2.model.*;
import com.imyuewang.EduCity.model.vo.WatsonVO;
import com.imyuewang.EduCity.service.WatsonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WatsonServiceImpl implements WatsonService {

    @Autowired
    private Assistant assistant;

    @Value("${ibm.watson.environment-id}")
    private String environmentId;

    /**
     * send message to watson assistant session
     */
    @Override
    public WatsonVO sendMessage(WatsonVO watsonVO) {
        WatsonVO response = new WatsonVO();

        // get session id
        String sessionId = watsonVO.getSessionId();
        if (watsonVO.getIsNewSession()) {
            sessionId = createNewSession();
        }

        // create message input
        MessageInput input = new MessageInput.Builder()
                .messageType("text")
                .text(watsonVO.getMessage())
                .build();

        // send message using session id
        MessageOptions messageOptions = null;
        try{
            messageOptions = new MessageOptions
                    .Builder(environmentId, sessionId)
                    .input(input)
                    .build();
            response.setIsNewSession(false);
        } catch (BadRequestException e) {
            // if session is expired, create a new session
            sessionId = createNewSession();
            messageOptions = new MessageOptions
                    .Builder(environmentId, sessionId)
                    .input(input)
                    .build();
            response.setIsNewSession(true);
        }

        MessageResponse messageResponse = assistant.message(messageOptions)
                .execute().getResult();

        System.out.println(messageResponse);
        System.out.println(messageResponse.getOutput().getGeneric().get(0).messageToUser());

        // process response to get response message
        List<RuntimeResponseGeneric> generic = messageResponse.getOutput().getGeneric();

        response.setMessage(generic.get(0).text());
        response.setSessionId(sessionId);

        return response;
    }

    /**
     * create a new session
     * a session can only be maintained up to 5 min
     */
    private String createNewSession() {
        CreateSessionOptions sessionOptions = new CreateSessionOptions
                .Builder(environmentId).build();
        SessionResponse response = assistant.createSession(sessionOptions)
                .execute()
                .getResult();

        return response.getSessionId();
    }
}
