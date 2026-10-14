-- ============================================================
-- SUPERMARKET INVENTORY MANAGEMENT SYSTEM
-- Database Schema - MySQL 8.x
-- Target: 3NF Normalized Relational Design
-- ============================================================

CREATE DATABASE IF NOT EXISTS supermarket_inventory
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE supermarket_inventory;

-- ============================================================
-- 1. ADMINISTRATOR
-- ============================================================
CREATE TABLE IF NOT EXISTS administrator (
    admin_id       BIGINT AUTO_INCREMENT PRIMARY KEY,
    username       VARCHAR(50)  NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    role           VARCHAR(20)  NOT NULL DEFAULT 'ADMINISTRATOR',
    full_name      VARCHAR(100) NOT NULL,
    email          VARCHAR(100),
    contact_number VARCHAR(20),
    created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_admin_username (username)
) ENGINE=InnoDB;

-- ============================================================
-- 2. CATEGORY
-- ============================================================
CREATE TABLE IF NOT EXISTS category (
    category_id  BIGINT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    description  VARCHAR(500),
    status       VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE INDEX idx_category_name (name),
    INDEX idx_category_status (status)
) ENGINE=InnoDB;

-- ============================================================
-- 3. SUPPLIER
-- ============================================================
CREATE TABLE IF NOT EXISTS supplier (
    supplier_id    BIGINT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(150) NOT NULL,
    contact_number VARCHAR(20),
    email          VARCHAR(100),
    address        VARCHAR(500),
    status         VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_supplier_name (name),
    INDEX idx_supplier_status (status)
) ENGINE=InnoDB;

-- ============================================================
-- 4. PRODUCT
-- ============================================================
CREATE TABLE IF NOT EXISTS product (
    product_id    BIGINT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(150) NOT NULL,
    sku           VARCHAR(50)  NOT NULL UNIQUE,
    category_id   BIGINT       NOT NULL,
    unit          VARCHAR(30)  NOT NULL DEFAULT 'PCS',
    selling_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    quantity      INT          NOT NULL DEFAULT 0,
    reorder_level INT          NOT NULL DEFAULT 0,
    status        VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_selling_price CHECK (selling_price >= 0),
    CONSTRAINT chk_quantity      CHECK (quantity >= 0),
    CONSTRAINT chk_reorder_level CHECK (reorder_level >= 0),

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES category(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    UNIQUE INDEX idx_product_sku (sku),
    INDEX idx_product_name (name),
    INDEX idx_product_category (category_id),
    INDEX idx_product_status (status)
) ENGINE=InnoDB;

-- ============================================================
-- 5. STOCK_ENTRY
-- ============================================================
CREATE TABLE IF NOT EXISTS stock_entry (
    entry_id    BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id  BIGINT    NOT NULL,
    supplier_id BIGINT    NOT NULL,
    quantity    INT       NOT NULL,
    entry_date  DATE      NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_stock_quantity CHECK (quantity > 0),

    CONSTRAINT fk_stock_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_stock_supplier
        FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    INDEX idx_stock_product (product_id),
    INDEX idx_stock_supplier (supplier_id),
    INDEX idx_stock_entry_date (entry_date)
) ENGINE=InnoDB;

-- ============================================================
-- 6. SALE
-- ============================================================
CREATE TABLE IF NOT EXISTS sale (
    sale_id      BIGINT AUTO_INCREMENT PRIMARY KEY,
    sale_date    DATETIME      NOT NULL,
    total_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    payment_mode VARCHAR(20)   NOT NULL,
    status       VARCHAR(20)   NOT NULL DEFAULT 'COMPLETED',
    created_at   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_sale_date (sale_date),
    INDEX idx_sale_payment (payment_mode)
) ENGINE=InnoDB;

-- ============================================================
-- 7. SALE_ITEM
-- ============================================================
CREATE TABLE IF NOT EXISTS sale_item (
    sale_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sale_id      BIGINT        NOT NULL,
    product_id   BIGINT        NOT NULL,
    quantity     INT           NOT NULL,
    unit_price   DECIMAL(12,2) NOT NULL,
    subtotal     DECIMAL(14,2) NOT NULL,

    CONSTRAINT chk_sale_item_qty CHECK (quantity > 0),

    CONSTRAINT fk_saleitem_sale
        FOREIGN KEY (sale_id) REFERENCES sale(sale_id)
        ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT fk_saleitem_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    INDEX idx_saleitem_sale (sale_id),
    INDEX idx_saleitem_product (product_id)
) ENGINE=InnoDB;

-- ============================================================
-- 8. INVOICE
-- ============================================================
CREATE TABLE IF NOT EXISTS invoice (
    invoice_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
    sale_id        BIGINT        NOT NULL,
    invoice_number VARCHAR(50)   NOT NULL UNIQUE,
    invoice_date   DATETIME      NOT NULL,
    total_amount   DECIMAL(14,2) NOT NULL,
    created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_invoice_sale
        FOREIGN KEY (sale_id) REFERENCES sale(sale_id)
        ON UPDATE CASCADE ON DELETE CASCADE,

    UNIQUE INDEX idx_invoice_number (invoice_number),
    INDEX idx_invoice_sale (sale_id)
) ENGINE=InnoDB;

-- ============================================================
-- 9. STOCK_ALERT
-- ============================================================
CREATE TABLE IF NOT EXISTS stock_alert (
    alert_id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT      NOT NULL,
    status     VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    alert_date DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_alert_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
        ON UPDATE CASCADE ON DELETE CASCADE,

    INDEX idx_alert_product (product_id),
    INDEX idx_alert_status (status)
) ENGINE=InnoDB;
