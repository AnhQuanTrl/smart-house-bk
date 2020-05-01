package com.salt.smarthomebackend.repository;

import com.salt.smarthomebackend.model.Sensor;
import org.springframework.data.repository.CrudRepository;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete

public interface SensorRepository extends CrudRepository<Sensor, Integer> {

}