package com.salt.smarthomebackend.model;

import lombok.*;

import javax.persistence.Entity;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class TempSensor extends Sensor {
    private Float temperature;

    public TempSensor(String name, String location, Boolean status, Float temp) {
        super(name, location, status);
        this.temperature = temp;
    }
}
