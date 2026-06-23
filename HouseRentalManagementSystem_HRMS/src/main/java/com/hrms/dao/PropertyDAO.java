package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Property;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PropertyDAO {

    // Fetch ALL properties (For Students)
    public List<Property> getAllProperties() {
        List<Property> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM Property");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Property p = new Property();
                p.setPropertyId(rs.getInt("property_id"));
                p.setPropertyName(rs.getString("property_name"));
                p.setPropertyType(rs.getString("property_type"));
                p.setAddress(rs.getString("address"));
                p.setDescription(rs.getString("description"));
                p.setRentalRate(rs.getDouble("rental_rate"));
                p.setCity(rs.getString("city"));
                p.setPostcode(rs.getString("postcode"));
                p.setHoId(rs.getInt("ho_id"));
                p.setAvailabilityStatus(rs.getString("availability_status"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Fetch ONLY properties owned by a specific owner (For House Owners)
    public List<Property> getPropertiesByOwner(int hoId) {
        List<Property> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM Property WHERE ho_id = ?");
            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Property p = new Property();
                p.setPropertyId(rs.getInt("property_id"));
                p.setPropertyName(rs.getString("property_name"));
                p.setPropertyType(rs.getString("property_type"));
                p.setAddress(rs.getString("address"));
                p.setDescription(rs.getString("description"));
                p.setRentalRate(rs.getDouble("rental_rate"));
                p.setCity(rs.getString("city"));
                p.setPostcode(rs.getString("postcode"));
                p.setHoId(rs.getInt("ho_id"));
                p.setAvailabilityStatus(rs.getString("availability_status"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}