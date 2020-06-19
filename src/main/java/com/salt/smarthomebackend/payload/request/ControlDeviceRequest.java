package com.salt.smarthomebackend.payload.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ControlDeviceRequest {
    private Long id;
    private Integer value;

    public ControlDeviceRequest(Long id, Integer value) {
        this.id = id;
        this.value = value;
    }
}
