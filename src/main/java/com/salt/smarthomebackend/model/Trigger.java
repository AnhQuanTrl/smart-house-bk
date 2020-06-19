package com.salt.smarthomebackend.model;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import com.salt.smarthomebackend.event.AutomationEntityListener;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@Entity
public class Trigger extends BaseIdentity {
    @ManyToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private LightSensor lightSensor;

    private Integer triggerValue;
    private Integer releaseValue;
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private LightBulb lightBulb;

    public Trigger(LightSensor lightSensor, Integer triggerValue,
                   Integer releaseValue, LightBulb lightBulb) {
        super();
        this.lightSensor = lightSensor;
        this.triggerValue = triggerValue;
        this.lightBulb = lightBulb;
        this.releaseValue = releaseValue;
    }
}
