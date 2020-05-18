package com.salt.smarthomebackend.repository;

import com.salt.smarthomebackend.model.Device;
import org.springframework.data.jpa.repository.JpaRepository;


public interface DeviceRepository extends JpaRepository<Device, Long> {
    Device findByName(String name);
}