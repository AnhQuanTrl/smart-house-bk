package com.salt.smarthomebackend.gateway;

import org.springframework.integration.annotation.MessagingGateway;

@MessagingGateway(defaultRequestChannel = "mqttOutboundChannel")
public interface MessageGateway {
    void sendToMqtt(String data);

}