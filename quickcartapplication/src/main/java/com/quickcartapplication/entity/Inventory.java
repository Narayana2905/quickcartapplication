package com.quickcartapplication.entity;

import javax.annotation.processing.SupportedSourceVersion;

@Entity
@Table(name = "inventory",
        uniqueConstraints = @UniqueConstraint(name = "uk_inventory_store_product", columnNames = {"dark_store_id", "product_id"})
)
@Getter
@Setter
@NoArgsConstructor
public class Inventory extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "dark_store_id", nullable = false)
    private DarkStore darkStore;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(name = "quantity", nullable = false)
    private int quantity;

    @Column(name = "reserved_quantity", nullable = false)
    private int reservedQuantity;

    @Column(name = "low_stock_threshold", nullable = false)
    private int lowStockThreshold = 5;

    @Version
    @Column(name = "version", nullable = false)
    private int version;

    public int getAvailableQuantity() {
        return quantity - reservedQuantity;
    }

    // Getters and Setters
}