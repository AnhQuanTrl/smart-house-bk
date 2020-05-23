package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.Room;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.RoomRepository;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {
    private RoomRepository roomRepository;
    public RoomController(DeviceRepository deviceRepository, RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }
    @GetMapping(value = "/")
    public List<Room> allRoom() {
        return roomRepository.findAll();
    }



    @GetMapping(value = "/{id}")
    public ResponseEntity<Room> oneRoom(@PathVariable Long id) {
        Optional<Room> res = roomRepository.findById(id);
        return res.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }
    @PostMapping(value = "/create")
    public ResponseEntity<Map<String, Long>> createRoom(@RequestBody Room roomInfo) {
        try {
            Room room = roomRepository.save(roomInfo);
            Map<String, Long> res = new HashMap<>();
            res.put("id", room.getId());
            return ResponseEntity.ok(res);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PutMapping(value = "/{id}/update")
    public ResponseEntity<?> editRoom(@PathVariable Long id, @RequestBody Room roomInfo) {
        Optional<Room> res = roomRepository.findById(id);
        return res.map(room -> {
            room.setName(roomInfo.getName());
            roomRepository.save(room);
            return ResponseEntity.ok().build();
        }).orElseGet(() ->  ResponseEntity.notFound().build());
    }

    @DeleteMapping(value = "/{id}/delete")
    public ResponseEntity<?> deleteRoom(@PathVariable Long id) {
        try {
            roomRepository.deleteById(id);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException | EmptyResultDataAccessException e){
            return ResponseEntity.notFound().build();
        }
    }


}
