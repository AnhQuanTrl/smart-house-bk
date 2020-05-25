package com.salt.smarthomebackend.websocket;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Message {

    private MessageType type;
    private String content;

    public enum MessageType {
        LOGIN, REFRESH
    }


}