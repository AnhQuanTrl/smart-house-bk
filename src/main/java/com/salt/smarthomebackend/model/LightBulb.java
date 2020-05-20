package com.salt.smarthomebackend.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Entity;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class LightBulb extends Device{
    private boolean mode;

    public LightBulb(String name, boolean mode) {
        super(name);
        this.mode = mode;
    }
}
