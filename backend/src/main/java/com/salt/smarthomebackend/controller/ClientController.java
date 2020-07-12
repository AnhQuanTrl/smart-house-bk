package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.exception.ClientNotFoundException;
import com.salt.smarthomebackend.exception.DeviceNotFoundException;
import com.salt.smarthomebackend.model.*;
import com.salt.smarthomebackend.payload.response.ApiResponse;
import com.salt.smarthomebackend.payload.request.DeviceRequest;
import com.salt.smarthomebackend.repository.*;
import com.salt.smarthomebackend.security.ClientPrincipal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@RestController
@RequestMapping("/api/users/")
class ClientController {
    private final ClientRepository clientRepository;
    private final DeviceRepository deviceRepository;
    private final LightBulbRepository lightBulbRepository;
    private final LightSensorRepository lightSensorRepository;
    private RoomRepository roomRepository;
    private TriggerRepository triggerRepository;


    ClientController(ClientRepository clientRepository, DeviceRepository deviceRepository,
                     RoomRepository roomRepository, TriggerRepository triggerRepository,
                     LightBulbRepository lightBulbRepository, LightSensorRepository lightSensorRepository) {
        this.clientRepository = clientRepository;
        this.deviceRepository = deviceRepository;
        this.roomRepository = roomRepository;
        this.triggerRepository = triggerRepository;
        this.lightBulbRepository = lightBulbRepository;
        this.lightSensorRepository = lightSensorRepository;
    }

    @GetMapping(value = "/")
    public List<Client> allClient() {
        return clientRepository.findAll();
    }

    @PostMapping("/logout")
    ResponseEntity<Object> clientLogout() {
        ApiResponse res = new ApiResponse(true, "Sucessfully log out");
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    @PostMapping("device_register")
    ResponseEntity<?> registerDevice(@RequestBody DeviceRequest _device,
                          @AuthenticationPrincipal ClientPrincipal clientPrincipal) throws Exception {
        String device_id = _device.getName();
        Long usr_id = clientPrincipal.getId();
        Client client =
                clientRepository.findById(usr_id).orElseThrow(() -> new ClientNotFoundException(usr_id));
        Optional<Device> optionalDevice = deviceRepository.findByName(device_id);
        if (!optionalDevice.isPresent()) {
            throw new DeviceNotFoundException(device_id);
        }
        Device device = optionalDevice.get();
        if (client.getDevices().contains(device)) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, "Already have it"));
        } else {
            device.setClient(client);
            deviceRepository.save(device);
            return ResponseEntity.ok(device);
        }
    }

    @PostMapping("/device_unregister")
    ResponseEntity<Device> unregisterDevice(@RequestBody DeviceRequest _device,
                            @AuthenticationPrincipal ClientPrincipal clientPrincipal) throws Exception {
        String device_id = _device.getName();
        Long usr_id = clientPrincipal.getId();
        Client client =
                clientRepository.findById(usr_id    ).orElseThrow(() -> new ClientNotFoundException(usr_id));
        Optional<Device> optionalDevice = deviceRepository.findByName(device_id);
        if (!optionalDevice.isPresent()) {
            throw new DeviceNotFoundException(device_id);
        }
        Device device = optionalDevice.get();
        device.setClient(null);
        device.setRoom(null);
        if (device instanceof LightSensor) {
            List<Long> triggerIds =
                    ((LightSensor) device).getTriggers().stream().map(BaseIdentity::getId).collect(
                            Collectors.toList());
            triggerIds.forEach(triggerId -> {
                Trigger trigger = triggerRepository.findById(triggerId).get();
                LightBulb lb = trigger.getLightBulb();
                LightSensor ls = trigger.getLightSensor();
                ls.getTriggers().remove(trigger);
                lightSensorRepository.save(ls);
                lb.setTrigger(null);
                lightBulbRepository.save(lb);
                triggerRepository.deleteById(trigger.getId());
            });
            triggerRepository.flush();
        }
        deviceRepository.save(device);
        return ResponseEntity.ok(device);
    }

}