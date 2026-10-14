-- ============================================================
-- QuickCart: seed data
-- ============================================================

-- Roles
INSERT INTO roles (name) VALUES
    ('ROLE_USER'),
    ('ROLE_ADMIN'),
    ('ROLE_DELIVERY');

-- Dark store
INSERT INTO dark_stores (name, code, street, city, pincode, latitude, longitude, service_radius_km, active)
VALUES ('QuickCart Hitech City', 'HYD-001', 'Plot 12, Madhapur Main Road', 'Hyderabad', '500081', 17.4504000, 78.3808000, 5.00, TRUE);

-- Top-level categories
INSERT INTO categories (name, slug, description, image_url, active) VALUES
    ('Fruits & Vegetables', 'fruits-vegetables', 'Fresh fruits and vegetables', NULL, TRUE),
    ('Dairy, Bread & Eggs', 'dairy-bread-eggs', 'Milk, curd, bread, eggs and more', NULL, TRUE),
    ('Snacks & Munchies', 'snacks-munchies', 'Chips, biscuits and namkeen', NULL, TRUE),
    ('Beverages', 'beverages', 'Juices, soft drinks, tea and coffee', NULL, TRUE),
    ('Atta, Rice & Dal', 'atta-rice-dal', 'Staples and pulses', NULL, TRUE);

-- Sub-categories
INSERT INTO categories (name, slug, description, active, parent_id) VALUES
    ('Fresh Fruits', 'fresh-fruits', 'Seasonal fruits', TRUE, (SELECT id FROM categories WHERE slug = 'fruits-vegetables')),
    ('Fresh Vegetables', 'fresh-vegetables', 'Daily fresh vegetables', TRUE, (SELECT id FROM categories WHERE slug = 'fruits-vegetables')),
    ('Milk & Curd', 'milk-curd', 'Milk, curd and buttermilk', TRUE, (SELECT id FROM categories WHERE slug = 'dairy-bread-eggs')),
    ('Bread & Eggs', 'bread-eggs', 'Bread, buns and eggs', TRUE, (SELECT id FROM categories WHERE slug = 'dairy-bread-eggs'));

-- Products
INSERT INTO products (sku, name, brand, description, unit, mrp, price, active, category_id) VALUES
    ('FRT-APL-001', 'Royal Gala Apple', 'Fresh', 'Crisp and sweet Royal Gala apples', '4 pcs (approx. 500 g)', 150.00, 129.00, TRUE, (SELECT id FROM categories WHERE slug = 'fresh-fruits')),
    ('FRT-BAN-001', 'Robusta Banana', 'Fresh', 'Farm fresh Robusta bananas', '6 pcs (approx. 700 g)', 60.00, 52.00, TRUE, (SELECT id FROM categories WHERE slug = 'fresh-fruits')),
    ('VEG-TOM-001', 'Tomato (Hybrid)', 'Fresh', 'Fresh hybrid tomatoes', '500 g', 30.00, 24.00, TRUE, (SELECT id FROM categories WHERE slug = 'fresh-vegetables')),
    ('VEG-ONI-001', 'Onion', 'Fresh', 'Fresh red onions', '1 kg', 45.00, 38.00, TRUE, (SELECT id FROM categories WHERE slug = 'fresh-vegetables')),
    ('VEG-POT-001', 'Potato', 'Fresh', 'Fresh potatoes', '1 kg', 40.00, 34.00, TRUE, (SELECT id FROM categories WHERE slug = 'fresh-vegetables')),
    ('DAI-MLK-001', 'Toned Milk', 'Heritage', 'Pasteurised toned milk', '500 ml', 30.00, 29.00, TRUE, (SELECT id FROM categories WHERE slug = 'milk-curd')),
    ('DAI-CRD-001', 'Fresh Curd', 'Heritage', 'Thick and creamy curd', '400 g', 45.00, 42.00, TRUE, (SELECT id FROM categories WHERE slug = 'milk-curd')),
    ('BRD-WHT-001', 'White Bread', 'Modern', 'Soft sandwich white bread', '400 g', 45.00, 40.00, TRUE, (SELECT id FROM categories WHERE slug = 'bread-eggs')),
    ('EGG-WHT-001', 'Farm Eggs', 'Eggoz', 'Farm fresh white eggs', '6 pcs', 60.00, 54.00, TRUE, (SELECT id FROM categories WHERE slug = 'bread-eggs')),
    ('SNK-CHP-001', 'Classic Salted Potato Chips', 'Lays', 'Crispy salted potato chips', '52 g', 20.00, 20.00, TRUE, (SELECT id FROM categories WHERE slug = 'snacks-munchies')),
    ('SNK-BIS-001', 'Good Day Butter Cookies', 'Britannia', 'Butter cookies', '216 g', 40.00, 36.00, TRUE, (SELECT id FROM categories WHERE slug = 'snacks-munchies')),
    ('BEV-COL-001', 'Cola Soft Drink', 'Coca-Cola', 'Chilled cola soft drink', '750 ml', 40.00, 38.00, TRUE, (SELECT id FROM categories WHERE slug = 'beverages')),
    ('BEV-TEA-001', 'Premium Tea Powder', 'Tata Tea', 'Premium leaf tea', '250 g', 140.00, 125.00, TRUE, (SELECT id FROM categories WHERE slug = 'beverages')),
    ('STP-ATA-001', 'Whole Wheat Atta', 'Aashirvaad', 'Whole wheat flour', '5 kg', 290.00, 262.00, TRUE, (SELECT id FROM categories WHERE slug = 'atta-rice-dal')),
    ('STP-RIC-001', 'Sona Masoori Rice', 'India Gate', 'Premium Sona Masoori rice', '5 kg', 420.00, 389.00, TRUE, (SELECT id FROM categories WHERE slug = 'atta-rice-dal'));

-- Inventory: stock every product in the seeded dark store
INSERT INTO inventory (dark_store_id, product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT ds.id, p.id, 100, 0, 10
FROM dark_stores ds
CROSS JOIN products p
WHERE ds.code = 'HYD-001';