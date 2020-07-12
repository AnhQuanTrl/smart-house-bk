package com.salt.smarthomebackend.messaging.mqtt;

import org.springframework.integration.annotation.MessagingGateway;

@MessagingGateway(defaultRequestChannel = "mqttOutboundChannel")
public interface MessageGateway {
    void sendToMqtt(String data);
}