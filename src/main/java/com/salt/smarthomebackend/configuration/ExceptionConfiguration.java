package com.salt.smarthomebackend.configuration;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class ExceptionConfiguration extends ResponseEntityExceptionHandler {
    @Override
    public ResponseEntity<Object> handleHttpMessageNotReadable(HttpMessageNotReadableException ex,
                                                          HttpHeaders headers, HttpStatus status, WebRequest request) {
        Map<String, String> res = new HashMap<>();
        res.put("error", "wrong format");
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(res);
    }
}
