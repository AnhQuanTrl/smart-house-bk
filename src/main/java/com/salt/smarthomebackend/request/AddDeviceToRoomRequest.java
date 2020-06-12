package com.salt.smarthomebackend.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class AddDeviceToRoomRequest {
    private Long id;
    private List<Long> devices;

    public AddDeviceToRoomRequest(Long id, List<Long> devices) {
        this.id = id;
        this.devices = devices;
    }
}
