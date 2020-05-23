package com.salt.smarthomebackend.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToOne;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class LightBulb extends Device{
    private boolean mode;
    @OneToOne(cascade = CascadeType.ALL)

    private Automation automation = null;
    public LightBulb(String name, boolean mode) {
        super(name);
        this.mode = mode;
    }
}
