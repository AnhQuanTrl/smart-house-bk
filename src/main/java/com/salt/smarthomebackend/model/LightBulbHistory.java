package com.salt.smarthomebackend.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class LightBulbHistory extends BaseIdentity {
    @OneToOne
    private LightBulb lightBulb;

    @ElementCollection
    @CollectionTable(name = "history_entry", joinColumns = {@JoinColumn(name = "history_id",
            referencedColumnName = "id")})
    @MapKeyColumn(name = "time")
    @Column(name = "value")
    private Map<Timestamp, Integer> entries = new HashMap<>();
}
