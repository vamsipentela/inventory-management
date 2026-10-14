package com.supermarket.inventory.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "store_documents")
@Getter @Setter @NoArgsConstructor
public class StoreDocument {
    @Id
    private String documentKey;
    @Lob @Column(nullable = false, columnDefinition = "CLOB")
    private String payload;
    public StoreDocument(String documentKey, String payload) { this.documentKey = documentKey; this.payload = payload; }
}
