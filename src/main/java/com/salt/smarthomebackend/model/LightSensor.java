package com.salt.smarthomebackend.model;

//this is only for reference. Corresponding members should re-implement it

import lombok.*;

import javax.persistence.Entity;

@Getter
@Setter
@NoArgsConstructor
@ToString
@Entity
public class LightSensor extends BaseIdentity {
    private Integer light;

    public LightSensor(String name, Integer light) {
        super(name);
        this.light = light;
    }
}
