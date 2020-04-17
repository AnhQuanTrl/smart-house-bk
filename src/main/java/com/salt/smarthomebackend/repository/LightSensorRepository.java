package com.salt.smarthomebackend.repository;

import com.salt.smarthomebackend.model.LightSensor;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LightSensorRepository extends JpaRepository<LightSensor, Long> {
}
