package com.salt.smarthomebackend.model;

import com.fasterxml.jackson.annotation.*;
import lombok.*;

import javax.persistence.*;


@NoArgsConstructor
@Getter
@Setter
@ToString
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, property = "type")
@JsonSubTypes({
        @JsonSubTypes.Type(value=LightSensor.class, name="LS"),
        @JsonSubTypes.Type(value= LightBulb.class, name="LB")
})
public abstract class Device extends BaseIdentity {
    @Column(unique = true, nullable = false)
    private String name;

    @Column(nullable = false)
    private Boolean status;
    @ManyToOne(optional = true, cascade = CascadeType.MERGE)
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private Room room;
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    @ManyToOne(optional = true, cascade = CascadeType.MERGE)
    private Client client;
    
    public Device(String name) {
        super();
        this.name = name;
        this.status = false;
    }
}
