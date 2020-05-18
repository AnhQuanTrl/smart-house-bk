package com.salt.smarthomebackend.model;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import lombok.*;

import javax.persistence.*;


@NoArgsConstructor
@Getter
@Setter
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, property = "type")
@JsonSubTypes({
        @JsonSubTypes.Type(value=LightSensor.class, name="LS"),
        @JsonSubTypes.Type(value= LightBulb.class, name="LB")
})


public abstract class Device extends BaseIdentity {
    private String name;
    @ManyToOne(optional = true, cascade = CascadeType.PERSIST)
    private Room room;
    public Device(String name) {
        super();
        this.name = name;
    }

    @Override
    public String toString() {
        return "Sensor{" +
                "id=" + getId() +
                ", name='" + name + '\'' +
                '}';
    }


}
