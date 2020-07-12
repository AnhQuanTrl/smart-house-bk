package com.salt.smarthomebackend.repository;

import com.salt.smarthomebackend.model.LightBulbHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LightBulbHistoryRepository extends JpaRepository<LightBulbHistory, Long> {
}
