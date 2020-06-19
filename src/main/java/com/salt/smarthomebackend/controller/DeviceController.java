package com.salt.smarthomebackend.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import com.salt.smarthomebackend.payload.request.ControlDeviceRequest;
import com.salt.smarthomebackend.security.ClientPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.user.SimpUser;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.*;

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
    public List<Device> all(@AuthenticationPrincipal ClientPrincipal clientPrincipal) {
        Long usr_id = clientPrincipal.getId();
        List<Device> deviceLst = new ArrayList<>();

        for (Device d : deviceRepository.findAll()) {
            if (d.getClient() != null) {
                if (d.getClient().getId().equals(usr_id)) {
                    deviceLst.add(d);
                }
            }
        }

        return deviceLst;
    }

    @PostMapping(value = "/control")
    public ResponseEntity<Map<String, Object>> controlLightBulb(@RequestBody ControlDeviceRequest request){
        try{
            Optional<LightBulb> res = lightBulbRepository.findById(request.getId());
            Map<String, Object> response = new HashMap<>();
            if(res.isPresent()){
                try {
                    deviceMessagePublisher.publishMessage(res.get(), request.getValue());
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }
                res.get().setValue(request.getValue());
                lightBulbRepository.save(res.get());
                response.put("id", res.get().getId());
                response.put("value", request.getValue());
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
