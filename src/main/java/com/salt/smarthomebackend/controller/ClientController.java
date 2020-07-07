package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.exception.ClientNotFoundException;
import com.salt.smarthomebackend.exception.DeviceNotFoundException;
import com.salt.smarthomebackend.model.Client;
import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.payload.response.ApiResponse;
import com.salt.smarthomebackend.payload.request.DeviceRequest;
import com.salt.smarthomebackend.repository.ClientRepository;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.RoomRepository;
import com.salt.smarthomebackend.security.ClientPrincipal;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/users/")
class ClientController {
    private final ClientRepository clientRepository;
    private final DeviceRepository deviceRepository;
    private RoomRepository roomRepository;


    ClientController(ClientRepository clientRepository, DeviceRepository deviceRepository,
                     RoomRepository roomRepository) {
        this.clientRepository = clientRepository;
        this.deviceRepository = deviceRepository;
        this.roomRepository = roomRepository;
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
    Device registerDevice(@RequestBody DeviceRequest _device,
                          @AuthenticationPrincipal ClientPrincipal clientPrincipal) throws Exception {
        String device_id = _device.getName();
        Long usr_id = clientPrincipal.getId();
        Client client =
                clientRepository.findById(usr_id).orElseThrow(() -> new ClientNotFoundException(usr_id));
        return deviceRepository.findByName(device_id)
                .map(device -> {
                    device.setClient(client);
                    return deviceRepository.save(device);
                })
                .orElseThrow(() -> new DeviceNotFoundException(device_id));
    }

    @PostMapping("/device_unregister")
    Device unregisterDevice(@RequestBody DeviceRequest _device,
                            @AuthenticationPrincipal ClientPrincipal clientPrincipal) throws Exception {
        String device_id = _device.getName();
        Long usr_id = clientPrincipal.getId();
        Client client =
                clientRepository.findById(usr_id).orElseThrow(() -> new ClientNotFoundException(usr_id));
        return deviceRepository.findByName(device_id)
                .map(device -> {
                    device.setClient(null);
                    return deviceRepository.save(device);
                })
                .orElseThrow(() -> new DeviceNotFoundException(device_id));
    }

}