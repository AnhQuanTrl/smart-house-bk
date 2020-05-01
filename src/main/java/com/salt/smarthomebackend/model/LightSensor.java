package com.salt.smarthomebackend.model;

//this is only for reference. Corresponding members should re-implement it

import lombok.*;

import javax.persistence.Entity;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class LightSensor extends Sensor {
    private Integer light;

    public LightSensor(String name, String location, Boolean status, Integer light) {
        super(name, location, status);
        this.light = light;
    }

}
