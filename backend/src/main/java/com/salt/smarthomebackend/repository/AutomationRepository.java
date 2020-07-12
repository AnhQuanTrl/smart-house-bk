package com.salt.smarthomebackend.repository;

import com.salt.smarthomebackend.model.Automation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AutomationRepository extends JpaRepository<Automation, Long> {
}
