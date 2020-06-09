package com.salt.smarthomebackend.configuration;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.salt.smarthomebackend.exception.DeviceNotFoundException;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.model.LightSensor;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import com.salt.smarthomebackend.repository.LightSensorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.core.MessageProducer;
import org.springframework.integration.mqtt.inbound.MqttPahoMessageDrivenChannelAdapter;
import org.springframework.integration.mqtt.support.DefaultPahoMessageConverter;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHandler;
import org.springframework.messaging.MessagingException;

import java.util.Map;
import java.util.Optional;

@Configuration
public class InboundMqttConfiguration {
    LightBulbRepository lightBulbRepository;
    LightSensorRepository lightSensorRepository;

    public InboundMqttConfiguration(LightBulbRepository lightBulbRepository, LightSensorRepository lightSensorRepository) {
        this.lightBulbRepository = lightBulbRepository;
        this.lightSensorRepository = lightSensorRepository;
    }

    @Bean
    public MessageChannel mqttInputChannel() {
        return new DirectChannel();
    }

    @Bean
    public MessageProducer inbound() {
        MqttPahoMessageDrivenChannelAdapter adapter =
                new MqttPahoMessageDrivenChannelAdapter("tcp://localhost:1883", "testClient",
                        "topic/iot");
        adapter.setCompletionTimeout(5000);
        adapter.setConverter(new DefaultPahoMessageConverter());
        adapter.setQos(1);
        adapter.setOutputChannel(mqttInputChannel());
        return adapter;
    }
    @Bean
    @ServiceActivator(inputChannel = "mqttInputChannel")
    public MessageHandler handler() {
        return new MessageHandler() {
            @Override
            public void handleMessage(Message<?> message) throws MessagingException {
                System.out.println(message.getPayload());
                try {
                    Map<String, Object> map = (new ObjectMapper()).readValue(message.getPayload().toString(), Map.class);
                    if(map.containsKey("mode")){
                        Optional<LightBulb> res = lightBulbRepository.findByName((String)map.get("id"));
                        if(res.isPresent()){
                            if(res.get().getMode() != (Boolean)map.get("mode")){
                                res.get().setMode((Boolean)map.get("mode"));
                                lightBulbRepository.save(res.get());
                                //TODO: signal front
                            }
                        }
                    }
                    else if(map.containsKey("light")){
                        Optional<LightSensor> res = lightSensorRepository.findByName((String)map.get("id"));
                        if(res.isPresent()){
                            if(res.get().getLight() != (Integer) map.get("light")){
                                res.get().setLight((Integer)map.get("light"));
                                lightSensorRepository.save(res.get());
                                //TODO: signal front
                            }
                        }
                    }
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }

            }

        };
    }

}
