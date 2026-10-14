-- ============================================================
-- QuickCart: initial schema (PostgreSQL)
-- ============================================================

CREATE TABLE roles (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(30) NOT NULL UNIQUE,
    created_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id             BIGSERIAL PRIMARY KEY,
    full_name      VARCHAR(100) NOT NULL,
    email          VARCHAR(150) NOT NULL UNIQUE,
    phone          VARCHAR(20)  UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    active         BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
    user_id  BIGINT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    role_id  BIGINT NOT NULL REFERENCES roles (id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE addresses (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    label       VARCHAR(30),
    street      VARCHAR(255)   NOT NULL,
    landmark    VARCHAR(255),
    city        VARCHAR(80)    NOT NULL,
    state       VARCHAR(80)    NOT NULL,
    pincode     VARCHAR(10)    NOT NULL,
    latitude    NUMERIC(10, 7),
    longitude   NUMERIC(10, 7),
    is_default  BOOLEAN        NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_addresses_user ON addresses (user_id);

CREATE TABLE refresh_tokens (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT       NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    token       VARCHAR(512) NOT NULL UNIQUE,
    expires_at  TIMESTAMP    NOT NULL,
    revoked     BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_refresh_tokens_user ON refresh_tokens (user_id);

CREATE TABLE dark_stores (
    id                 BIGSERIAL PRIMARY KEY,
    name               VARCHAR(120)  NOT NULL,
    code               VARCHAR(30)   NOT NULL UNIQUE,
    street             VARCHAR(255)  NOT NULL,
    city               VARCHAR(80)   NOT NULL,
    pincode            VARCHAR(10)   NOT NULL,
    latitude           NUMERIC(10, 7),
    longitude          NUMERIC(10, 7),
    service_radius_km  NUMERIC(5, 2) NOT NULL DEFAULT 5.00,
    active             BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_dark_stores_pincode ON dark_stores (pincode);

CREATE TABLE categories (
    id           BIGSERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    slug         VARCHAR(120) NOT NULL UNIQUE,
    description  VARCHAR(500),
    image_url    VARCHAR(500),
    active       BOOLEAN      NOT NULL DEFAULT TRUE,
    parent_id    BIGINT       REFERENCES categories (id) ON DELETE SET NULL,
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_categories_parent ON categories (parent_id);

CREATE TABLE products (
    id           BIGSERIAL PRIMARY KEY,
    sku          VARCHAR(50)    NOT NULL UNIQUE,
    name         VARCHAR(200)   NOT NULL,
    brand        VARCHAR(100),
    description  VARCHAR(2000),
    image_url    VARCHAR(500),
    unit         VARCHAR(40),
    mrp          NUMERIC(12, 2) NOT NULL,
    price        NUMERIC(12, 2) NOT NULL,
    active       BOOLEAN        NOT NULL DEFAULT TRUE,
    category_id  BIGINT         NOT NULL REFERENCES categories (id),
    created_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_products_price CHECK (price >= 0 AND mrp >= price)
);
CREATE INDEX idx_products_category_name ON products (category_id, name);
CREATE INDEX idx_products_active ON products (active);

CREATE TABLE inventory (
    id                   BIGSERIAL PRIMARY KEY,
    dark_store_id        BIGINT    NOT NULL REFERENCES dark_stores (id) ON DELETE CASCADE,
    product_id           BIGINT    NOT NULL REFERENCES products (id) ON DELETE CASCADE,
    quantity             INTEGER   NOT NULL DEFAULT 0,
    reserved_quantity    INTEGER   NOT NULL DEFAULT 0,
    low_stock_threshold  INTEGER   NOT NULL DEFAULT 5,
    version              BIGINT    NOT NULL DEFAULT 0,
    created_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_inventory_store_product UNIQUE (dark_store_id, product_id),
    CONSTRAINT chk_inventory_quantity CHECK (quantity >= 0),
    CONSTRAINT chk_inventory_reserved CHECK (reserved_quantity >= 0 AND reserved_quantity <= quantity)
);
CREATE INDEX idx_inventory_store_product ON inventory (dark_store_id, product_id);
CREATE INDEX idx_inventory_product ON inventory (product_id);

CREATE TABLE carts (
    id             BIGSERIAL PRIMARY KEY,
    user_id        BIGINT    NOT NULL UNIQUE REFERENCES users (id) ON DELETE CASCADE,
    dark_store_id  BIGINT    REFERENCES dark_stores (id) ON DELETE SET NULL,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cart_items (
    id          BIGSERIAL PRIMARY KEY,
    cart_id     BIGINT         NOT NULL REFERENCES carts (id) ON DELETE CASCADE,
    product_id  BIGINT         NOT NULL REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER        NOT NULL,
    unit_price  NUMERIC(12, 2) NOT NULL,
    created_at  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_cart_item_cart_product UNIQUE (cart_id, product_id),
    CONSTRAINT chk_cart_items_quantity CHECK (quantity > 0)
);
CREATE INDEX idx_cart_items_cart ON cart_items (cart_id);

CREATE TABLE delivery_partners (
    id                 BIGSERIAL PRIMARY KEY,
    user_id            BIGINT        NOT NULL UNIQUE REFERENCES users (id) ON DELETE CASCADE,
    dark_store_id      BIGINT        REFERENCES dark_stores (id) ON DELETE SET NULL,
    vehicle_number     VARCHAR(30),
    status             VARCHAR(20)   NOT NULL DEFAULT 'AVAILABLE',
    current_latitude   NUMERIC(10, 7),
    current_longitude  NUMERIC(10, 7),
    created_at         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_delivery_partners_store_status ON delivery_partners (dark_store_id, status);

CREATE TABLE orders (
    id                          BIGSERIAL PRIMARY KEY,
    order_number                VARCHAR(40)    NOT NULL UNIQUE,
    user_id                     BIGINT         NOT NULL REFERENCES users (id),
    dark_store_id               BIGINT         NOT NULL REFERENCES dark_stores (id),
    address_id                  BIGINT         REFERENCES addresses (id) ON DELETE SET NULL,
    delivery_address            VARCHAR(600)   NOT NULL,
    delivery_partner_id         BIGINT         REFERENCES delivery_partners (id) ON DELETE SET NULL,
    status                      VARCHAR(30)    NOT NULL DEFAULT 'PLACED',
    subtotal                    NUMERIC(12, 2) NOT NULL DEFAULT 0,
    delivery_fee                NUMERIC(12, 2) NOT NULL DEFAULT 0,
    discount                    NUMERIC(12, 2) NOT NULL DEFAULT 0,
    total_amount                NUMERIC(12, 2) NOT NULL DEFAULT 0,
    estimated_delivery_minutes  INTEGER,
    notes                       VARCHAR(500),
    placed_at                   TIMESTAMP      NOT NULL,
    delivered_at                TIMESTAMP,
    created_at                  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_orders_user_created ON orders (user_id, created_at DESC);
CREATE INDEX idx_orders_status ON orders (status);
CREATE INDEX idx_orders_store_status ON orders (dark_store_id, status);
CREATE INDEX idx_orders_partner ON orders (delivery_partner_id);

CREATE TABLE order_items (
    id            BIGSERIAL PRIMARY KEY,
    order_id      BIGINT         NOT NULL REFERENCES orders (id) ON DELETE CASCADE,
    product_id    BIGINT         NOT NULL REFERENCES products (id),
    product_name  VARCHAR(200)   NOT NULL,
    unit_price    NUMERIC(12, 2) NOT NULL,
    quantity      INTEGER        NOT NULL,
    total_price   NUMERIC(12, 2) NOT NULL,
    created_at    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_order_items_quantity CHECK (quantity > 0)
);
CREATE INDEX idx_order_items_order ON order_items (order_id);
CREATE INDEX idx_order_items_product ON order_items (product_id);

CREATE TABLE order_status_history (
    id          BIGSERIAL PRIMARY KEY,
    order_id    BIGINT       NOT NULL REFERENCES orders (id) ON DELETE CASCADE,
    status      VARCHAR(30)  NOT NULL,
    remarks     VARCHAR(300),
    changed_by  VARCHAR(150),
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_order_status_history_order ON order_status_history (order_id, created_at);

CREATE TABLE payments (
    id               BIGSERIAL PRIMARY KEY,
    order_id         BIGINT         NOT NULL UNIQUE REFERENCES orders (id) ON DELETE CASCADE,
    method           VARCHAR(20)    NOT NULL,
    status           VARCHAR(20)    NOT NULL DEFAULT 'PENDING',
    amount           NUMERIC(12, 2) NOT NULL,
    transaction_id   VARCHAR(100)   UNIQUE,
    idempotency_key  VARCHAR(100)   UNIQUE,
    failure_reason   VARCHAR(300),
    paid_at          TIMESTAMP,
    created_at       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_payments_status ON payments (status);