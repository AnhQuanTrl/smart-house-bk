package com.salt.smarthomebackend.controller;


import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.model.LightSensor;
import com.salt.smarthomebackend.model.Trigger;
import com.salt.smarthomebackend.payload.request.TriggerRequest;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import com.salt.smarthomebackend.payload.request.ControlDeviceRequest;
import com.salt.smarthomebackend.repository.LightSensorRepository;
import com.salt.smarthomebackend.repository.TriggerRepository;
import com.salt.smarthomebackend.security.ClientPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/triggers")
public class TriggerController {
    private final LightSensorRepository lightSensorRepository;
    private final LightBulbRepository lightBulbRepository;
    private final TriggerRepository triggerRepository;


    public TriggerController(LightSensorRepository lightSensorRepository, LightBulbRepository lightBulbRepositor, TriggerRepository triggerRepositoryy) {
        this.lightSensorRepository = lightSensorRepository;
        this.lightBulbRepository = lightBulbRepositor;
        this.triggerRepository = triggerRepositoryy;
    }

    @PostMapping(value = "/setting")
    public ResponseEntity<?> setTrigger(@RequestBody TriggerRequest triggerRequest, @AuthenticationPrincipal ClientPrincipal clientPrincipal) {

            Optional<LightBulb> device = lightBulbRepository.findByName(triggerRequest.getDeviceName());
            Optional<LightSensor> sensor = lightSensorRepository.findByName(triggerRequest.getSensorName());
            if(device.isPresent() && sensor.isPresent()) {
                if (clientPrincipal.getId().equals(device.get().getClient().getId()) && clientPrincipal.getId().equals(sensor.get().getClient().getId())) {
                    Trigger trigger = new Trigger(sensor.get(),
                            triggerRequest.getTriggerValue(), device.get(), triggerRequest.getMode());
                    try {
                        trigger = triggerRepository.save(trigger);
                        sensor.get().getTriggers().add(trigger);
                        lightSensorRepository.save(sensor.get());
                    } catch (Exception e) {
                        System.out.println(e.getStackTrace());
                    }
                    return ResponseEntity.ok(trigger);
                }
            }


        return ResponseEntity.notFound().build();
    }

}
