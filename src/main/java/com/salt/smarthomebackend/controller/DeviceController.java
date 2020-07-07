package com.salt.smarthomebackend.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.payload.request.DeviceRequest;
import com.salt.smarthomebackend.payload.response.ApiResponse;
import com.salt.smarthomebackend.payload.response.HistoryEntryResponse;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import com.salt.smarthomebackend.payload.request.ControlDeviceRequest;
import com.salt.smarthomebackend.security.ClientPrincipal;
import javafx.scene.effect.Light;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.user.SimpUser;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/devices")
public class DeviceController {
    private DeviceRepository deviceRepository;
    private LightBulbRepository lightBulbRepository;
    private DeviceMessagePublisher deviceMessagePublisher;

    public DeviceController(DeviceRepository deviceRepository,
                            LightBulbRepository lightBulbRepository,
                            DeviceMessagePublisher deviceMessagePublisher) {
        this.deviceRepository = deviceRepository;
        this.lightBulbRepository = lightBulbRepository;
        this.deviceMessagePublisher = deviceMessagePublisher;
    }

    @GetMapping(value = "/")
    public List<Device> all(@AuthenticationPrincipal ClientPrincipal clientPrincipal) {
        Long usr_id = clientPrincipal.getId();
        List<Device> deviceLst = new ArrayList<>();

        for (Device d : deviceRepository.findAll()) {
            if (d.getClient() != null) if (d.getClient().getId().equals(usr_id)) {
                deviceLst.add(d);
            }
        }

        return deviceLst;
    }

    @PostMapping(value = "/control")
    public ResponseEntity<?> controlLightBulb(
            @AuthenticationPrincipal ClientPrincipal clientPrincipal,
            @RequestBody ControlDeviceRequest request) {
        try {
            Optional<LightBulb> res = lightBulbRepository.findById(request.getId());
            Map<String, Object> response = new HashMap<>();
            if (res.isPresent()) {
                if (!res.get().getClient().getId().equals(clientPrincipal.getId())) {
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ApiResponse(
                            false, "cannot control other device"));
                }
                res.get().setValue(request.getValue());
                res.get().getLightBulbHistory().getEntries()
                        .put(new Timestamp(new Date().getTime()), request.getValue());
                lightBulbRepository.save(res.get());
                try {
                    deviceMessagePublisher.publishMessage(res.get());
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }

                response.put("id", res.get().getId());
                response.put("value", request.getValue());
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping(value = "/stat/{id}")
    public ResponseEntity<?> statistic(@AuthenticationPrincipal ClientPrincipal clientPrincipal,
                                       @PathVariable Long id) {
        Optional<LightBulb> optional = lightBulbRepository.findById(id);
        if (!optional.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        LightBulb lightBulb = optional.get();
        if (!lightBulb.getClient().getId().equals(clientPrincipal.getId())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ApiResponse(
                    false, "cannot control other device"));
        }
        Map<Timestamp, Integer> timeValue = lightBulb.getLightBulbHistory().getEntries();
        Map<Integer, List<HistoryEntryResponse>> intermediate =
                timeValue.entrySet().stream()
                        .filter(e -> e.getKey().toLocalDateTime().getMonthValue() ==
                                LocalDateTime.now().getMonthValue()).collect(Collectors
                        .groupingBy(e -> e.getKey().toLocalDateTime().getDayOfMonth(),
                                Collectors.mapping(
                                        e -> new HistoryEntryResponse(e.getKey().getTime(),
                                                e.getValue()), Collectors.toList())));
        return ResponseEntity.ok(intermediate);
    }


}
