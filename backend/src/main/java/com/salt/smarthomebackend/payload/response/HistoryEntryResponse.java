package com.salt.smarthomebackend.payload.response;

public class HistoryEntryResponse {
    private Long time;
    private Integer value;

    public HistoryEntryResponse(long time, Integer value) {
        this.time = time;
        this.value = value;
    }

    public Long getTime() {
        return time;
    }

    public void setTime(long time) {
        this.time = time;
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }
}
