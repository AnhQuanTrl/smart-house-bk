package com.salt.smarthomebackend.model;

import lombok.*;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import java.io.Serializable;

//This class serve as a base object for every other pojos in this project
@Data
@MappedSuperclass
public abstract class BaseIdentity implements Serializable {
    @Id
    @GeneratedValue
    private Long id;

}
