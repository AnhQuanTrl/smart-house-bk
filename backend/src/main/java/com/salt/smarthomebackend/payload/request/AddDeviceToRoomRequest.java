package com.salt.smarthomebackend.payload.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class AddDeviceToRoomRequest {
    private Long id;
    private List<Long> deviceIds;

    public AddDeviceToRoomRequest(Long id, List<Long> deviceIds) {
        this.id = id;
        this.deviceIds = deviceIds;
    }
}
