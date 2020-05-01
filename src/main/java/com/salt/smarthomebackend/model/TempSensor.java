package com.salt.smarthomebackend.model;

import lombok.*;

import javax.persistence.Entity;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class TempSensor extends Sensor {
    private Double temperature;

    public TempSensor(String name, String location, Boolean status, Double temp) {
        super(name, location, status);
        if (status)
            this.temperature = temp;
        else
            this.temperature = 0.0;
    }
}
