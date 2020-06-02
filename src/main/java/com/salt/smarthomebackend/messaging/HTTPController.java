package com.salt.smarthomebackend.messaging;

import com.salt.smarthomebackend.Exception.DeviceNotFoundException;
import com.salt.smarthomebackend.Exception.RoomNotFoundException;
import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.Room;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.RoomRepository;
import org.springframework.web.bind.annotation.*;

@RestController
class HTTPController {
    private final DeviceRepository deviceRepository;
    private final RoomRepository roomRepository;

    HTTPController(DeviceRepository repository, RoomRepository roomRepository) {
        this.deviceRepository = repository;
        this.roomRepository = roomRepository;
    }

//    @PostMapping("/device")
//    Device newDevice(@RequestBody Device newDevice) {
//        return repository.save(newDevice);
//    }

    @GetMapping("/device/{id}")
    Device getDevice(@PathVariable Long id) {
        return deviceRepository.findById(id).orElseThrow(() -> new DeviceNotFoundException(id));
    }

    @GetMapping("/room/{id}")
    Room getRoom(@PathVariable Long id) {
        return roomRepository.findById(id).orElseThrow(() -> new RoomNotFoundException(id));
    }

    @PostMapping("/createRoom")
    Room createRoom(@RequestBody String name) {
        return roomRepository.save(new Room(name));
    }

    @GetMapping("/removeRoom/{id}")
    void removeRoom(@PathVariable Long id) {
        roomRepository.deleteById(id);
    }

    @PostMapping("/room/{id}/update")
    Room updateRoom(@RequestBody Room newRoom, @PathVariable Long id) {

        // Not sure about this one !!!

        return roomRepository.findById(id)
                .map(room -> {
                    room.setName(newRoom.getName());
                    return roomRepository.save(room);
                })
                .orElseGet(() -> {
                    newRoom.setId(id);
                    return roomRepository.save(newRoom);
                });
    }

}