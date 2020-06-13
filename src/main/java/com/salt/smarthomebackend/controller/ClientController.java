package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.exception.ClientNotFoundException;
import com.salt.smarthomebackend.exception.DeviceNotFoundException;
import com.salt.smarthomebackend.exception.RoomNotFoundException;
import com.salt.smarthomebackend.model.BaseIdentity;
import com.salt.smarthomebackend.model.Client;
import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.Room;
import com.salt.smarthomebackend.payload.ApiResponse;
import com.salt.smarthomebackend.repository.ClientRepository;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.RoomRepository;
import com.salt.smarthomebackend.request.AddRoomRequest;
import com.salt.smarthomebackend.response.AddRoomResponse;
import com.salt.smarthomebackend.security.ClientDetailsService;
import com.salt.smarthomebackend.security.JwtAuthenticationFilter;
import com.salt.smarthomebackend.security.JwtTokenProvider;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.Header;
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

    @PostMapping("device/{device_id}/register")
    Device registerDevice(@PathVariable(value="device_id") Long device_id, @RequestHeader("Authorization") String token) throws Exception {
        JwtTokenProvider tokenProvider = new JwtTokenProvider();
        token = token.replace("Bearer ", "");
        Long usr_id = tokenProvider.getClientIdFromJWT(token);
        Client client = clientRepository.findById(usr_id).orElseThrow(()->new ClientNotFoundException(usr_id));
        return deviceRepository.findById(device_id)
                .map(device -> {
                    device.setClient(client);
                    return deviceRepository.save(device);
                })
                .orElseThrow(() -> new DeviceNotFoundException(device_id));
    }

    @PostMapping("/device/{device_id}/unregister")
    Device unregisterDevice(@PathVariable Long device_id, @RequestHeader(value="Authorization") String token) throws Exception {
        JwtTokenProvider tokenProvider = new JwtTokenProvider();
        token = token.replace("Bearer ", "");
        Long usr_id = tokenProvider.getClientIdFromJWT(token);

        Client client = clientRepository.findById(usr_id).orElseThrow(()->new ClientNotFoundException(usr_id));
        return deviceRepository.findById(device_id)
                .map(device -> {
                    device.setClient(null);
                    return deviceRepository.save(device);
                })
                .orElseThrow(() -> new DeviceNotFoundException(device_id));
    }

    @PostMapping("/addRoom/{room_id}")
    ResponseEntity<AddRoomResponse> addRoom(@PathVariable Long room_id, @RequestHeader("Authorization") String token) throws Exception {
        JwtTokenProvider tokenProvider = new JwtTokenProvider();
        token = token.replace("Bearer ", "");
        Long usr_id = tokenProvider.getClientIdFromJWT(token);
        Optional<Client> client = clientRepository.findById(usr_id);
        if (client.isPresent()){
            try {
                Room room = roomRepository.findById(room_id).orElseThrow(()->new RoomNotFoundException(room_id));
                room.addController(client.get());
                room = roomRepository.save(room);
                AddRoomResponse response = new AddRoomResponse(room.getId(), room.getName(), client.get().getUsername());
                return ResponseEntity.ok(response);
            }
            catch (Exception e){
                e.printStackTrace();
                return ResponseEntity.notFound().build();
            }
        }
        return ResponseEntity.notFound().build();
    }

//    @PostMapping("/addRelative/{rel_id}")
//    ResponseEntity<Client> addRelative(@PathVariable Long rel_id, @RequestHeader("Authorization") String token) throws Exception {
//        JwtTokenProvider tokenProvider = new JwtTokenProvider();
//        token = token.split(" ")[1];
//        Long usr_id = tokenProvider.getClientIdFromJWT(token);
//        Optional<Client> client = clientRepository.findById(usr_id);
//        if (client.isPresent()){
//            try {
//                Client _client = client.get();
//                Client relative = clientRepository.findById(rel_id).orElseThrow(()->new ClientNotFoundException(rel_id));
//
//                clientRepository.save(_client);
//                relative = clientRepository.save(relative);
//                return ResponseEntity.ok(relative);
//            }
//            catch (Exception e){
//                e.printStackTrace();
//                return ResponseEntity.notFound().build();
//            }
//        }
//        return ResponseEntity.notFound().build();
//    }


}