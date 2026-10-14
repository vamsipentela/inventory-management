package com.supermarket.inventory.dto.request;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
@Data public class StoreUpdateRequest { @NotNull private JsonNode data; }
