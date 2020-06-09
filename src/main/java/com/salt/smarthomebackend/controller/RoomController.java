package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.Room;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.RoomRepository;
import com.salt.smarthomebackend.request.AddDeviceToRoomRequest;
import com.salt.smarthomebackend.response.AddDeviceToRoomResponse;
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
    private DeviceRepository deviceRepository;
    public RoomController(DeviceRepository deviceRepository, RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
        this.deviceRepository = deviceRepository;
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

    @PatchMapping(value = "/{id}/update")
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

    @PatchMapping(value = "/add-device")
    public ResponseEntity<AddDeviceToRoomResponse> addDeviceToRoom(@RequestBody AddDeviceToRoomRequest request){
        Optional<Room> res = roomRepository.findById(request.getId());
        AddDeviceToRoomResponse response = new AddDeviceToRoomResponse(request.getId());
        if(res.isPresent()){
            for (Long deviceId:request.getDevices()) {
                Optional<Device> device = deviceRepository.findById(deviceId);
                if(device.isPresent()){
                    device.get().setRoom(res.get());
                }
                try{
                    deviceRepository.save(device.get());
                    response.addDevice(deviceId);
                }
                catch (Exception e){ e.printStackTrace(); }
            }
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
    }

//    @PatchMapping(value = "/remove-device")


}
