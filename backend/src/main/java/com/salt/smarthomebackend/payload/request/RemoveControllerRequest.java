package com.salt.smarthomebackend.payload.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class RemoveControllerRequest {
    private Long roomId;
    private List<String> controllerNames;

    public RemoveControllerRequest(Long roomId, List<String> controllerNames) {
        this.roomId = roomId;
        this.controllerNames = controllerNames;
    }
}
