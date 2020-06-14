package com.salt.smarthomebackend.payload.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ControlDeviceRequest {
    private Long id;
    private Boolean mode;

    public ControlDeviceRequest(Long id, Boolean mode) {
        this.id = id;
        this.mode = mode;
    }
}
