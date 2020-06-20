package com.salt.smarthomebackend.event;

import org.springframework.context.ApplicationEvent;

public class TriggerEvent extends ApplicationEvent {
    private Boolean mode;
    private Long lightBulbId;

    public Long getLightBulbId() {
        return lightBulbId;
    }

    public TriggerEvent(Object source, Long lightBulbId, Boolean value) {
        super(source);
        this.mode = value;
        this.lightBulbId = lightBulbId;
    }

    public Boolean getMode() {
        return mode;
    }
}
