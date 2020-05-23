package com.salt.smarthomebackend.model;


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
    @OneToOne(mappedBy = "automation")
    private LightBulb lightBulb;
    public Automation(LocalTime triggerTime, LocalTime releaseTime, LightBulb lightBulb) {
        this.triggerTime = triggerTime;
        this.releaseTime = releaseTime;
        this.lightBulb = lightBulb;
    }

}
