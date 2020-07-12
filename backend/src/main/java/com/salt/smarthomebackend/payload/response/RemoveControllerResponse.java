package com.salt.smarthomebackend.payload.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class RemoveControllerResponse {
    private Long roomId;
    private String ownerName;
    private List<String> controllerNames;

    public RemoveControllerResponse(Long roomId, String ownerName){
        this.roomId = roomId;
        this.ownerName = ownerName;
        this.controllerNames = new ArrayList<>();
    }

    public void addControllerName(String controllerName){
        this.controllerNames.add(controllerName);
    }
}
