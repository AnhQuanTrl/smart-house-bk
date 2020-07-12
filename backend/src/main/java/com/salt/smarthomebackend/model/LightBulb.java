package com.salt.smarthomebackend.model;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class LightBulb extends Device{
    private Integer value;
    @OneToOne(mappedBy = "lightBulb")
    private Trigger trigger;
    @OneToOne(mappedBy = "lightBulb", cascade = CascadeType.ALL)
    private Automation automation;
    @OneToOne(mappedBy = "lightBulb", cascade = CascadeType.ALL)
    @JsonIgnore
    private LightBulbHistory lightBulbHistory;
    public LightBulb(String name, Integer value) {
        super(name);
        this.value = value;
    }
}
