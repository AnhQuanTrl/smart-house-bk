package com.salt.smarthomebackend.websocket;

import com.salt.smarthomebackend.model.LightBulb;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

@Controller
public class WebSocketController {

	@MessageMapping("/switch.lightSwitch")
	@SendTo("/topic/deviceInfo")
	public LightBulb switchLight(@Payload LightBulb light) {
		return light;
	}



}
