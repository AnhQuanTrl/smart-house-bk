package com.salt.smarthomebackend.messaging;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class DeviceMessagePublisher {
    @Autowired
    private MessageGateway messageGateway;

    public void publishMessage(String deviceId, boolean mode) throws JsonProcessingException {
        Map<String, Object> message = new HashMap<>();
        message.put("id", deviceId);
        message.put("mode", mode);
        messageGateway.sendToMqtt(new ObjectMapper().writeValueAsString(message));
    }
}
