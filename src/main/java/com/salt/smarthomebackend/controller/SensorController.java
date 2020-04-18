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

    @MessageMapping("/sensors")
    @SendTo("/topic/result")
    public List<Sensor> all() {
        return sensorRepository.findAll();
    }
}
