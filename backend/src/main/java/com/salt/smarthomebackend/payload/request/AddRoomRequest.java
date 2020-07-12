package com.salt.smarthomebackend.payload.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class AddRoomRequest {
    private String name;

    public AddRoomRequest(String name) {
        this.name = name;
    }
}
