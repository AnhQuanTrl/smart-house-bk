package com.salt.smarthomebackend.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;

@Getter
@Setter
@NoArgsConstructor
public class RemoveDeviceFromRoomResponse {
    private Long id;
    private ArrayList<Long> devices;

    public RemoveDeviceFromRoomResponse(Long id) {
        this.id = id;
        this.devices = new ArrayList<Long>();
    }

    public void addDevice(Long id){
        devices.add(id);
    }
}
