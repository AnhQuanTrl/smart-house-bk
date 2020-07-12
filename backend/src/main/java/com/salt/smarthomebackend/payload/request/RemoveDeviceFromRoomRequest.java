package com.salt.smarthomebackend.payload.request;


import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class RemoveDeviceFromRoomRequest {
    private Long id;
    private List<Long> deviceIds;

    public RemoveDeviceFromRoomRequest(Long id, List<Long> deviceIds) {
        this.id = id;
        this.deviceIds = deviceIds;
    }
}
