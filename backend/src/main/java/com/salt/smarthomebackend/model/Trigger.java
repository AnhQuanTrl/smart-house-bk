package com.salt.smarthomebackend.model;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import com.salt.smarthomebackend.event.AutomationEntityListener;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.Optional;

@Setter
@Getter
@NoArgsConstructor
@Entity
public class Trigger extends BaseIdentity {
    @ManyToOne(optional = false)
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private LightSensor lightSensor;

    private boolean isInit = true;
    @NotNull
    private Integer triggerValue;
    @NotNull
    private Integer releaseValue;
    @OneToOne(optional = false)
    @JoinColumn(unique = true)
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
