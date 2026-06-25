package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Rental;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RentalDAO {

    public boolean hasActiveRental(int studentId) {
        boolean hasRental = false;
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM rental WHERE student_id = ? AND (status != 'Terminated' OR status IS NULL)");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { hasRental = true; }
        } catch (Exception e) { e.printStackTrace(); }
        return hasRental;
    }

    public List<Rental> getRentalsByStudent(int studentId) {
        List<Rental> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT r.*, p.property_name, p.rental_rate, s.full_name " +
                "FROM rental r " +
                "JOIN property p ON r.property_id = p.property_id " +
                "JOIN student s ON r.student_id = s.student_id " +
                "WHERE r.student_id = ? AND (r.status != 'Terminated' OR r.status IS NULL)"
            );
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rental r = new Rental();
                r.setRentalId(rs.getInt("rental_id"));
                r.setPropertyId(rs.getInt("property_id"));
                r.setStudentId(rs.getInt("student_id"));
                r.setPropertyName(rs.getString("property_name"));
                r.setStudentName(rs.getString("full_name"));
                r.setStartDate(rs.getString("start_date"));
                
                // QOL Item 1 & 8: Fetch end date
                r.setEndDate(rs.getString("end_date")); 
                
                r.setRentalRate(rs.getDouble("rental_rate")); 
                
                String dbStatus = rs.getString("status");
                r.setStatus(dbStatus == null ? "Active" : dbStatus);
                r.setTerminationReason(rs.getString("termination_reason"));
                
                list.add(r);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    public List<Rental> getRentalsByOwner(int hoId) {
        List<Rental> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT r.*, p.property_name, p.rental_rate, s.full_name " +
                "FROM rental r " +
                "JOIN property p ON r.property_id = p.property_id " +
                "JOIN student s ON r.student_id = s.student_id " +
                "WHERE p.ho_id = ? AND (r.status != 'Terminated' OR r.status IS NULL)"
            );
            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rental r = new Rental();
                r.setRentalId(rs.getInt("rental_id"));
                r.setPropertyId(rs.getInt("property_id"));
                r.setStudentId(rs.getInt("student_id"));
                r.setPropertyName(rs.getString("property_name"));
                r.setStudentName(rs.getString("full_name"));
                r.setStartDate(rs.getString("start_date"));
                
                // QOL Item 1 & 8: Fetch end date
                r.setEndDate(rs.getString("end_date")); 
                
                r.setRentalRate(rs.getDouble("rental_rate")); 
                
                String dbStatus = rs.getString("status");
                r.setStatus(dbStatus == null ? "Active" : dbStatus);
                r.setTerminationReason(rs.getString("termination_reason"));
                
                list.add(r);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // 1. STUDENT REQUESTS TERMINATION
    public boolean requestTermination(int rentalId, String reason) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE rental SET status = 'Termination_Requested', termination_reason = ? WHERE rental_id = ?");
            ps.setString(1, reason);
            ps.setInt(2, rentalId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. OWNER APPROVES TERMINATION (Frees up the property!)
    public boolean approveTermination(int rentalId, int propertyId) {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false); 
            try {
                // Terminate the rental
                PreparedStatement ps1 = conn.prepareStatement("UPDATE rental SET status = 'Terminated' WHERE rental_id = ?");
                ps1.setInt(1, rentalId);
                ps1.executeUpdate();

                // Make the property available again
                PreparedStatement ps2 = conn.prepareStatement("UPDATE property SET availability_status = 'Available' WHERE property_id = ?");
                ps2.setInt(1, propertyId);
                ps2.executeUpdate();

                conn.commit();
                return true;
            } catch(Exception ex) {
                conn.rollback();
                ex.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}