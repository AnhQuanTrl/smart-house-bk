package com.salt.smarthomebackend.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import java.util.ArrayList;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@Entity
public class User extends BaseIdentity{
    private String username;
    private String password;
    @OneToMany(mappedBy = "user", cascade ={CascadeType.PERSIST, CascadeType.MERGE})
    private List<Device> devices = new ArrayList<>();
    @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<User> relatives = new ArrayList<>();
    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }
}
