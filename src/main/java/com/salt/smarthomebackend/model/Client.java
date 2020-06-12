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

@Setter
@Getter
@NoArgsConstructor
@Entity
public class Client extends BaseIdentity{
    @Column(unique = true)
    private String username;
    private String password;
    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    private List<Device> devices = new ArrayList<>();

    @OneToMany(mappedBy = "client")
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private List<Room> rooms = new ArrayList<>();

    @ManyToMany(mappedBy = "controllers")
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class,
            property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private List<Room> controlledRooms = new ArrayList<>();

    public Client(String username, String password) {
        this.username = username;
        this.password = password;
    }
}
