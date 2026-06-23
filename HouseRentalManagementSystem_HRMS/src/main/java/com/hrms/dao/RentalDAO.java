package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Rental;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RentalDAO {

    public List<Rental> getRentalsByStudent(int studentId) {
        List<Rental> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT r.*, p.property_name, p.rental_rate, s.full_name FROM rental r " +
                "JOIN property p ON r.property_id = p.property_id " +
                "JOIN student s ON r.student_id = s.student_id " +
                "WHERE r.student_id = ?"
            );
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rental r = new Rental();
                r.setRentalId(rs.getInt("rental_id"));
                r.setPropertyName(rs.getString("property_name"));
                r.setStudentName(rs.getString("full_name"));
                r.setStartDate(rs.getString("start_date"));
                r.setRentalRate(rs.getDouble("rental_rate"));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Rental> getRentalsByOwner(int ownerId) {
        List<Rental> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT r.*, p.property_name, p.rental_rate, s.full_name FROM rental r " +
                "JOIN property p ON r.property_id = p.property_id " +
                "JOIN student s ON r.student_id = s.student_id " +
                "WHERE p.ho_id = ?"
            );
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rental r = new Rental();
                r.setRentalId(rs.getInt("rental_id"));
                r.setPropertyName(rs.getString("property_name"));
                r.setStudentName(rs.getString("full_name"));
                r.setStartDate(rs.getString("start_date"));
                r.setRentalRate(rs.getDouble("rental_rate"));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // NEW: Security method to check if a student is already renting
    public boolean hasActiveRental(int studentId) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM rental WHERE student_id = ?");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // Returns TRUE if they have a rental, FALSE if they don't
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
}