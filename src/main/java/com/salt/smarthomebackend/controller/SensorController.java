package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.*;
import com.salt.smarthomebackend.repository.SensorRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class SensorController {
    SensorRepository sensorRepository;

    public SensorController(SensorRepository sensorRepository) {
        this.sensorRepository = sensorRepository;
    }

    @PostMapping(path="/add") // Map ONLY POST Requests
    public @ResponseBody String addNewSensor(@RequestParam String _type, @RequestParam String _name, @RequestParam String _location, @RequestParam Boolean _status ) {
        // @ResponseBody means the returned String is the response, not a view name
        // @RequestParam means it is a parameter from the GET or POST request
        Sensor s = null;
        switch(_type){
            case "Light":
                s = new LightSensor(_name, _location, _status, null);
                break;
            case "Humid":
                s = new HumidSensor(_name, _location, _status, null);
                break;
            case "Temp":
                s = new TempSensor(_name, _location, _status, null);
                break;
        }

        sensorRepository.save(s);
        return "Saved";
    }

    @GetMapping("/sensors")
    List<Sensor> all() {
        return (List<Sensor>) sensorRepository.findAll();
    }
}

