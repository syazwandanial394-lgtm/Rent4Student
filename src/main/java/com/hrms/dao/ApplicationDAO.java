package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Application;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public boolean applyForProperty(int studentId, int propertyId) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO application (student_id, property_id, application_date, status) VALUES (?, ?, CURDATE(), 'Pending')"
            );
            ps.setInt(1, studentId);
            ps.setInt(2, propertyId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Integer> getPendingProperties(int studentId) {
        List<Integer> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT property_id FROM application WHERE student_id = ? AND status = 'Pending'");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("property_id"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Application> getApplicationsByStudent(int studentId) {
        List<Application> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT a.*, p.property_name, s.full_name as student_name " +
                         "FROM application a " +
                         "JOIN property p ON a.property_id = p.property_id " +
                         "JOIN student s ON a.student_id = s.student_id " +
                         "WHERE a.student_id = ? ORDER BY a.application_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application app = new Application();
                app.setApplicationId(rs.getInt("application_id"));
                app.setStudentId(rs.getInt("student_id"));
                app.setPropertyId(rs.getInt("property_id"));
                app.setApplicationDate(rs.getString("application_date"));
                app.setStatus(rs.getString("status"));
                app.setRemarks(rs.getString("remarks"));
                app.setPropertyName(rs.getString("property_name"));
                app.setStudentName(rs.getString("student_name"));
                list.add(app);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Application> getApplicationsByOwner(int hoId) {
        List<Application> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT a.*, p.property_name, s.full_name as student_name " +
                         "FROM application a " +
                         "JOIN property p ON a.property_id = p.property_id " +
                         "JOIN student s ON a.student_id = s.student_id " +
                         "WHERE p.ho_id = ? ORDER BY a.application_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application app = new Application();
                app.setApplicationId(rs.getInt("application_id"));
                app.setStudentId(rs.getInt("student_id"));
                app.setPropertyId(rs.getInt("property_id"));
                app.setApplicationDate(rs.getString("application_date"));
                app.setStatus(rs.getString("status"));
                app.setRemarks(rs.getString("remarks"));
                app.setPropertyName(rs.getString("property_name"));
                app.setStudentName(rs.getString("student_name"));
                list.add(app);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public String updateApplicationStatus(int applicationId, String status, String remarks) {
        if (remarks == null) remarks = ""; 

        try (Connection conn = DBUtil.getConnection()) {
            
            if ("Approved".equals(status)) {
                int studentId = 0;
                int propertyId = 0;
                double rentalRate = 0.0;

                try (PreparedStatement psData = conn.prepareStatement("SELECT student_id, property_id FROM application WHERE application_id = ?")) {
                    psData.setInt(1, applicationId);
                    try (ResultSet rsData = psData.executeQuery()) {
                        if (rsData.next()) {
                            studentId = rsData.getInt("student_id");
                            propertyId = rsData.getInt("property_id");
                        } else {
                            return "Error: Could not find application ID in database."; 
                        }
                    }
                }

                try (PreparedStatement psRate = conn.prepareStatement("SELECT rental_rate FROM property WHERE property_id = ?")) {
                    psRate.setInt(1, propertyId);
                    try (ResultSet rsRate = psRate.executeQuery()) {
                        if (rsRate.next()) {
                            rentalRate = rsRate.getDouble("rental_rate");
                        }
                    }
                }

                conn.setAutoCommit(false); 
                
                try {
                    try (PreparedStatement psApp = conn.prepareStatement("UPDATE application SET status = ?, remarks = ? WHERE application_id = ?")) {
                        psApp.setString(1, status);
                        psApp.setString(2, remarks);
                        psApp.setInt(3, applicationId);
                        psApp.executeUpdate();
                    }

                    try (PreparedStatement psRent = conn.prepareStatement(
                        "INSERT INTO rental (student_id, property_id, start_date, rental_rate, status, payment_status) " +
                        "VALUES (?, ?, CURDATE(), ?, 'Active', 'Pending')"
                    )) {
                        psRent.setInt(1, studentId);
                        psRent.setInt(2, propertyId);
                        psRent.setDouble(3, rentalRate);
                        psRent.executeUpdate();
                    }

                    try (PreparedStatement psProp = conn.prepareStatement("UPDATE property SET availability_status = 'Unavailable' WHERE property_id = ?")) {
                        psProp.setInt(1, propertyId);
                        psProp.executeUpdate();
                    }

                    try (PreparedStatement psReject = conn.prepareStatement("UPDATE application SET status = 'Rejected', remarks = 'Property has been rented to another student.' WHERE property_id = ? AND application_id != ? AND status = 'Pending'")) {
                        psReject.setInt(1, propertyId);
                        psReject.setInt(2, applicationId);
                        psReject.executeUpdate();
                    }

                    conn.commit(); 
                    return "success";
                    
                } catch (Exception ex) {
                    conn.rollback(); 
                    return "SQL Error: " + ex.getMessage();
                } finally {
                    conn.setAutoCommit(true); 
                }
            } 
            else {
                try (PreparedStatement ps = conn.prepareStatement("UPDATE application SET status = ?, remarks = ? WHERE application_id = ?")) {
                    ps.setString(1, status);
                    ps.setString(2, remarks);
                    ps.setInt(3, applicationId);
                    return ps.executeUpdate() > 0 ? "success" : "Database update failed.";
                }
            }
        } catch (Exception e) {
            return "Connection Error: " + e.getMessage();
        }
    }
}