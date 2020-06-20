package com.salt.smarthomebackend.model;

//this is only for reference. Corresponding members should re-implement it

import com.salt.smarthomebackend.helper.Constant;
import lombok.*;

import javax.persistence.Entity;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class LightSensor extends Device {
    private Integer light;

    public LightSensor(String name, Integer light) {
        super(name);
        this.light = light;
    }
}
