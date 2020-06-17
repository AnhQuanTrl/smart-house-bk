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

    //the triggerValue to switch the device
    @OneToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private LightBulb device;

    @Column
    private Integer triggerValue;
    @Column
    private String sensorName;

    public Trigger(LightBulb device, String sensorName, Integer triggerVal) {
        super();
        this.device = device;
        this.sensorName = sensorName;
        this.triggerValue = triggerVal;
    }


}
