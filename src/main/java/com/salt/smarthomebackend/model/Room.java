package com.salt.smarthomebackend.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import java.util.List;

@NoArgsConstructor
@Getter
@Setter
@Entity
public class Room extends BaseIdentity{
    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL)
    private List<Device> devices;

    public Room(List<Device> devices) {
        this.devices = devices;
    }
}
