package com.salt.smarthomebackend.configuration;

import com.fasterxml.jackson.core.type.TypeReference;
import com.salt.smarthomebackend.event.TriggerEvent;
import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
import com.salt.smarthomebackend.payload.response.LightSensorResponse;
import com.salt.smarthomebackend.repository.TriggerRepository;
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

import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

@Configuration
public class InboundMqttConfiguration {
    @Value("${app.mqtt.input}")
    private String input;
    LightBulbRepository lightBulbRepository;
    LightSensorRepository lightSensorRepository;
    TriggerRepository triggerRepository;
    SimpMessagingTemplate template;
    @Autowired
    DeviceMessagePublisher publisher;
    @Autowired
    private SimpUserRegistry simpUserRegistry;
    public InboundMqttConfiguration(LightBulbRepository lightBulbRepository,
                                    LightSensorRepository lightSensorRepository,
                                    SimpMessagingTemplate template, MqttPahoClientFactory mqttClientFactory, TriggerRepository triggerRepository) {
        this.lightBulbRepository = lightBulbRepository;
        this.lightSensorRepository = lightSensorRepository;
        this.triggerRepository = triggerRepository;
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
                System.out.println(message.getPayload());
                try {
                    List<Object> lst = mapper.readValue(message.getPayload().toString(), new TypeReference<List<Object>>() {
                    });
                    lst.stream().map(element -> {
                        Map<String, Object> value = (Map<String, Object>) element;
                        String deviceId = (String) value.get("device_id");
                        Integer lightValue =
                                Integer.parseInt(((List<String>) value.get("values")).get(0));
                        Optional<LightSensor> res = lightSensorRepository.findByName(deviceId);
                        if (res.isPresent()) {
                            res.get().setPreviousLight(res.get().getLight());
                            res.get().setLight(lightValue);
//                            if (res.get().getRoom() != null && res.get().getRoom().getAutomatic()){
//                                Boolean mode = res.get().getLight() < Constant.NIGHT_THRESHOLD ? true : false;
//                                for(Device device:res.get().getRoom().getDevices()){
//                                    if(device instanceof LightBulb){
//                                        ((LightBulb) device).setMode(mode);
//                                        lightBulbRepository.save((LightBulb)device);
//                                        try {
//                                            publisher.publishMessage(device.getName(), ((LightBulb)device).getMode());
//                                        } catch (JsonProcessingException e) {
//                                            e.printStackTrace();
//                                        }
//                                    }
//                                }
//                            }
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
                        LightSensor ls = lightSensorRepository.findById(element.getId()).get();
                        if ( ls.getTriggers() == null) {
                            return;
                        }
                        ls.getTriggers().forEach(trigger -> {
                            try {
                                Optional<LightBulb> lightBulb =
                                        lightBulbRepository.findById(trigger.getLightBulb().getId());
                                if (!lightBulb.isPresent()) {
                                    return;
                                }
                                Integer value = null;
                                if (trigger.isInit()) {
                                    if (trigger.getTriggerValue() >=  ls .getLight()) {
                                        value = 255;
                                    } else if (trigger.getTriggerValue() <=  ls .getLight()) {
                                        value = 0;
                                    } else {
                                        value = (int) ((trigger.getReleaseValue().doubleValue() - ls.getLight()) / (trigger.getReleaseValue() - trigger.getTriggerValue()) * 255);
                                    }
                                    lightBulb.get().setValue(value);
                                    trigger.setInit(false);
                                    triggerRepository.save(trigger);
                                }
                                else if (trigger.getTriggerValue() >=  ls .getLight() && !(trigger.getTriggerValue() >=  ls.getPreviousLight())) {
                                    value = 255;
                                }
                                else if (trigger.getReleaseValue() <=  ls.getLight() && !(trigger.getReleaseValue() <=  ls.getPreviousLight())) {
                                    value = 0;
                                }
                                else if (trigger.getTriggerValue() <= ls.getLight() && ls.getLight() <= trigger.getReleaseValue()){
                                    value =
                                            (int) ((trigger.getReleaseValue().doubleValue() - ls.getLight()) / (trigger.getReleaseValue() - trigger.getTriggerValue()) * 255);
                                }
                                if (value != null) {
                                    lightBulb.get().setValue(value);
                                    lightBulb.get().getLightBulbHistory().getEntries().put(new Timestamp(new Date().getTime()), value);
                                }
                                lightBulbRepository.save(lightBulb.get());
                                publisher.publishMessage(lightBulb.get());
                            } catch (JsonProcessingException e) {
                                e.printStackTrace();
                            }
                        });

                    });
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }
        };
    }

}
