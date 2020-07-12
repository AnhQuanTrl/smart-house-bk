package com.salt.smarthomebackend.security;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.salt.smarthomebackend.model.Client;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.HashSet;

public class ClientPrincipal implements UserDetails {

    private Long id;
    private String username;
    @JsonIgnore //prevent serialization and deserialization
    private String password;

    public ClientPrincipal(Long id, String username, String password) {
        this.id = id;
        this.username = username;
        this.password = password;
    }

    public static ClientPrincipal mapFromClient(Client client) {
        return new ClientPrincipal(client.getId(), client.getUsername(), client.getPassword());
    }
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return new HashSet<GrantedAuthority>(); //empty collection as this app does not use role
    }

    public Long getId() {
        return id;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        ClientPrincipal that = (ClientPrincipal) o;

        return id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return id.hashCode();
    }
}
