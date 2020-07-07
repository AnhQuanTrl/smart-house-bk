package com.salt.smarthomebackend.messaging.mqtt;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.user.SimpUser;
import org.springframework.messaging.simp.user.SimpUserRegistry;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class DeviceMessagePublisher {
    @Autowired
    private MessageGateway messageGateway;
    @Autowired
    SimpMessagingTemplate template;
    @Autowired
    private SimpUserRegistry simpUserRegistry;
    @Autowired
    LightBulbRepository lightBulbRepository;
    public void publishMessage(LightBulb lightBulb) throws JsonProcessingException {
        List<Map<String, Object>> lst = new LinkedList<>();
        Map<String, Object> message = new HashMap<>();
        message.put("device_id", lightBulb.getName());
        message.put("values", new String[]{"1", lightBulb.getValue().toString()});
        lst.add(message);
        if (lightBulb.getClient() != null) {
            SimpUser simpUser =
                    simpUserRegistry.getUser(lightBulb.getClient().getJwt());
            if (simpUser != null) {
                template.convertAndSendToUser(simpUser.getName(), "/topic/message",
                        lightBulb);
            }
        }
        String messageToSent = new ObjectMapper().writeValueAsString(lst);
        messageGateway.sendToMqtt(messageToSent);
    }
}
