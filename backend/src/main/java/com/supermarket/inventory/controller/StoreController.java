package com.supermarket.inventory.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.supermarket.inventory.dto.request.LoginRequest;
import com.supermarket.inventory.dto.request.StoreUpdateRequest;
import com.supermarket.inventory.entity.Administrator;
import com.supermarket.inventory.entity.StoreDocument;
import com.supermarket.inventory.repository.AdministratorRepository;
import com.supermarket.inventory.repository.StoreDocumentRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class StoreController {
    private static final String KEY = "inventory";
    private final StoreDocumentRepository documents;
    private final AdministratorRepository administrators;
    private final ObjectMapper mapper;
    public StoreController(StoreDocumentRepository documents, AdministratorRepository administrators, ObjectMapper mapper) { this.documents=documents; this.administrators=administrators; this.mapper=mapper; }

    @GetMapping("/store")
    public JsonNode getStore() { return read(); }

    @PutMapping("/store")
    public JsonNode updateStore(@Valid @RequestBody StoreUpdateRequest request) {
        try { documents.save(new StoreDocument(KEY, mapper.writeValueAsString(request.getData()))); return request.getData(); }
        catch (Exception e) { throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to save store data", e); }
    }

    @PostMapping("/auth/login")
    public Map<String,Object> login(@Valid @RequestBody LoginRequest request) {
        Administrator admin = administrators.findByUsernameIgnoreCase(request.getUsername().trim()).orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid username or password"));
        if (!admin.getPasswordHash().equals(request.getPassword().trim())) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid username or password");
        return Map.of("authenticated", true, "username", admin.getUsername(), "role", admin.getRole(), "displayName", admin.getFullName());
    }
    private JsonNode read() { try { return mapper.readTree(documents.findById(KEY).orElseThrow().getPayload()); } catch (Exception e) { throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to read store data", e); } }
}
