package com.salt.smarthomebackend.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

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
