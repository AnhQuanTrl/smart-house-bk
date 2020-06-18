package com.salt.smarthomebackend.event;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.salt.smarthomebackend.helper.AutowireHelper;
import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
import com.salt.smarthomebackend.model.LightSensor;
import org.springframework.beans.factory.annotation.Autowired;
import javax.persistence.PostUpdate;

public class CheckTriggerListener {
    @Autowired
    private DeviceMessagePublisher publisher;
    @PostUpdate
    void checkTrigger(LightSensor lightSensor) {
        AutowireHelper.autowire(this, this.publisher);
        if (!lightSensor.getLight().equals(lightSensor.getPreviousLight())) {
            lightSensor.getTriggers().forEach(trigger -> {
                try {
                    if (trigger.getTriggerValue() != null) {
                        if (trigger.getTriggerValue() >= lightSensor.getLight() && !(trigger.getTriggerValue() >= lightSensor.getPreviousLight())) {
                            publisher.publishMessage(trigger.getLightBulb(), true);
                        }
                    }
                    if (trigger.getReleaseValue() != null) {
                        if (trigger.getReleaseValue() <= lightSensor.getLight() && !(trigger.getReleaseValue() <= lightSensor.getPreviousLight())) {
                            publisher.publishMessage(trigger.getLightBulb(), false);
                        }
                    }
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }
            });
        }
    }
}
