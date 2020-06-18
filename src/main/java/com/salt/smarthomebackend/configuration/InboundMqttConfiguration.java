package com.salt.smarthomebackend.configuration;

import com.fasterxml.jackson.core.type.TypeReference;
import com.salt.smarthomebackend.payload.response.LightSensorResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.model.LightSensor;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import com.salt.smarthomebackend.repository.LightSensorRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.core.MessageProducer;
import org.springframework.integration.mqtt.core.MqttPahoClientFactory;
import org.springframework.integration.mqtt.inbound.MqttPahoMessageDrivenChannelAdapter;
import org.springframework.integration.mqtt.support.DefaultPahoMessageConverter;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHandler;
import org.springframework.messaging.MessagingException;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.user.SimpUser;
import org.springframework.messaging.simp.user.SimpUserRegistry;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketSession;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Configuration
public class InboundMqttConfiguration {
    @Value("${app.mqtt.input}")
    private String input;
    LightBulbRepository lightBulbRepository;
    LightSensorRepository lightSensorRepository;
    SimpMessagingTemplate template;
    @Autowired
    private SimpUserRegistry simpUserRegistry;
    public InboundMqttConfiguration(LightBulbRepository lightBulbRepository, LightSensorRepository lightSensorRepository, SimpMessagingTemplate template, MqttPahoClientFactory mqttClientFactory) {
        this.lightBulbRepository = lightBulbRepository;
        this.lightSensorRepository = lightSensorRepository;
        this.template = template;
        this.mqttClientFactory = mqttClientFactory;
    }

    @Bean
    public MessageChannel mqttInputChannel() {
        return new DirectChannel();
    }
    MqttPahoClientFactory mqttClientFactory;
    @Bean
    public MessageProducer inbound() {
        MqttPahoMessageDrivenChannelAdapter adapter =
                new MqttPahoMessageDrivenChannelAdapter("testClient", mqttClientFactory,
                        "Topic/Light");
        adapter.setCompletionTimeout(5000);
        adapter.setConverter(new DefaultPahoMessageConverter());
        adapter.setQos(1);
        adapter.setOutputChannel(mqttInputChannel());
        return adapter;
    }
    @Bean
    @ServiceActivator(inputChannel = "mqttInputChannel")
    public MessageHandler handler() {
        return message -> {
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> headers = message.getHeaders();
            if (Objects.equals((String) headers.get("mqtt_receivedTopic"), "Topic/Light")) {
                System.out.println(message.getPayload());
                try {
                    List<Object> lst = mapper.readValue(message.getPayload().toString(), new TypeReference<List<Object>>() {
                    });
                    lst.stream().map(element -> {
                        Map<String, Object> value = (Map<String, Object>) element;
                        String deviceId = (String) value.get("device_id");
                        Integer lightValue = ((List<Integer>) value.get("values")).get(0);
                        Optional<LightSensor> res = lightSensorRepository.findByName(deviceId);
                        if (res.isPresent()) {
                            res.get().setLight(lightValue);
                            lightSensorRepository.save(res.get());
                            return res.get();
                        } else {
                            LightSensor lightSensor = new LightSensor(deviceId, lightValue);
                            lightSensorRepository.save(lightSensor);
                            return lightSensor;
                        }
                    }).collect(Collectors.toList()).forEach(element -> {
                        if (element.getClient() != null) {
                            SimpUser simpUser =
                                    simpUserRegistry.getUser(element.getClient().getJwt());
                            if (simpUser != null) {
                                template.convertAndSendToUser(simpUser.getName(), "/topic/message",
                                        new LightSensorResponse(element.getId(),
                                                element.getName(), element.getLight()));
                            }
                        }
                    });
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }
            }

        };
    }

}
