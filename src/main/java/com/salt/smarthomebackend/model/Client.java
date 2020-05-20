package com.salt.smarthomebackend.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@Entity
public class Client extends BaseIdentity{
    private String username;
    private String password;
    @OneToMany(mappedBy = "client")
    private List<Device> devices = new ArrayList<>();
    @OneToMany
    private List<Client> relatives = new ArrayList<>();
    public Client(String username, String password) {
        this.username = username;
        this.password = password;
    }
}
