package com.salt.smarthomebackend.model;

import lombok.*;

import javax.persistence.Entity;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class HumidSensor extends Sensor {
    private Double humidity;  // percentage

    public HumidSensor(String name, String location, Boolean status, Double humid) {
        super(name, location, status);
        if (status)
            this.humidity = humid;
        else
            this.humidity = 0.0;

    }
}
