package com.salt.smarthomebackend.repository;

import com.salt.smarthomebackend.model.Room;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoomRepository extends JpaRepository<Room, Long> {
    Room findByName(String name);
}
