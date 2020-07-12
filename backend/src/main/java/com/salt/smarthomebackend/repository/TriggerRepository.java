package com.salt.smarthomebackend.repository;

import com.salt.smarthomebackend.model.Room;
import com.salt.smarthomebackend.model.Trigger;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TriggerRepository extends JpaRepository<Trigger, Long> {
}
