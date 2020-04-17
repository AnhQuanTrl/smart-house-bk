package com.salt.smarthomebackend.boostrap;

import com.salt.smarthomebackend.model.LightSensor;
import com.salt.smarthomebackend.repository.LightSensorRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;

@Configuration
@Slf4j
public class DataLoader implements CommandLineRunner {
    LightSensorRepository lightSensorRepository;

    public DataLoader(LightSensorRepository lightSensorRepository) {
        this.lightSensorRepository = lightSensorRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        LightSensor l1 = new LightSensor("LS1", 0);
        LightSensor l2 = new LightSensor("LS2", 50);
        lightSensorRepository.save(l1);
        lightSensorRepository.save(l2);
    }
}
