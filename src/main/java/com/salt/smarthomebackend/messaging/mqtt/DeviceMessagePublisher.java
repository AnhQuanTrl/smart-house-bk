package com.salt.smarthomebackend.messaging.mqtt;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Component
public class DeviceMessagePublisher {
    @Autowired
    private MessageGateway messageGateway;

    public void publishMessage(String deviceId, boolean mode) throws JsonProcessingException {
        List<Map<String, Object>> lst = new LinkedList<>();
        Map<String, Object> message = new HashMap<>();
        message.put("device_id", deviceId);
        if (mode)
            message.put("values", new Integer[]{1, 255});
        else
            message.put("values", new Integer[]{0, 255});
        lst.add(message);
        String messageToSent = new ObjectMapper().writeValueAsString(lst);
        messageGateway.sendToMqtt(messageToSent);
    }
}
