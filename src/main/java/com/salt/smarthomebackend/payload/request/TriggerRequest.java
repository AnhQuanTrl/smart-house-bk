package com.salt.smarthomebackend.payload.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class TriggerRequest {
    private String deviceName;
    private String sensorName;
    private Integer triggerValue;
    private Integer releaseValue;
    public TriggerRequest(String deviceName, String sensorName, Integer triggerValue, Integer releaseValue) {
        this.deviceName = deviceName;
        this.sensorName = sensorName;
        this.triggerValue = triggerValue;
        this.releaseValue = releaseValue;
    }
}
