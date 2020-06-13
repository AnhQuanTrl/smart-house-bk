package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.exception.ClientNotFoundException;
import com.salt.smarthomebackend.exception.DeviceNotFoundException;
import com.salt.smarthomebackend.exception.RoomNotFoundException;
import com.salt.smarthomebackend.model.BaseIdentity;
import com.salt.smarthomebackend.model.Client;
import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.Room;
import com.salt.smarthomebackend.payload.ApiResponse;
import com.salt.smarthomebackend.payload.DeviceRequest;
import com.salt.smarthomebackend.repository.ClientRepository;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.RoomRepository;
import com.salt.smarthomebackend.request.AddRoomRequest;
import com.salt.smarthomebackend.response.AddRoomResponse;
import com.salt.smarthomebackend.security.ClientDetailsService;
import com.salt.smarthomebackend.security.ClientPrincipal;
import com.salt.smarthomebackend.security.JwtAuthenticationFilter;
import com.salt.smarthomebackend.security.JwtTokenProvider;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;


@RestController
@RequestMapping("/api/users/")
class ClientController {
    private ClientRepository clientRepository;
    private DeviceRepository deviceRepository;
    private RoomRepository roomRepository;


    ClientController(ClientRepository clientRepository, DeviceRepository deviceRepository, RoomRepository roomRepository) {
        this.clientRepository = clientRepository;
        this.deviceRepository = deviceRepository;
        this.roomRepository = roomRepository;
    }

    @GetMapping(value = "/")
    public List<Client> allClient() {
        return clientRepository.findAll();
    }

    @PostMapping("/logout")
    ResponseEntity<Object>  clientLogout() {
        ApiResponse res = new ApiResponse(true, "Sucessfully log out");
        return ResponseEntity.status(HttpStatus.OK).body(res);
    }

    @PostMapping("deviceRegister")
    Device registerDevice(@RequestBody DeviceRequest _device, @AuthenticationPrincipal ClientPrincipal clientPrincipal) throws Exception {
        Long device_id = _device.getId();
        Long usr_id = clientPrincipal.getId();
        Client client = clientRepository.findById(usr_id).orElseThrow(()->new ClientNotFoundException(usr_id));
        return deviceRepository.findById(device_id)
                .map(device -> {
                    device.setClient(client);
                    return deviceRepository.save(device);
                })
                .orElseThrow(() -> new DeviceNotFoundException(device_id));
    }

    @PostMapping("/deviceUnregister")
    Device unregisterDevice(@RequestBody DeviceRequest _device, @AuthenticationPrincipal ClientPrincipal clientPrincipal)  throws Exception {
        Long device_id = _device.getId();
        Long usr_id = clientPrincipal.getId();
        Client client = clientRepository.findById(usr_id).orElseThrow(()->new ClientNotFoundException(usr_id));
        return deviceRepository.findById(device_id)
                .map(device -> {
                    device.setClient(null);
                    return deviceRepository.save(device);
                })
                .orElseThrow(() -> new DeviceNotFoundException(device_id));
    }

}