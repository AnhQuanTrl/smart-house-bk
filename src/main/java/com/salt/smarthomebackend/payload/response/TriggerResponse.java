package com.salt.smarthomebackend.payload.response;

import com.salt.smarthomebackend.model.LightSensor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class TriggerResponse {
    private Long id;
    private Integer triggerValue;
    private Integer releaseValue;
    private String lightBulbName;

    public TriggerResponse(Long id, Integer triggerValue, Integer releaseValue,
                           String lightBulbName) {
        this.id = id;
        this.triggerValue = triggerValue;
        this.releaseValue = releaseValue;
        this.lightBulbName = lightBulbName;
    }
}
