package com.supermarket.inventory.repository;
import com.supermarket.inventory.entity.Administrator;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
public interface AdministratorRepository extends JpaRepository<Administrator, Long> { Optional<Administrator> findByUsernameIgnoreCase(String username); }
