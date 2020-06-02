package com.salt.smarthomebackend.exception;

public class RoomNotFoundException extends RuntimeException {
    public RoomNotFoundException(Long id) {
        super("Could not find device " + id);
    }
}
