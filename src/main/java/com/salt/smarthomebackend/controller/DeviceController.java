package com.salt.smarthomebackend.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.salt.smarthomebackend.messaging.DeviceMessagePublisher;
import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import com.salt.smarthomebackend.request.ControlDeviceRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/devices")
public class DeviceController {
    private DeviceRepository deviceRepository;
    private LightBulbRepository lightBulbRepository;
    private DeviceMessagePublisher deviceMessagePublisher;

    public DeviceController(DeviceRepository deviceRepository, LightBulbRepository lightBulbRepository, DeviceMessagePublisher deviceMessagePublisher) {
        this.deviceRepository = deviceRepository;
        this.lightBulbRepository = lightBulbRepository;
        this.deviceMessagePublisher = deviceMessagePublisher;
    }

    @GetMapping(value = "/")
    public List<Device> all() {
        return deviceRepository.findAll();
    }

    @PostMapping(value = "/control")
    public ResponseEntity<Map<String, Object>> controlLightBulb(@RequestBody ControlDeviceRequest request){
        try{
            Optional<LightBulb> res = lightBulbRepository.findById(request.getId());
            Map<String, Object> response = new HashMap<>();
            if(res.isPresent()){
                if (request.getMode() == true) {
                    try {
                        deviceMessagePublisher.publishMessage(res.get().getName(), true);
                    } catch (JsonProcessingException e) {
                        e.printStackTrace();
                    }
                    response.put("id", res.get().getId());
                    response.put("mode", true);
                } else {
                    try {
                        deviceMessagePublisher.publishMessage(res.get().getName(), false);
                    } catch (JsonProcessingException e) {
                        e.printStackTrace();
                    }
                    response.put("id", res.get().getId());
                    response.put("mode", false);
                }
                return ResponseEntity.ok(response);
            }
            else{
                return ResponseEntity.notFound().build();
            }
        }
        catch(IllegalArgumentException e){
            return ResponseEntity.badRequest().build();
        }
    }
}
