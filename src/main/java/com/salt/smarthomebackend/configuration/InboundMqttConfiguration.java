package com.salt.smarthomebackend.configuration;

import com.fasterxml.jackson.core.type.TypeReference;
import com.salt.smarthomebackend.event.TriggerEvent;
import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
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
    DeviceMessagePublisher publisher;
    @Autowired
    private SimpUserRegistry simpUserRegistry;
    public InboundMqttConfiguration(DeviceMessagePublisher publisher, LightBulbRepository lightBulbRepository, LightSensorRepository lightSensorRepository, SimpMessagingTemplate template, MqttPahoClientFactory mqttClientFactory) {
        this.lightBulbRepository = lightBulbRepository;
        this.lightSensorRepository = lightSensorRepository;
        this.template = template;
        this.mqttClientFactory = mqttClientFactory;
        this.publisher = publisher;
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
                                if (trigger.getTriggerValue() >=  ls .getLight() && !(trigger.getTriggerValue() >=  ls.getPreviousLight())) {
                                    Optional<LightBulb> lightBulb =
                                            lightBulbRepository.findById(trigger.getLightBulb().getId());
                                    if (lightBulb.isPresent()) {
                                        lightBulb.get().setValue(255);
                                        lightBulbRepository.save(lightBulb.get());
                                        publisher.publishMessage(lightBulb.get(), 255);
                                    }
                                }
                                else if (trigger.getReleaseValue() <=  ls.getLight() && !(trigger.getReleaseValue() <=  ls.getPreviousLight())) {
                                        Optional<LightBulb> lightBulb =
                                                lightBulbRepository.findById(trigger.getLightBulb().getId());
                                        if (lightBulb.isPresent()) {
                                            lightBulb.get().setValue(0);
                                            lightBulbRepository.save(lightBulb.get());
                                            publisher.publishMessage(lightBulb.get(), 0);

                                        }
                                    }
                                else if (trigger.getTriggerValue() <= ls.getLight() && ls.getLight() <= trigger.getReleaseValue()){
                                    Optional<LightBulb> lightBulb =
                                            lightBulbRepository.findById(trigger.getLightBulb().getId());
                                    if (lightBulb.isPresent()) {;
                                        Integer value =
                                                (int) ((trigger.getReleaseValue().doubleValue() - ls.getLight()) / (trigger.getReleaseValue() - trigger.getTriggerValue()) * 255);
                                        lightBulb.get().setValue(value);
                                        lightBulbRepository.save(lightBulb.get());
                                        publisher.publishMessage(lightBulb.get(), value);

                                    }
                                }


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
