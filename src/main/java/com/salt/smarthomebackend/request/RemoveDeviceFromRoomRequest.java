package com.salt.smarthomebackend.request;


import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class RemoveDeviceFromRoomRequest {
    private Long id;
    private List<Long> devices;

    public RemoveDeviceFromRoomRequest(Long id, List<Long> devices) {
        this.id = id;
        this.devices = devices;
    }
}
