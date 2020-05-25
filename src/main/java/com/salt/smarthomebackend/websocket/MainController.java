package com.salt.smarthomebackend.websocket;


import com.salt.smarthomebackend.model.Device;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

@Controller
public class MainController {

    @Autowired
    private SimpMessageSendingOperations messagingTemplate;

    @RequestMapping("/")
    public String loadData() {
            return "redirect:/getAll";
    }

    @RequestMapping(path = "/getAll", method = RequestMethod.GET)
    public void getAll() {
        DeviceTmpInfo tmp = new DeviceTmpInfo();
        messagingTemplate.convertAndSend("/topic/deviceInfo", tmp.getInfoLst());
    }

    @RequestMapping(path = "/getOne", method = RequestMethod.POST)
    public void getOne(@RequestParam Long id) {
        Map<Long, Device> deviceMap = (new DeviceTmpInfo()).getInfoMap();
        if (deviceMap.containsKey(id)) {
            messagingTemplate.convertAndSend("/topic/deviceInfo", deviceMap.get(id));
        }
    }

    @RequestMapping(path = "/makeChange", method = RequestMethod.POST)
    public void makeChange(@RequestParam Long id, @RequestParam(defaultValue = "") String feature,
                           @RequestParam(defaultValue = "") String value) {
        Map<Long, Device> deviceMap = (new DeviceTmpInfo()).getInfoMap();
        if (deviceMap.containsKey(id)) {
            // Do something to update value

            // Broadcast change to all users
            messagingTemplate.convertAndSend("/topic/deviceInfo", deviceMap.get(id));
        }
    }

//    @RequestMapping(path = "/logout")
//    public String logout(HttpServletRequest request) {
//        request.getSession(true).invalidate();
//
//        return "redirect:/login";
//    }

}
