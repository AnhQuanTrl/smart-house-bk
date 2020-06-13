package com.salt.smarthomebackend.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class AddControllerRequest {
    private Long roomId;
    private List<String> controllerNames;

    public AddControllerRequest(Long roomId, String ownerName, List<String> controllerNames) {
        this.roomId = roomId;
        this.controllerNames = controllerNames;
    }
}
