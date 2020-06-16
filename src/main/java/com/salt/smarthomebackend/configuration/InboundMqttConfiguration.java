package com.salt.smarthomebackend.configuration;

import com.fasterxml.jackson.core.type.TypeReference;
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
import java.util.Optional;

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
                        "Topic/Light", "Topic/LightD");
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
            if (((String) headers.get("mqtt_receivedTopic")).equals("Topic/Light")) {
                System.out.println(message.getPayload());
                try {
                    List<Object> lst = mapper.readValue(message.getPayload().toString(), new TypeReference<List<Object>>() {
                    });
                    Map<String, Object> value = (Map<String, Object>) lst.get(0);
                    String deviceId = (String) value.get("device_id");
                    Integer lightValue = ((List<Integer>) value.get("values")).get(0);
                    Optional<LightSensor> res = lightSensorRepository.findByName(deviceId);
                    if (res.isPresent()) {
                        res.get().setLight(lightValue);
                        lightSensorRepository.save(res.get());
                        if (res.get().getClient() != null) {
                            SimpUser simpUser =
                                    simpUserRegistry.getUser(res.get().getClient().getJwt());
                            template.convertAndSendToUser(simpUser.getName(), "/topic/message",
                                    res.get());
                        }

                    } else {
                        LightSensor lightSensor = new LightSensor(deviceId, lightValue);
                        template.convertAndSend("topic/message", lightSensor);
                        lightSensorRepository.save(lightSensor);
                    }
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }
            } else {
                System.out.println(message.getPayload());
                try {
                    List<Object> lst = mapper.readValue(message.getPayload().toString(), new TypeReference<List<Object>>() {
                    });
                    Map<String, Object> value = (Map<String, Object>) lst.get(0);
                    String deviceId = (String) value.get("device_id");
                    Integer lightValue = ((List<Integer>) value.get("values")).get(0);
                    Optional<LightBulb> res = lightBulbRepository.findByName(deviceId);
                    if (res.isPresent()) {
                        res.get().setMode(lightValue != 0);
                        lightBulbRepository.save(res.get());
                        template.convertAndSend("/topic/message", res.get());
                    }
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }
            }

//                try {
//                    Map<String, Object> map = (new ObjectMapper()).readValue(message.getPayload().toString(), Map.class);
//                    if(map.containsKey("mode")){
//                        Optional<LightBulb> res = lightBulbRepository.findByName((String)map.get("id"));
//                        if(res.isPresent()){
//                            if(res.get().getMode() != (Boolean)map.get("mode")){
//                                res.get().setMode((Boolean)map.get("mode"));
//                                lightBulbRepository.save(res.get());
//                                //TODO: signal front
//                            }
//                        }
//                    }
//                    else if(map.containsKey("light")){
//                        Optional<LightSensor> res = lightSensorRepository.findByName((String)map.get("id"));
//                        if(res.isPresent()){
//                            if(res.get().getLight() != (Integer) map.get("light")){
//                                res.get().setLight((Integer)map.get("light"));
//                                lightSensorRepository.save(res.get());
//                                //TODO: signal front
//                            }
//                        }
//                    }
//                } catch (JsonProcessingException e) {
//                    e.printStackTrace();
//                }

        };
    }

}
