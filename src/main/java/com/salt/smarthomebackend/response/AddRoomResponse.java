package com.salt.smarthomebackend.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class AddRoomResponse {
    private Long id;
    private String name;
    private String clientName;

    public AddRoomResponse(Long id, String name, String clientName) {
        this.id = id;
        this.name = name;
        this.clientName = clientName;
    }
}
