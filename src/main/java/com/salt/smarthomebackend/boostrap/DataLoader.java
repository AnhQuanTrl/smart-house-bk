package com.salt.smarthomebackend.boostrap;

import com.salt.smarthomebackend.model.LightSensor;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import com.salt.smarthomebackend.repository.LightSensorRepository;
import com.salt.smarthomebackend.repository.RoomRepository;
import com.salt.smarthomebackend.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class DataLoader implements CommandLineRunner {
    private LightSensorRepository lightSensorRepository;
    private LightBulbRepository lightBulbRepository;
    private UserRepository userRepository;
    private RoomRepository roomRepository;

    @Autowired
    public LightSensorRepository getLightSensorRepository() {
        return lightSensorRepository;
    }

    @Autowired
    public LightBulbRepository getLightBulbRepository() {
        return lightBulbRepository;
    }

    @Autowired
    public UserRepository getUserRepository() {
        return userRepository;
    }

    @Autowired
    public RoomRepository getRoomRepository() {
        return roomRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        LightSensor l1 = new LightSensor("ls1", 100);
        LightSensor l2 = new LightSensor("ls2", 200);
        lightSensorRepository.save(l1);
        lightSensorRepository.save(l2);
    }
}
