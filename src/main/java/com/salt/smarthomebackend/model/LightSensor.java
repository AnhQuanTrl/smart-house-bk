package com.salt.smarthomebackend.model;

//this is only for reference. Corresponding members should re-implement it

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.*;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToOne;

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
