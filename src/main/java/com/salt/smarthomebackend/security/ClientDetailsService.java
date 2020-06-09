package com.salt.smarthomebackend.security;

import com.salt.smarthomebackend.model.Client;
import com.salt.smarthomebackend.repository.ClientRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
public class ClientDetailsService implements UserDetailsService {
    ClientRepository clientRepository;

    public ClientDetailsService(ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {
        Client client =
                clientRepository.findByUsername(s).orElseThrow(() -> new UsernameNotFoundException(
                        "User not found  with username: " + s));
        return ClientPrincipal.mapFromClient(client);
    }

    @Transactional
    public UserDetails loadClientById(Long id) {
        Client user = clientRepository.findById(id).orElseThrow(
                () -> new UsernameNotFoundException("User not found with id : " + id)
        );

        return ClientPrincipal.mapFromClient(user);
    }
}
