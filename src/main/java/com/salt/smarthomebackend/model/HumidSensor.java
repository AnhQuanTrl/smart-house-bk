package com.salt.smarthomebackend.model;

import lombok.*;

import javax.persistence.Entity;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class HumidSensor extends Sensor {
    private Float humidity;  // percentage

    public HumidSensor(String name, String location, Boolean status, Float humid) {
        super(name, location, status);
        this.humidity = humid;
    }
}
