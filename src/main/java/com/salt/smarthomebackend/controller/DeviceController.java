package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.repository.DeviceRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/devices")
public class DeviceController {
    private DeviceRepository deviceRepository;

    public DeviceController(DeviceRepository deviceRepository) {
        this.deviceRepository = deviceRepository;
    }

    @GetMapping(value = "/")
    public List<Device> all() {
        return deviceRepository.findAll();
    }
}
