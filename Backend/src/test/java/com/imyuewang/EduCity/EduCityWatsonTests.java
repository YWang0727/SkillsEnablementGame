package com.imyuewang.EduCity;

import com.imyuewang.EduCity.controller.api.WatsonController;
import com.imyuewang.EduCity.enums.ResultCode;
import com.imyuewang.EduCity.model.vo.ResultVO;
import com.imyuewang.EduCity.model.vo.WatsonVO;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.Arrays;

@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class EduCityWatsonTests {

    @Autowired
    private WatsonController watsonController;

    private static String sessionId;

    /**
     * create a new session and get welcome message
     */
    @Test
    @Order(0)
    void testNewSession() {
        WatsonVO watsonVO = new WatsonVO();
        watsonVO.setMessages(new ArrayList<>(Arrays.asList("")));
        watsonVO.setOptions(null);
        watsonVO.setSessionId(null);
        watsonVO.setIsNewSession(true);

        ResultVO<WatsonVO> result = watsonController.sendMessage(watsonVO);
        // check result code
        assertEquals(ResultCode.SUCCESS.getCode(), result.getCode());
        // check response
        assertTrue(result.getData().getMessages().get(0).contains("Welcome"));
        assertFalse(result.getData().getIsNewSession());
        sessionId = result.getData().getSessionId();
    }

    /**
     * after getting welcome greeting, send a normal message and get normal response
     */
    @Test
    @Order(1)
    void testSendMessage() {
        WatsonVO watsonVO = new WatsonVO();
        watsonVO.setMessages(new ArrayList<>(Arrays.asList("How to earn money?")));
        watsonVO.setOptions(null);
        watsonVO.setSessionId(sessionId);
        watsonVO.setIsNewSession(false);

        ResultVO<WatsonVO> resultVO = watsonController.sendMessage(watsonVO);
        // check result code
        assertEquals(ResultCode.SUCCESS.getCode(), resultVO.getCode());
        // check response
        assertTrue(resultVO.getData().getMessages().get(0).contains("next day"));
        assertEquals(sessionId, resultVO.getData().getSessionId());
        assertFalse(resultVO.getData().getIsNewSession());
    }

    /**
     * send message and get response with options
     * choose a option and get response
     */
    @Test
    @Order(2)
    void testOption() {
        WatsonVO watsonVO = new WatsonVO();
        watsonVO.setMessages(new ArrayList<>(Arrays.asList("hello")));
        watsonVO.setOptions(null);
        watsonVO.setSessionId(sessionId);
        watsonVO.setIsNewSession(false);

        // send a human-like message so that watson fallback case will be activated
        ResultVO<WatsonVO> resultVO = watsonController.sendMessage(watsonVO);
        // check result code
        assertEquals(ResultCode.SUCCESS.getCode(), resultVO.getCode());
        // check response
        assertEquals("help", resultVO.getData().getOptions().get(0));
        assertEquals("no", resultVO.getData().getOptions().get(1));
        assertEquals(sessionId, resultVO.getData().getSessionId());
        assertFalse(resultVO.getData().getIsNewSession());

        // choose 'no' option
        watsonVO = new WatsonVO();
        watsonVO.setMessages(new ArrayList<>(Arrays.asList("no")));
        watsonVO.setOptions(null);
        watsonVO.setSessionId(sessionId);
        watsonVO.setIsNewSession(false);

        resultVO = watsonController.sendMessage(watsonVO);
        // check result code
        assertEquals(ResultCode.SUCCESS.getCode(), resultVO.getCode());
        // check response
        assertTrue(resultVO.getData().getMessages().get(0).contains("next time"));
        assertEquals(sessionId, resultVO.getData().getSessionId());
        assertFalse(resultVO.getData().getIsNewSession());
    }

    /**
     * When session id is wrong or expired
     */
    @Test
    @Order(3)
    void testInvalidSessionId() {
        String invalidSession = "invalidSessionId";
        WatsonVO watsonVO = new WatsonVO();
        watsonVO.setMessages(new ArrayList<>(Arrays.asList("")));
        watsonVO.setOptions(null);
        watsonVO.setSessionId(invalidSession);
        watsonVO.setIsNewSession(false);

        ResultVO<WatsonVO> resultVO = watsonController.sendMessage(watsonVO);
        // check result code
        assertEquals(ResultCode.SUCCESS.getCode(), resultVO.getCode());
        // check response
        assertTrue(resultVO.getData().getMessages().get(0).contains("Welcome"));
        assertNotEquals(sessionId, resultVO.getData().getSessionId());
        assertTrue(resultVO.getData().getIsNewSession());
    }
}
