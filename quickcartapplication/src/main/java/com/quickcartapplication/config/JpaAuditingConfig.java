package com.quickcartapplication.config;

import java.beans.BeanProperty;
import java.util.Optional;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.AuditorAware;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder; 

@Configuration
@EnableJpaAuditing(
        auditorAwareRef = "auditorAware"
)
public class JpaAuditingConfig {

    @Bean
    public AuditorAware<String> auditorProvider() {
        return () -> {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated()) {
                return Optional.of(Constants.SYSTEM_AUDITOR);
            }
            return Optional.of(authentication.getName());
        };
    }
}