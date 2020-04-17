package com.salt.smarthomebackend.model;

import lombok.*;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;

//This class serve as a base object for every other pojos in this project
@Data
@MappedSuperclass
public abstract class BaseIdentity  {
    @Id
    @GeneratedValue
    private Long id;
    private String name;

    public BaseIdentity(String name) {
        this.name = name;
    }
}
