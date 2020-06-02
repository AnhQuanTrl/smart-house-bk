package com.salt.smarthomebackend.Exception;

public class ClientNotFoundException extends RuntimeException {
    public ClientNotFoundException(Long id) {
        super("Could not find device " + id);
    }
}