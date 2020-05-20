package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.Room;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.RoomRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class ApiController {
    private DeviceRepository deviceRepository;
    private RoomRepository roomRepository;
    public ApiController(DeviceRepository deviceRepository, RoomRepository roomRepository) {
        this.deviceRepository = deviceRepository;
        this.roomRepository = roomRepository;
    }
    @GetMapping(value = "/rooms")
    public List<Room> allRoom() {
        return roomRepository.findAll();
    }

    @GetMapping(value = "/devices")
    public List<Device> allDevice() {
        return deviceRepository.findAll();
    }

    @GetMapping(value = "/room/{id}")
    public ResponseEntity<Room> oneRoom(@PathVariable Long id) {
        Optional<Room> res = roomRepository.findById(id);
        if (res.isPresent()) {
            return ResponseEntity.ok(res.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    @PostMapping(value = "/create-room")
    public ResponseEntity<Map<String, Long>> createRoom(@RequestBody Room roomInfo) {
        Room room = roomRepository.save(roomInfo);
        if (room == null) {
            return ResponseEntity.notFound().build();
        }
        else {
            Map<String, Long> res = new HashMap<>();
            res.put("id", room.getId());
            return ResponseEntity.ok(res);
        }
    }

    @PutMapping(value = "/update-room/{id}")
    public ResponseEntity<?> editRoom(@PathVariable Long id, @RequestBody Room roomInfo) {
        Optional<Room> res = roomRepository.findById(id);
        if (res.isPresent()) {
            Room room = res.get();
            room.setName(roomInfo.getName());
            roomRepository.save(room);
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping(value = "/delete-room/{id}")
    public ResponseEntity<?> deleteRoom(@PathVariable Long id) {
        try {
            System.out.println(id);
            roomRepository.deleteById(id);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e){
            return ResponseEntity.notFound().build();
        }
    }


}
