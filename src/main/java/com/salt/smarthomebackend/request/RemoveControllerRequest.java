package com.salt.smarthomebackend.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class RemoveControllerRequest {
    private Long roomId;
    private String ownerName;
    private List<String> ControllerNames;

    public RemoveControllerRequest(Long roomId, String ownerName, List<String> controllerNames) {
        this.roomId = roomId;
        this.ownerName = ownerName;
        ControllerNames = controllerNames;
    }
}
