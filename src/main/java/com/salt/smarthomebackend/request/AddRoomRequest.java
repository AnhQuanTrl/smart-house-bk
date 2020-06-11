package com.salt.smarthomebackend.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class AddRoomRequest {
    private String name;
    private String clientName;

    public AddRoomRequest(String name, String clientName) {
        this.name = name;
        this.clientName = clientName;
    }
}
