package com.quickcartapplication.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id; 


@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
public class DarkStore extends BaseEntity {

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "code", nullable = false, length = 50, unique = true)
    private String code;

    @Column(name = "address", nullable = false, length = 255)
    private String street;

    @Column(name = "city", nullable = false, length = 100)
    private String city;

    @Column(name = "pin_code", nullable = false, length = 20)
    private String pinCode;

    @Column(name = "state", nullable = false, length = 100)
    private String state;

    @Column(name = "latitude", nullable = false, precision = 10, scale = 8)
    private BigDecimal latitude;

    @Column(name = "longitude", nullable = false, precision = 11, scale = 8)
    private BigDecimal longitude;

    @Column(name = "service_radius_km", nullable = false, precision = 10, scale = 2)
    private BigDecimal serviceRadiusKm = new BigDecimal("5.0"); // Default service radius in kilometers

    @Column(name = "active", nullable = false)
    private boolean active;


    // Getters and Setters
}