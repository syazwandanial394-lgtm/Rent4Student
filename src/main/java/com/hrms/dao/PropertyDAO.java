package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Property;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PropertyDAO {

    public boolean addProperty(Property p) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO property (ho_id, property_name, property_type, description, address, city, postcode, rental_rate, availability_status, property_image) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Available', ?)"
            );
            ps.setInt(1, p.getHoId());
            ps.setString(2, p.getPropertyName());
            ps.setString(3, p.getPropertyType());
            ps.setString(4, p.getDescription());
            ps.setString(5, p.getAddress());
            ps.setString(6, p.getCity());
            ps.setString(7, p.getPostcode());
            ps.setDouble(8, p.getRentalRate());
            ps.setString(9, p.getPropertyImage()); 
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateProperty(Property property) {
        boolean rowUpdated = false;
        String sql = "UPDATE property SET property_name = ?, property_type = ?, address = ?, description = ?, rental_rate = ?, availability_status = ?, city = ?, postcode = ?, property_image = COALESCE(?, property_image) WHERE property_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, property.getPropertyName());
            ps.setString(2, property.getPropertyType());
            ps.setString(3, property.getAddress());
            ps.setString(4, property.getDescription());
            ps.setDouble(5, property.getRentalRate());
            ps.setString(6, property.getAvailabilityStatus());
            ps.setString(7, property.getCity());
            ps.setString(8, property.getPostcode());
            ps.setString(9, property.getPropertyImage()); 
            ps.setInt(10, property.getPropertyId());

            rowUpdated = ps.executeUpdate() > 0;
            
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return rowUpdated;
    }

    public List<Property> getAllProperties() {
        List<Property> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM property");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Property p = new Property();
                p.setPropertyId(rs.getInt("property_id"));
                p.setPropertyName(rs.getString("property_name"));
                p.setPropertyType(rs.getString("property_type")); 
                p.setAddress(rs.getString("address"));
                p.setDescription(rs.getString("description"));   
                p.setCity(rs.getString("city"));
                p.setPostcode(rs.getString("postcode"));
                p.setRentalRate(rs.getDouble("rental_rate"));
                p.setAvailabilityStatus(rs.getString("availability_status"));
                p.setPropertyImage(rs.getString("property_image"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Property> getPropertiesByOwner(int hoId) {
        List<Property> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM property WHERE ho_id = ?");
            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Property p = new Property();
                p.setPropertyId(rs.getInt("property_id"));
                p.setPropertyName(rs.getString("property_name"));
                p.setPropertyType(rs.getString("property_type"));
                p.setAddress(rs.getString("address"));
                p.setDescription(rs.getString("description"));
                p.setCity(rs.getString("city"));
                p.setPostcode(rs.getString("postcode"));
                p.setRentalRate(rs.getDouble("rental_rate"));
                p.setAvailabilityStatus(rs.getString("availability_status"));
                p.setPropertyImage(rs.getString("property_image"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Property> searchProperties(String location, Double maxPrice, String houseType) {
        List<Property> list = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM property WHERE 1=1");
        
        if (location != null && !location.trim().isEmpty()) {
            query.append(" AND city LIKE ?");
        }
        if (maxPrice != null && maxPrice > 0) {
            query.append(" AND rental_rate <= ?");
        }
        if (houseType != null && !houseType.trim().isEmpty() && !"Any".equalsIgnoreCase(houseType)) {
            query.append(" AND property_type = ?");
        }
        
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(query.toString());
            int paramIndex = 1;
            
            if (location != null && !location.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + location.trim() + "%");
            }
            if (maxPrice != null && maxPrice > 0) {
                ps.setDouble(paramIndex++, maxPrice);
            }
            if (houseType != null && !houseType.trim().isEmpty() && !"Any".equalsIgnoreCase(houseType)) {
                ps.setString(paramIndex++, houseType);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Property p = new Property();
                p.setPropertyId(rs.getInt("property_id"));
                p.setPropertyName(rs.getString("property_name"));
                p.setPropertyType(rs.getString("property_type"));
                p.setAddress(rs.getString("address"));
                p.setDescription(rs.getString("description"));
                p.setCity(rs.getString("city"));
                p.setPostcode(rs.getString("postcode"));
                p.setRentalRate(rs.getDouble("rental_rate"));
                p.setAvailabilityStatus(rs.getString("availability_status"));
                p.setPropertyImage(rs.getString("property_image"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalPropertiesByOwner(int hoId) {
        int totalCount = 0;
        String sql = "SELECT COUNT(*) FROM property WHERE ho_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                totalCount = rs.getInt(1); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalCount;
    }
    
    public boolean deleteProperty(int propertyId) {
        String sql = "DELETE FROM property WHERE property_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, propertyId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error deleting property: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    // NEW METHODS FOR QoL PROPERTY REPORT
    // ==========================================

    // Fetch a single property details
    public Property getPropertyById(int id) {
        Property p = null;
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM property WHERE property_id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                p = new Property();
                p.setPropertyId(rs.getInt("property_id"));
                p.setPropertyName(rs.getString("property_name"));
                p.setPropertyType(rs.getString("property_type"));
                p.setAddress(rs.getString("address"));
                p.setDescription(rs.getString("description"));
                p.setCity(rs.getString("city"));
                p.setPostcode(rs.getString("postcode"));
                p.setRentalRate(rs.getDouble("rental_rate"));
                p.setAvailabilityStatus(rs.getString("availability_status"));
                p.setPropertyImage(rs.getString("property_image"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return p;
    }

    // Calculate Total Revenue for a single property
    public double getTotalRevenueForProperty(int propertyId) {
        double total = 0.0;
        try (Connection conn = DBUtil.getConnection();
             // We removed the strict 'status' check to ensure NO payments are accidentally hidden.
             // As long as the payment is linked to the rental, it will be counted!
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT SUM(amount) AS total_revenue FROM payment WHERE rental_id IN (SELECT rental_id FROM rental WHERE property_id = ?)"
             )) {
            ps.setInt(1, propertyId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // We use getDouble, but if SUM returns NULL (no payments), it safely defaults to 0.0
                total = rs.getDouble("total_revenue");
            }
        } catch (Exception e) { 
            System.out.println("=== SQL ERROR IN REVENUE CALCULATION ===");
            System.out.println(e.getMessage());
        }
        return total;
    }

    // Count Total Unique Tenants for a single property
    public int getTotalTenantsForProperty(int propertyId) {
        int count = 0;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 // FIXED: Changed 'rentals' to 'rental'
                 "SELECT COUNT(DISTINCT student_id) AS total_tenants FROM rental WHERE property_id = ?"
             )) {
            ps.setInt(1, propertyId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total_tenants");
            }
        } catch (Exception e) { 
            System.out.println("=== SQL ERROR IN TENANT COUNT ===");
            System.out.println(e.getMessage());
        }
        return count;
    
    }
}