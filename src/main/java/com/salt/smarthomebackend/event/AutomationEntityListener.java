package com.salt.smarthomebackend.event;

import com.salt.smarthomebackend.helper.AutowireHelper;
import com.salt.smarthomebackend.model.Automation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;

import javax.persistence.PostPersist;
import javax.persistence.PostRemove;
import javax.persistence.PostUpdate;

public class AutomationEntityListener {
    @Autowired
    private ApplicationEventPublisher publisher;

    @PostPersist
    @PostUpdate
    //spring cannot autowire entity listener, need a custom autowire helper class
    public void onPersistAndUpdate(Automation automation) {
        AutowireHelper.autowire(this, this.publisher);
        this.publisher.publishEvent(new AutomationEvent(automation, AutomationEvent.Command.ADD));
    }

    @PostRemove
    public void onRemove(Automation automation) {
        AutowireHelper.autowire(this, this.publisher);
        this.publisher.publishEvent(new AutomationEvent(automation,
                AutomationEvent.Command.REMOVE));
    }
}
