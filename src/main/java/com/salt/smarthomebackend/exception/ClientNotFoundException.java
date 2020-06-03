package com.salt.smarthomebackend.exception;

public class ClientNotFoundException extends RuntimeException {
    public ClientNotFoundException(Long id) {
        super("Could not find device " + id);
    }
}