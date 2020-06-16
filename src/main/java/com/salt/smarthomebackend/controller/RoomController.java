package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.Client;
import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.Room;
import com.salt.smarthomebackend.payload.request.*;
import com.salt.smarthomebackend.payload.response.*;
import com.salt.smarthomebackend.repository.ClientRepository;
import com.salt.smarthomebackend.repository.DeviceRepository;
import com.salt.smarthomebackend.repository.RoomRepository;
import com.salt.smarthomebackend.security.ClientPrincipal;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {
    private RoomRepository roomRepository;
    private DeviceRepository deviceRepository;
    private ClientRepository clientRepository;
    public RoomController(DeviceRepository deviceRepository, RoomRepository roomRepository, ClientRepository clientRepository) {
        this.roomRepository = roomRepository;
        this.deviceRepository = deviceRepository;
        this.clientRepository = clientRepository;
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
    public ResponseEntity<AddRoomResponse> createRoom(@RequestBody AddRoomRequest request) {
        Optional<Client> client = clientRepository.findByUsername(request.getClientName());
        if (client.isPresent()){
            Room newRoom = new Room(request.getName(), client.get());
            try {
                newRoom = roomRepository.save(newRoom);
            }
            catch (Exception e){ e.printStackTrace(); }
            AddRoomResponse response = new AddRoomResponse(newRoom.getId(), newRoom.getName(), newRoom.getClient().getUsername());
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
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

    @PatchMapping(value = "/remove-device")
    public ResponseEntity<RemoveDeviceFromRoomResponse> removeDeviceFromRoom(@RequestBody RemoveDeviceFromRoomRequest request){
        Optional<Room> res = roomRepository.findById(request.getId());
        RemoveDeviceFromRoomResponse response = new RemoveDeviceFromRoomResponse(request.getId());
        if(res.isPresent()){
            for(Long deviceId:request.getDevices()){
                Optional<Device> device = deviceRepository.findById(deviceId);
                if(device.isPresent()){
                    device.get().setRoom(null);
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


    @PatchMapping(value = "/add-controller")
    public ResponseEntity<AddControllerResponse> addController(@RequestBody AddControllerRequest request,  @AuthenticationPrincipal ClientPrincipal clientPrincipal){
        Optional<Room> room = roomRepository.findById(request.getRoomId());
        Optional<Client> owner = clientRepository.findByUsername(clientPrincipal.getUsername());
        AddControllerResponse response = new AddControllerResponse(request.getRoomId(), clientPrincipal.getUsername());
        if(room.isPresent() && owner.isPresent() && room.get().getClient().getId() == owner.get().getId()){
            for(String controllerName:request.getControllerNames()){
                Optional<Client> controller = clientRepository.findByUsername(controllerName);
                if(controller.isPresent()){
                    if(room.get().addController(controller.get()))
                        response.addControllerName(controllerName);
                } else return ResponseEntity.notFound().build();
            }
            try {
                roomRepository.save(room.get());
            }
            catch (Exception e){ e.printStackTrace(); }
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping(value = "/remove-controller")
    public ResponseEntity<RemoveControllerResponse> removeController(@RequestBody RemoveControllerRequest request, @AuthenticationPrincipal ClientPrincipal clientPrincipal){
        Optional<Room> room = roomRepository.findById(request.getRoomId());
        Optional<Client> owner = clientRepository.findByUsername(clientPrincipal.getUsername());
        RemoveControllerResponse response = new RemoveControllerResponse(request.getRoomId(), clientPrincipal.getUsername());
        if(room.isPresent() && owner.isPresent() && room.get().getClient().getId() == owner.get().getId()){
            for(String controllerName:request.getControllerNames()){
                Optional<Client> controller = clientRepository.findByUsername(controllerName);
                if(controller.isPresent()){
                    if(room.get().removeController(controller.get()))
                        response.addControllerName(controllerName);
                } else return ResponseEntity.notFound().build();
            }
            try {
                roomRepository.save(room.get());
            }
            catch (Exception e){ e.printStackTrace(); }
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
    }
}
