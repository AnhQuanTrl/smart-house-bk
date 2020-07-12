package com.salt.smarthomebackend.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.salt.smarthomebackend.event.AutomationEvent;
import com.salt.smarthomebackend.messaging.mqtt.DeviceMessagePublisher;
import com.salt.smarthomebackend.model.Automation;
import com.salt.smarthomebackend.model.LightBulb;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Service;

import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;
import java.util.concurrent.ScheduledFuture;

@Service
public class AutomationSchedulerService {
    TaskScheduler taskScheduler;
    DeviceMessagePublisher deviceMessagePublisher;
    public AutomationSchedulerService(TaskScheduler taskScheduler, DeviceMessagePublisher deviceMessagePublisher) {
        this.taskScheduler = taskScheduler;
        this.deviceMessagePublisher = deviceMessagePublisher;
    }

    public void addTaskToScheduler(long id, LocalTime time, LightBulb lightBulb) {
        CronTrigger cronTrigger = new CronTrigger("0 " + time.getMinute() + " * * * ?",
                TimeZone.getDefault());
        ScheduledFuture<?> scheduledTask =
                taskScheduler.schedule(() -> {
                            try {

                                deviceMessagePublisher.publishMessage(lightBulb);
                            } catch (JsonProcessingException e) {
                                e.printStackTrace();
                            }
                        },
        cronTrigger);
        jobsMap.put(id, scheduledTask);
    }
    public void updateTaskForScheduler(Long id, LocalTime time) {
        CronTrigger cronTrigger = new CronTrigger("0 " + time.getMinute() + " * * * ?",
                TimeZone.getDefault());
        jobsMap.get(id).cancel(true);
        ScheduledFuture<?> newScheduledTask =
                taskScheduler.schedule(() -> System.out.println("Yay!"), cronTrigger);
        jobsMap.put(id, newScheduledTask);
    }
    public void removeTaskFromScheduler(Long id) {
        ScheduledFuture<?> scheduledTask = jobsMap.get(id);
        if(scheduledTask != null) {
            scheduledTask.cancel(true);
            jobsMap.put(id, null);
        }
    }

    Map<Long, ScheduledFuture<?>> jobsMap = new HashMap<>();

    @EventListener
    public void updateJobs(AutomationEvent automationEvent) {
        Automation automation = (Automation) automationEvent.getSource();
        switch (automationEvent.getCommand()) {
            case ADD:
                addTaskToScheduler(automation.getId(), automation.getTriggerTime(), automation.getLightBulb());
                break;
            case UPDATE:
                updateTaskForScheduler(automation.getId(), automation.getTriggerTime());
                break;
            case REMOVE:
                removeTaskFromScheduler(automation.getId());
        }

    }
}
