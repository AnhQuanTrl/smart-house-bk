package com.salt.smarthomebackend.payload.response;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import com.salt.smarthomebackend.model.Trigger;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.CascadeType;
import javax.persistence.OneToMany;
import javax.persistence.Transient;
import java.util.ArrayList;
import java.util.List;
@Getter
@Setter
@NoArgsConstructor
public class LightSensorResponse {
    private Integer light;
    private String name;
    private Long id;
    public LightSensorResponse(Long id, String name, Integer light) {
        this.id = id;
        this.name = name;
        this.light = light;
    }
}
