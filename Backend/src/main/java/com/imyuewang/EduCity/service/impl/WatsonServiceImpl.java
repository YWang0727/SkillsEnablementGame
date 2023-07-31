package com.imyuewang.EduCity.service.impl;

import com.ibm.watson.assistant.v2.Assistant;
import com.ibm.watson.assistant.v2.model.*;
import com.imyuewang.EduCity.model.vo.WatsonVO;
import com.imyuewang.EduCity.service.WatsonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
        WatsonVO watsonResponse = new WatsonVO();

        // create a new session if user asked so
        if (watsonVO.getIsNewSession()) {
            watsonResponse.setSessionId(createNewSession());
        } else {
            watsonResponse.setSessionId(watsonVO.getSessionId());
        }

        // send message to session
        MessageInput input = new MessageInput.Builder()
                .messageType("text")
                .text(watsonVO.getMessages().get(0))
                .build();
        MessageResponse messageResponse = sendToSession(input, watsonResponse);

        // classify response to get response message and options
        // if there is no text type, message will be null
        List<RuntimeResponseGeneric> genericList = messageResponse.getOutput().getGeneric();
        for (RuntimeResponseGeneric generic : genericList) {
            if (generic.responseType().equals("suggestion")) {
                processSuggestions(generic, watsonResponse);
                watsonResponse.getMessages().add(generic.title());
            } else if (generic.responseType().equals("text")) {
                if (generic.text() != null && !generic.text().isBlank()) {
                    watsonResponse.getMessages().add(generic.text());
                }
            } else if (generic.responseType().equals("option")) {
                processOptions(generic, watsonResponse);
            }
        }

        return watsonResponse;
    }

    private void processSuggestions(RuntimeResponseGeneric generic, WatsonVO watsonResponse) {
        ArrayList<String> options = watsonResponse.getOptions();
        for (DialogSuggestion suggestion : generic.suggestions()) {
            options.add(suggestion.getLabel());
        }
    }

    private void processOptions(RuntimeResponseGeneric generic, WatsonVO watsonResponse) {
        ArrayList<String> options = watsonResponse.getOptions();
        for (DialogNodeOutputOptionsElement option : generic.options()) {
            options.add(option.getLabel());
        }
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

    /**
     * send message to session by sessionId
     * create a new session if it's expired
     */
    private MessageResponse sendToSession(MessageInput input, WatsonVO watsonResponse) {
        MessageOptions messageOptions = null;
        MessageResponse messageResponse = null;

        try{
            messageOptions = new MessageOptions
                    .Builder(environmentId, watsonResponse.getSessionId())
                    .input(input)
                    .build();
            // send message to session
            messageResponse = assistant.message(messageOptions)
                    .execute().getResult();

            watsonResponse.setIsNewSession(false);
        } catch (Exception e) {
            // if session is expired, create a new session
            watsonResponse.setSessionId(createNewSession());
            messageOptions = new MessageOptions
                    .Builder(environmentId, watsonResponse.getSessionId())
                    .input(input)
                    .build();
            // send message to session
            messageResponse = assistant.message(messageOptions)
                    .execute().getResult();

            watsonResponse.setIsNewSession(true);
        }

        System.out.println(messageResponse);
        return messageResponse;
    }
}
