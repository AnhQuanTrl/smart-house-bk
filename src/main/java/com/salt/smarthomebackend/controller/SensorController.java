package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.Sensor;
import com.salt.smarthomebackend.repository.SensorRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class SensorController {
    SensorRepository sensorRepository;

    public SensorController(SensorRepository sensorRepository) {
        this.sensorRepository = sensorRepository;
    }

    @GetMapping("/sensors")
    List<Sensor> all() {
        return sensorRepository.findAll();
    }
}
