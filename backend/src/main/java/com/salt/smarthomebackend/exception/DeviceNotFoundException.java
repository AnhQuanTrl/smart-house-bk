package com.salt.smarthomebackend.exception;

public class DeviceNotFoundException extends RuntimeException {
    public DeviceNotFoundException(Long id) {
        super("Could not find device " + id);
    }
    public DeviceNotFoundException(String name) {
        super("Could not find device " + name);
    }

}