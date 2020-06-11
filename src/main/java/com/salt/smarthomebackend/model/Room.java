package com.salt.smarthomebackend.model;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@Getter
@Setter
@Entity
public class Room extends BaseIdentity{

    @OneToMany(mappedBy = "room")
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private List<Device> devices = new ArrayList<>();
    private String name;

    @ManyToOne(optional = true, cascade = CascadeType.MERGE)
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private Client client;

    @ManyToMany
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private List<Client> controllers = new ArrayList<Client>();

    public Room(String name, Client client) {
        this.name = name;
        this.client = client;
        this.controllers.add(client);
    }

    public Boolean addController(Client client){
        if(!controllers.contains(client)){
            controllers.add(client);
            return true;
        }
        return false;
    }

    @PreRemove
    private void preRemove() {
        devices.forEach(device -> device.setRoom(null));
    }
}
