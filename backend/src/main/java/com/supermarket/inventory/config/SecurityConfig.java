package com.supermarket.inventory.config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import java.util.List;
@Configuration @EnableWebSecurity
public class SecurityConfig {
 @Bean SecurityFilterChain filterChain(HttpSecurity http) throws Exception { return http.csrf(c->c.disable()).cors(c->{}).authorizeHttpRequests(a->a.requestMatchers("/api/**", "/actuator/health").permitAll().anyRequest().permitAll()).build(); }
 @Bean CorsConfigurationSource corsConfigurationSource() { CorsConfiguration c=new CorsConfiguration(); c.setAllowedOrigins(List.of("http://localhost:5173","http://127.0.0.1:5173","https://inventory-management-live-wc58.onrender.com")); c.setAllowedMethods(List.of("GET","PUT","POST","DELETE","OPTIONS")); c.setAllowedHeaders(List.of("*")); UrlBasedCorsConfigurationSource s=new UrlBasedCorsConfigurationSource(); s.registerCorsConfiguration("/**",c); return s; }
}
