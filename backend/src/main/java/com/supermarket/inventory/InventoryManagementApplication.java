package com.supermarket.inventory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.supermarket.inventory.entity.Administrator;
import com.supermarket.inventory.entity.StoreDocument;
import com.supermarket.inventory.repository.AdministratorRepository;
import com.supermarket.inventory.repository.StoreDocumentRepository;

@SpringBootApplication
public class InventoryManagementApplication {

    public static void main(String[] args) {
        SpringApplication.run(InventoryManagementApplication.class, args);
    }

    @Bean CommandLineRunner seed(AdministratorRepository admins, StoreDocumentRepository docs, ObjectMapper mapper) {
        return args -> {
            ensureDefaultAdmin(admins, "owner", "owner@123", "OWNER", "Store Owner", "owner@swachhmart.local");
            ensureDefaultAdmin(admins, "seller", "seller@123", "SELLER", "Sales Associate", "seller@swachhmart.local");
            if (docs.count() == 0) docs.save(new StoreDocument("inventory", "{\"products\":[{\"id\":1,\"name\":\"Amul Milk 1L\",\"sku\":\"AMUL-1L\",\"category\":\"Dairy\",\"price\":68,\"qty\":42,\"reorder\":10},{\"id\":2,\"name\":\"Tata Salt 1kg\",\"sku\":\"TATA-SALT\",\"category\":\"Groceries\",\"price\":28,\"qty\":65,\"reorder\":12},{\"id\":3,\"name\":\"Parle-G Biscuits\",\"sku\":\"PARLE-G\",\"category\":\"Snacks\",\"price\":10,\"qty\":18,\"reorder\":20}],\"categories\":[\"Groceries\",\"Beverages\",\"Dairy\",\"Snacks\",\"Personal Care\",\"Household\"],\"suppliers\":[\"ABC Wholesale\",\"Fresh Foods Distributors\",\"Daily Needs Suppliers\"],\"sales\":[{\"id\":1049,\"date\":\"Today\",\"items\":2,\"payment\":\"UPI\",\"total\":4270}]}"));
        };
    }

    private void ensureDefaultAdmin(AdministratorRepository admins, String username, String password,
                                    String role, String fullName, String email) {
        Administrator admin = admins.findByUsernameIgnoreCase(username)
                .orElseGet(() -> Administrator.builder().username(username).build());
        admin.setPasswordHash(password);
        admin.setRole(role);
        admin.setFullName(fullName);
        admin.setEmail(email);
        admins.save(admin);
    }
}
