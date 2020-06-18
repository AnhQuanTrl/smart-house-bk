package com.salt.smarthomebackend.boostrap;

import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
import com.salt.smarthomebackend.model.*;
import com.salt.smarthomebackend.repository.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class DataLoader implements CommandLineRunner {
    private LightSensorRepository lightSensorRepository;
    private LightBulbRepository lightBulbRepository;
    private ClientRepository clientRepository;
    private RoomRepository roomRepository;
    private DeviceRepository deviceRepository;
    private AutomationRepository automationRepository;
    private DeviceMessagePublisher deviceMessagePublisher;
    @Autowired
    public void setLightSensorRepository(LightSensorRepository lightSensorRepository) {
        this.lightSensorRepository = lightSensorRepository;
    }

    @Autowired
    public void setLightBulbRepository(LightBulbRepository lightBulbRepository) {
        this.lightBulbRepository = lightBulbRepository;
    }

    @Autowired
    public void setClientRepository(ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    @Autowired
    public void setRoomRepository(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    @Autowired
    public void setDeviceRepository(DeviceRepository deviceRepository) {
        this.deviceRepository = deviceRepository;
    }

    @Autowired
    public void setAutomationRepository(AutomationRepository automationRepository) {
        this.automationRepository = automationRepository;
    }



    @Override
    public void run(String... args) throws Exception {
        LightBulb lightD = new LightBulb("LightD", false);
        lightBulbRepository.save(lightD);
        LightBulb lightD2 = new LightBulb("LightD2", false);
        lightBulbRepository.save(lightD2);
        deviceMessagePublisher.publishMessage(lightD, lightD.getMode());
    }
    @Autowired
    public void setDeviceMessagePublisher(DeviceMessagePublisher deviceMessagePublisher) {
        this.deviceMessagePublisher = deviceMessagePublisher;
    }
}
