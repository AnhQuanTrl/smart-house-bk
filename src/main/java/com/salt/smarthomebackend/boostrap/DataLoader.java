package com.salt.smarthomebackend.boostrap;

import com.salt.smarthomebackend.model.*;
import com.salt.smarthomebackend.repository.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalTime;

@Component
@Slf4j
public class DataLoader implements CommandLineRunner {
    private LightSensorRepository lightSensorRepository;
    private LightBulbRepository lightBulbRepository;
    private ClientRepository clientRepository;
    private RoomRepository roomRepository;
    private DeviceRepository deviceRepository;
    private AutomationRepository automationRepository;
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
        Room r1 = new Room("r1");
        roomRepository.save(r1);
        LightSensor l1 = new LightSensor("ls1", 100);
        LightSensor l2 = new LightSensor("ls2", 200);
        LightBulb lb1 = new LightBulb("lb1", false);
        lightSensorRepository.save(l1);
        lightSensorRepository.save(l2);
        lightBulbRepository.save(lb1);
        Device dev = deviceRepository.findByName("ls1");
        r1 = roomRepository.findByName("r1");
        dev.setRoom(r1);
        deviceRepository.save(dev);
        Automation a1 = new Automation(LocalTime.of(0, 30, 0), null, null);
        automationRepository.save(a1);
        lb1.setAutomation(a1);
        lightBulbRepository.save(lb1);
    }
}
