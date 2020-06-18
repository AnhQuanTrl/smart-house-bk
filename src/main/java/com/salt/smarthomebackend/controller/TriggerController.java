package com.salt.smarthomebackend.controller;


import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.model.LightSensor;
import com.salt.smarthomebackend.model.Trigger;
import com.salt.smarthomebackend.payload.request.TriggerRequest;
import com.salt.smarthomebackend.payload.response.ApiResponse;
import com.salt.smarthomebackend.payload.response.TriggerResponse;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import com.salt.smarthomebackend.payload.request.ControlDeviceRequest;
import com.salt.smarthomebackend.repository.LightSensorRepository;
import com.salt.smarthomebackend.repository.TriggerRepository;
import com.salt.smarthomebackend.security.ClientPrincipal;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.transaction.UnexpectedRollbackException;
import org.springframework.web.bind.annotation.*;

import javax.transaction.Transactional;
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

    @GetMapping(value = "/{sensorId}")
    public List<TriggerResponse> all(@PathVariable Long sensorId,
                                     @AuthenticationPrincipal ClientPrincipal clientPrincipal) {
        Long usr_id = clientPrincipal.getId();
        List<TriggerResponse> triggerLst = new ArrayList<>();

        for (Trigger trigger : triggerRepository.findAll()) {
            if (trigger.getLightSensor().getClient() != null && trigger.getLightSensor().getClient().getId().equals(usr_id)) {
                if (trigger.getLightSensor().getId().equals(sensorId)) {
                    triggerLst.add(new TriggerResponse(trigger.getId(), trigger.getTriggerValue()
                            , trigger.getReleaseValue(), trigger.getLightBulb().getName()));
                }
            }
        }
        return triggerLst;
    }

    @PostMapping(value = "/setting")
    @Transactional
    public ResponseEntity<?> setTrigger(@RequestBody TriggerRequest triggerRequest, @AuthenticationPrincipal ClientPrincipal clientPrincipal) {
            Optional<LightBulb> device = lightBulbRepository.findByName(triggerRequest.getDeviceName());
            Optional<LightSensor> sensor = lightSensorRepository.findByName(triggerRequest.getSensorName());
            if (triggerRequest.getReleaseValue() != null && triggerRequest.getTriggerValue() != null && triggerRequest.getTriggerValue() > triggerRequest.getReleaseValue()) {
                return ResponseEntity.badRequest().body(new ApiResponse(false,
                        "trigger value cannot be larger than release value"));
            }
            if(device.isPresent() && sensor.isPresent() && device.get().getClient() != null && sensor.get().getClient() != null) {
                if (clientPrincipal.getId().equals(device.get().getClient().getId()) && clientPrincipal.getId().equals(sensor.get().getClient().getId())) {
                    Trigger trigger = new Trigger(sensor.get(),
                            triggerRequest.getTriggerValue(), triggerRequest.getReleaseValue(),
                            device.get());
                    try {
                        trigger = triggerRepository.saveAndFlush(trigger);
                        sensor.get().getTriggers().add(trigger);
                        lightSensorRepository.save(sensor.get());
                    } catch (UnexpectedRollbackException e) {
                       return ResponseEntity.badRequest().body(new ApiResponse(false, "This " +
                               "lightbulb already has trigger"));
                    }
                    return ResponseEntity.ok(trigger);
                }
            }


        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ApiResponse(false, "Lightbulb" +
                "not exist"));
    }

}
