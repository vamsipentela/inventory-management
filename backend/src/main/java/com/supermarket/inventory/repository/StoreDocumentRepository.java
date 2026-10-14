package com.supermarket.inventory.repository;
import com.supermarket.inventory.entity.StoreDocument;
import org.springframework.data.jpa.repository.JpaRepository;
public interface StoreDocumentRepository extends JpaRepository<StoreDocument, String> {}
