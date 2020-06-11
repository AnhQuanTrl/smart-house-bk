package com.salt.smarthomebackend.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class AddControllerResponse {
    private Long roomId;
    private String ownerName;
    private List<String> controllerNames;

    public AddControllerResponse(Long roomId, String ownerName){
        this.roomId = roomId;
        this.ownerName = ownerName;
        this.controllerNames = new ArrayList<>();
    }

    public void addControllerName(String controllerName){
        this.controllerNames.add(controllerName);
    }
}
