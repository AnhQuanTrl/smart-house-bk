package com.salt.smarthomebackend.event;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.salt.smarthomebackend.helper.AutowireHelper;
import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.model.LightSensor;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationEventPublisher;

import javax.persistence.PostUpdate;
import javax.persistence.PreUpdate;
import java.util.Optional;

public class CheckTriggerListener {
    @Autowired
    private ApplicationEventPublisher publisher;
    @PreUpdate
    void checkTrigger(LightSensor lightSensor) {
        AutowireHelper.autowire(this, this.publisher);
        if (!lightSensor.getLight().equals(lightSensor.getPreviousLight())) {
            lightSensor.getTriggers().forEach(trigger -> {
                    if (trigger.getTriggerValue() != null) {
                        if (trigger.getTriggerValue() >= lightSensor.getLight() && !(trigger.getTriggerValue() >= lightSensor.getPreviousLight())) {
                            publisher.publishEvent(new TriggerEvent(lightSensor,
                                    trigger.getLightBulb().getId(), true));
                        }
                    }
                    if (trigger.getReleaseValue() != null) {
                        if (trigger.getReleaseValue() <= lightSensor.getLight() && !(trigger.getReleaseValue() <= lightSensor.getPreviousLight())) {
                            publisher.publishEvent(new TriggerEvent(lightSensor, trigger.getLightBulb().getId(), false));
                        }
                    }
            });
        }
    }
}
