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
                "INSERT INTO property (ho_id, property_name, property_type, description, address, city, postcode, rental_rate, availability_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Available')"
            );
            ps.setInt(1, p.getHoId());
            ps.setString(2, p.getPropertyName());
            ps.setString(3, p.getPropertyType());
            ps.setString(4, p.getDescription());
            ps.setString(5, p.getAddress());
            ps.setString(6, p.getCity());
            ps.setString(7, p.getPostcode());
            ps.setDouble(8, p.getRentalRate());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
                p.setDescription(rs.getString("description"));   
                p.setCity(rs.getString("city"));
                p.setPostcode(rs.getString("postcode"));
                p.setRentalRate(rs.getDouble("rental_rate"));
                p.setAvailabilityStatus(rs.getString("availability_status"));
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
                p.setDescription(rs.getString("description"));
                p.setCity(rs.getString("city"));
                p.setPostcode(rs.getString("postcode"));
                p.setRentalRate(rs.getDouble("rental_rate"));
                p.setAvailabilityStatus(rs.getString("availability_status"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // QOL ITEM 4: Added houseType to parameters
    public List<Property> searchProperties(String location, Double maxPrice, String houseType) {
        List<Property> list = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM property WHERE 1=1");
        
        if (location != null && !location.trim().isEmpty()) {
            query.append(" AND city LIKE ?");
        }
        if (maxPrice != null && maxPrice > 0) {
            query.append(" AND rental_rate <= ?");
        }
        // QOL ITEM 4: Filter by Property Type in the SQL query
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
                p.setDescription(rs.getString("description"));
                p.setCity(rs.getString("city"));
                p.setPostcode(rs.getString("postcode"));
                p.setRentalRate(rs.getDouble("rental_rate"));
                p.setAvailabilityStatus(rs.getString("availability_status"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}