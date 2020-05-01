package com.salt.smarthomebackend.model;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import lombok.*;

import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.MappedSuperclass;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, property = "type")
@JsonSubTypes({
        @JsonSubTypes.Type(value=LightSensor.class, name="LS")
})
public abstract class Sensor extends BaseIdentity {
    private String name;
    private String location; // bedroom, living room, garden, ...
    private Boolean status; // 0: off - 1 : on

    public Sensor(String _name, String _location, Boolean _status ) {
        super();
        this.name = _name;
        this.location = _location;
        this.status = _status;
    }

    @Override
    public String toString() {
        return "Sensor{" +
                "id=" + getId() +
                ", name='" + name + '\'' +
                '}';
    }

    private String getId() {
        return id.toString();
    }

}
