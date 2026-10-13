package com.quickcartapplication.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;

@Entity
@Table(name = "addresses")
@Getter
@Setter
@NoArgsConstructor
public class Address extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "street", nullable = false, length = 255)
    private String street;

    @Column(name = "city", nullable = false, length = 100)
    private String city;

    @Column(name = "state", nullable = false, length = 100)
    private String state;

    @Column(name = "zip_code", nullable = false, length = 20)
    private String zipCode;

    @Column(name = "label", nullable = true, length = 100)
    private String label;

    @Column(name = "landmark", nullable = true, length = 255)
    private String landmark;

    @Column(name = "latitude", nullable = true, precision = 10, scale = 8)
    private BigDecimal latitude;

    @Column(name = "longitude", nullable = true, precision = 11, scale = 8)
    private BigDecimal longitude;

    @Column(name = "is_default", nullable = false)
    private boolean isDefault;

    // Getters and Setters
}