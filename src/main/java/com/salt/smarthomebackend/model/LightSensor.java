package com.salt.smarthomebackend.model;

//this is only for reference. Corresponding members should re-implement it

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import com.salt.smarthomebackend.event.CheckTriggerListener;
import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@EntityListeners(CheckTriggerListener.class)
public class LightSensor extends Device {

    private Integer light;
    @OneToMany(mappedBy = "lightSensor", cascade = CascadeType.ALL)
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private List<Trigger> triggers = new ArrayList<>();
    @Transient Integer previousLight;
    public LightSensor(String name, Integer light) {
        super(name);
        this.light = light;
    }
    @PostLoad
    void initPrev() {
        previousLight = light;
    }


}
