package com.salt.smarthomebackend.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.ArrayList;

@Setter
@Getter
@NoArgsConstructor
public class AddDeviceToRoomResponse {
    private Long id;
    private ArrayList<Long> devices;

    public AddDeviceToRoomResponse(Long id) {
        this.id = id;
        devices = new ArrayList<Long>();
    }

    public void addDevice(Long id){
        devices.add(id);
    }
}
