package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.Sensor;
import com.salt.smarthomebackend.repository.SensorRepository;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class SensorController {
    SensorRepository sensorRepository;

    public SensorController(SensorRepository sensorRepository) {
        this.sensorRepository = sensorRepository;
    }

    @MessageMapping("/test/endpoints")
    @SendTo("/topic/test/subscription")
    public String all() {
        System.out.println("OK");
        return "Success";
    }
}
