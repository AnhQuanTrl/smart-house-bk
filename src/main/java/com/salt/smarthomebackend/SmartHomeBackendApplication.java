package com.salt.smarthomebackend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class SmartHomeBackendApplication {

	public static void main(String[] args) {

		ConfigurableApplicationContext context =
				SpringApplication.run(SmartHomeBackendApplication.class,
				args);
//		MessageGateway messageGateway = context.getBean(MessageGateway.class);
//		Map<String, Object> test = new HashMap<>();
//		test.put("id", 3);
//		test.put("mode", true);
//		try {
//			messageGateway.sendToMqtt(new ObjectMapper().writeValueAsString(test));
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
	}
}
