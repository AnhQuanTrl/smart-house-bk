package com.salt.smarthomebackend.payload.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class TriggerRequest {
    private String deviceName;
    private String sensorName;
    private Integer triggerValue;
    private Boolean mode;

    public TriggerRequest(String deviceName, String sensorName, Integer triggerValue, Boolean mode) {
        this.deviceName = deviceName;
        this.sensorName = sensorName;
        this.triggerValue = triggerValue;
        this.mode = mode;
    }
}
