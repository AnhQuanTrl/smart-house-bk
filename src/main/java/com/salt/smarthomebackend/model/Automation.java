package com.salt.smarthomebackend.model;


import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import com.salt.smarthomebackend.event.AutomationEntityListener;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.OneToOne;
import java.time.LocalTime;

@Setter
@Getter
@NoArgsConstructor
@EntityListeners(AutomationEntityListener.class)
@Entity
public class Automation extends BaseIdentity {

    //the time to turn on the device
    @Column(columnDefinition = "TIME")
    private LocalTime triggerTime;
    //the time to turn off the device
    @Column(columnDefinition = "TIME")
    private LocalTime releaseTime;
    @OneToOne(mappedBy = "automation")
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private LightBulb lightBulb;
    public Automation(LocalTime triggerTime, LocalTime releaseTime, LightBulb lightBulb) {
        this.triggerTime = triggerTime;
        this.releaseTime = releaseTime;
        this.lightBulb = lightBulb;
    }

}
