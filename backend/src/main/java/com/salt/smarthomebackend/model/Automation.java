package com.salt.smarthomebackend.model;


import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import com.salt.smarthomebackend.event.AutomationEntityListener;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;

import javax.persistence.*;
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
    @OneToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private LightBulb lightBulb;
    public Automation(LocalTime triggerTime, LocalTime releaseTime) {
        this.triggerTime = triggerTime;
        this.releaseTime = releaseTime;
    }
    @JsonProperty("lightBulbId")
    public void createLightBulb(Long id) {
        System.out.println(id);
        lightBulb = new LightBulb();
        lightBulb.setId(id);
    }

}
