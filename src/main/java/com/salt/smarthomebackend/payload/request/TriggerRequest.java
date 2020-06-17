package com.salt.smarthomebackend.payload.request;

import javax.persistence.criteria.CriteriaBuilder;

public class TriggerRequest {
    private String deviceName;
    private String sensorName;
    private Integer triggerValue;

    public String getDeviceName() {
        return deviceName;
    }
    public String getSensorName() {
        return sensorName;
    }
    public Integer getTriggerValue() {
        return triggerValue;
    }
}
