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
    public ResponseEntity<AddRoomResponse> createRoom(@AuthenticationPrincipal ClientPrincipal authenticationPrincipal, @RequestBody AddRoomRequest request) {
        Optional<Client> client = clientRepository.findById(authenticationPrincipal.getId());
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
    public ResponseEntity<?> editName(@PathVariable Long id, @RequestBody String roomName, @AuthenticationPrincipal ClientPrincipal clientPrincipal) {
        try {
            Optional<Room> room = roomRepository.findById(id);
            if(room.isPresent() && clientPrincipal.getId().equals(room.get().getClient().getId())) {
                System.out.println(roomName);
                room.get().setName(roomName);
                System.out.println(room.get().getName());

                Room r = roomRepository.save(room.get());
                return ResponseEntity.ok(r);
            }
        } catch (IllegalArgumentException | EmptyResultDataAccessException e){
            System.out.print(e.getStackTrace());
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping(value = "/{id}/delete")
    public ResponseEntity<?> deleteRoom(@PathVariable Long id, @AuthenticationPrincipal ClientPrincipal clientPrincipal) {
        try {
            Optional<Room> room = roomRepository.findById(id);
            if(room.isPresent() && clientPrincipal.getId().equals(room.get().getClient().getId())) {
                roomRepository.deleteById(id);
                return ResponseEntity.ok(room.get());
            }
        } catch (IllegalArgumentException | EmptyResultDataAccessException e){
            System.out.print(e.getStackTrace());
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping(value = "/add-device")
    public ResponseEntity<AddDeviceToRoomResponse> addDeviceToRoom(@RequestBody AddDeviceToRoomRequest request, @AuthenticationPrincipal ClientPrincipal clientPrincipal){
        Optional<Room> res = roomRepository.findById(request.getId());
        AddDeviceToRoomResponse response = new AddDeviceToRoomResponse(request.getId());
        if(res.isPresent()){
            if(clientPrincipal.getId().equals(res.get().getClient().getId())) {
                for (Long deviceId : request.getDeviceIds()) {
                    Optional<Device> device = deviceRepository.findById(deviceId);
                    if (device.isPresent() && device.get().getClient() != null) {
                        System.out.println(clientPrincipal.getId());
                        System.out.println(device.get().getClient().getId());
                        if(clientPrincipal.getId().equals(device.get().getClient().getId())) {
                            device.get().setRoom(res.get());
                            try {
                                deviceRepository.save(device.get());
                                response.addDevice(deviceId);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
            }
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping(value = "/remove-device")
    public ResponseEntity<RemoveDeviceFromRoomResponse> removeDeviceFromRoom(@RequestBody RemoveDeviceFromRoomRequest request,  @AuthenticationPrincipal ClientPrincipal clientPrincipal){
        Optional<Room> res = roomRepository.findById(request.getId());
        RemoveDeviceFromRoomResponse response = new RemoveDeviceFromRoomResponse(request.getId());
        if(res.isPresent()){
            if(clientPrincipal.getId().equals(res.get().getClient().getId())) {
                for (Long deviceId : request.getDeviceIds()) {
                    Optional<Device> device = deviceRepository.findById(deviceId);
                    if (device.isPresent() && device.get().getClient() != null) {
                        if(clientPrincipal.getId().equals(device.get().getClient().getId())) {
                            device.get().setRoom(null);
                            try {
                                deviceRepository.save(device.get());
                                response.addDevice(deviceId);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }

                }
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
                    if(room.get().addController(controller.get())) {
                        System.out.print("here");
                        response.addControllerName(controllerName);
                    }
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
