package com.salt.smarthomebackend.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToOne;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class LightBulb extends Device{
    private Boolean mode;
    @OneToOne(mappedBy = "lightBulb", cascade = CascadeType.ALL)
    private Automation automation;
    public LightBulb(String name, Boolean mode) {
        super(name);
        this.mode = mode;
    }


}
