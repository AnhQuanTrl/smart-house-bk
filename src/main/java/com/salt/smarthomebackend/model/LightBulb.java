package com.salt.smarthomebackend.model;

public class LightBulb extends Device{
    private boolean mode;

    public LightBulb(String name, boolean mode) {
        super(name);
        this.mode = mode;
    }
}
