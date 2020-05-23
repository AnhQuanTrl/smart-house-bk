package com.salt.smarthomebackend.event;

import org.springframework.context.ApplicationEvent;


public class AutomationEvent extends ApplicationEvent {
    public enum Command {
        ADD,
        REMOVE
    }
    private Command command;
    public AutomationEvent(Object source, Command command) {
        super(source);
        this.command = command;
    }

    public Command getCommand() {
        return command;
    }
}
