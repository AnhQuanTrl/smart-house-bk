package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.exception.ClientNotFoundException;
import com.salt.smarthomebackend.exception.DeviceNotFoundException;
import com.salt.smarthomebackend.model.Client;
import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.repository.ClientRepository;
import com.salt.smarthomebackend.repository.DeviceRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/api/clients")
class ClientController {
    private ClientRepository clientRepository;
    private DeviceRepository deviceRepository;

    ClientController(ClientRepository clientRepository, DeviceRepository deviceRepository) {
        this.clientRepository = clientRepository;
        this.deviceRepository = deviceRepository;
    }

    @PostMapping("/signup")
    ResponseEntity<Object> clientSignup(@RequestBody Client _client ) {
        Map<String, String> res = new HashMap<>();

        Client client = clientRepository.findByUsername(_client.getUsername());
        if (client == null) {
            clientRepository.save(_client);
            res.put("signup", "succeeded");
        }
        else {
            res.put("error", "username already exists");
        }
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    @PostMapping("/login")
    ResponseEntity<Object> clientLogin(@RequestBody Client _client ) {
        Map<String, String> res = new HashMap<>();

        Client client = clientRepository.findByUsername(_client.getUsername());
        if (client != null && client.getPassword().equals(_client.getPassword())) {
            res.put("login", "succeeded");
        }
        else {
            res.put("login", "failed");
        }

        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    @PostMapping("/logout")
    ResponseEntity<Object>  clientLogout(@RequestBody String username) {
        Map<String, String> res = new HashMap<>();
        res.put("logout", "succeeded");
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    @PostMapping("device/{device_id}/register")
    Device registerDevice(@PathVariable(value="device_id") Long device_id, @RequestBody Map<String, String> usr_id) throws Exception {
        Long usrId = Long.parseLong(usr_id.get("usr_id"));
        Client client = clientRepository.findById(usrId).orElseThrow(()->new ClientNotFoundException(usrId));
        return deviceRepository.findById(device_id)
                .map(device -> {
                    device.setClient(client);
                    return deviceRepository.save(device);
                })
                .orElseThrow(() -> new DeviceNotFoundException(device_id));
    }

    @PostMapping("/device/{device_id}/unregister")
    Device unregisterDevice(@PathVariable Long device_id, @RequestBody Map<String, String> usr_id) throws Exception {
        Long usrId = Long.parseLong(usr_id.get("usr_id"));
        Client client = clientRepository.findById(usrId).orElseThrow(()->new ClientNotFoundException(usrId));
        return deviceRepository.findById(device_id)
                .map(device -> {
                    device.setClient(null);
                    return deviceRepository.save(device);
                })
                .orElseThrow(() -> new DeviceNotFoundException(device_id));
    }

}