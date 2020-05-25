package com.salt.smarthomebackend.websocket;

import com.salt.smarthomebackend.model.Device;
import com.salt.smarthomebackend.model.LightBulb;
import com.salt.smarthomebackend.model.LightSensor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

public class DeviceTmpInfo {
    public List<Device> deviceInfo = new CopyOnWriteArrayList<>();
    Map<Long, Object> map=new HashMap();


    public DeviceTmpInfo() {
        deviceInfo.add(new LightSensor("ls1",2));
        deviceInfo.add(new LightSensor("ls2",4));
        deviceInfo.add(new LightSensor("ls3",3));
        deviceInfo.add(new LightSensor("ls4",5));
        deviceInfo.add(new LightSensor("ls5",4));
        deviceInfo.add(new LightSensor("ls7",5));
        deviceInfo.add(new LightBulb("lb1",false));
        deviceInfo.add(new LightBulb("lb2",false));
        deviceInfo.add(new LightBulb("lb3",true));
        deviceInfo.add(new LightBulb("lb4",true));
        deviceInfo.add(new LightBulb("lb5",false));
        deviceInfo.add(new LightBulb("lb6",true));

        for(Device d: deviceInfo) {
            map.put(d.getId(), d);
        }

    }

    public List<Device> getInfoLst() {
        return  deviceInfo;
    }

    public Map getInfoMap() {
        return  map;
    }

}
