package com.salt.smarthomebackend.repository;

import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.LightBulb;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface LightBulbRepository extends JpaRepository<LightBulb, Long> {
    Optional<LightBulb> findByName(String name);
}
