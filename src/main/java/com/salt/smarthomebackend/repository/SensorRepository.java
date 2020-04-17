package com.salt.smarthomebackend.repository;

import com.salt.smarthomebackend.model.Sensor;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SensorRepository extends JpaRepository<Sensor, Long> {
    Sensor findByName(String name);
}
