package com.salt.smarthomebackend.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.salt.smarthomebackend.event.AutomationEvent;
import com.salt.smarthomebackend.event.TriggerEvent;
import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class TriggerService {
    private DeviceMessagePublisher deviceMessagePublisher;
    private LightBulbRepository lightBulbRepository;
    private DeviceRepository deviceRepository;
    public TriggerService(DeviceMessagePublisher deviceMessagePublisher, LightBulbRepository lightBulbRepository) {
        this.deviceMessagePublisher = deviceMessagePublisher;
        this.lightBulbRepository = lightBulbRepository;
    }

    @EventListener
    public void trigger(TriggerEvent event) {
        System.out.println("here");
        Optional<LightBulb> lightBulb = lightBulbRepository.findById(event.getLightBulbId());
        if (lightBulb.isPresent()) {
            System.out.println(lightBulb.get().getMode());
            lightBulb.get().setMode(event.getMode());
            lightBulbRepository.saveAndFlush(lightBulb.get());
        }
        try {
            deviceMessagePublisher.publishMessage(lightBulb.get(), event.getMode());
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
    }

}
