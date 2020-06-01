package com.salt.smarthomebackend.controller;

import com.salt.smarthomebackend.model.Automation;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.repository.AutomationRepository;
import com.salt.smarthomebackend.repository.LightBulbRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/automations")
public class AutomationController {
    AutomationRepository automationRepository;
    LightBulbRepository lightBulbRepository;
    public AutomationController(AutomationRepository automationRepository, LightBulbRepository lightBulbRepository) {
        this.automationRepository = automationRepository;
        this.lightBulbRepository = lightBulbRepository;
    }

    @GetMapping("/")
    public List<Automation> all() {
        return automationRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Automation> one(@PathVariable Long id) {
        Optional<Automation> res = automationRepository.findById(id);
        return res.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("/create")
    public ResponseEntity<Map<String, Long>> addAutomation(@RequestBody Automation auto) {
        try {
            Optional<LightBulb> res =
                    lightBulbRepository.findById(auto.getLightBulb().getId());
            if (res.isPresent()) {
                Automation automation = automationRepository.save(auto);
                res.get().setAutomation(automation);
                lightBulbRepository.save(res.get());
                Map<String, Long> response = new HashMap<>();
                response.put("id", automation.getId());
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    @PutMapping("/{id}/update")
    public ResponseEntity<?> updateAutomation(@PathVariable Long id,
                                              @RequestBody Automation automation) {
        Optional<Automation> res = automationRepository.findById(id);
        return res.map(auto -> {
            auto.setTriggerTime(automation.getTriggerTime());
            automationRepository.save(auto);
            return ResponseEntity.ok().build();
        }).orElseGet(() ->  ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}/delete")
    public ResponseEntity<?> deleteAutomation(@PathVariable Long id) {
        try {
            Optional<Automation> res = automationRepository.findById(id);
            if (res.isPresent()) {
                LightBulb lightBulb = res.get().getLightBulb();
                lightBulb.setAutomation(null);
                lightBulbRepository.save(lightBulb);
                automationRepository.deleteById(id);
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.badRequest().build();
            }
        } catch (IllegalArgumentException e ) {
            return ResponseEntity.badRequest().build();
        }
    }
}

