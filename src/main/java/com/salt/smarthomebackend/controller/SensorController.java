package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.*;
import com.salt.smarthomebackend.repository.DeviceRepository;
import org.springframework.web.bind.annotation.*;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class SensorController {
    DeviceRepository sensorRepository;

    public SensorController(DeviceRepository sensorRepository) {
        this.sensorRepository = sensorRepository;
    }

//    @PostMapping(path="/add") // Map ONLY POST Requests
//    public @ResponseBody String addNewSensor(@RequestParam String _type, @RequestParam String _name, @RequestParam String _location, @RequestParam Boolean _status ) {
//        // @ResponseBody means the returned String is the response, not a view name
//        // @RequestParam means it is a parameter from the GET or POST request
//        Device s = null;
//        switch(_type){
//            case "Light":
//                s = new LightSensor(_name, _location, _status, null);
//                break;
//            case "Humid":
//                s = new HumidSensor(_name, _location, _status, null);
//                break;
//            case "Temp":
//                s = new TempSensor(_name, _location, _status, null);
//                break;
//        }
//
//        sensorRepository.save(s);
//        return "Saved";
//    }

    @GetMapping("/sensors")
    List<Device> all() {
        return (List<Device>) sensorRepository.findAll();
    }
    @MessageMapping("/test/endpoints")
    @SendTo("/topic/test/subscription")
    public String test() {
        System.out.println("OK");
        return "Success";
    }
}

