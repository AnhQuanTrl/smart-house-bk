package com.salt.smarthomebackend.boostrap;

import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
import com.salt.smarthomebackend.model.*;
import com.salt.smarthomebackend.repository.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import javax.transaction.Transactional;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Map;
import java.util.Optional;

@Component
@Slf4j
public class DataLoader implements CommandLineRunner {
    private LightSensorRepository lightSensorRepository;
    private LightBulbRepository lightBulbRepository;
    private LightBulbHistoryRepository lightBulbHistoryRepository;
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

    @Autowired
    public void setLightBulbHistoryRepository(
            LightBulbHistoryRepository lightBulbHistoryRepository) {
        this.lightBulbHistoryRepository = lightBulbHistoryRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        Optional<LightBulb> optionalLightBulb = lightBulbRepository.findByName("LightD");
        LightBulb lightD;
        if (optionalLightBulb.isPresent()) {
            lightD = optionalLightBulb.get();
            lightD.setValue(0);
        }
        else {
            lightD = new LightBulb("LightD", 0);
            LightBulbHistory lightBulbHistory = new LightBulbHistory();
            lightD.setLightBulbHistory(lightBulbHistory);
        }
        Map<Timestamp, Integer> timestampIntegerMap =  lightD.getLightBulbHistory().getEntries();
        timestampIntegerMap.put(new Timestamp(new Date().getTime()), 0);
        lightD.getLightBulbHistory().setLightBulb(lightD);
        lightBulbRepository.save(lightD);
        deviceMessagePublisher.publishMessage(lightD);
    }
    @Autowired
    public void setDeviceMessagePublisher(DeviceMessagePublisher deviceMessagePublisher) {
        this.deviceMessagePublisher = deviceMessagePublisher;
    }
}
