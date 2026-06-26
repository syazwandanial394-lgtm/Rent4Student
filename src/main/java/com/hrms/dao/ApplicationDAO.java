package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Application;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public boolean createApplication(int studentId, int propertyId) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO application (student_id, property_id, application_date, status) VALUES (?, ?, NOW(), 'Pending')"
            );
            ps.setInt(1, studentId);
            ps.setInt(2, propertyId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    public String updateApplicationStatus(int applicationId, String newStatus, String remarks) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE application SET status = ?, remarks = ? WHERE application_id = ?");
            ps.setString(1, newStatus);
            ps.setString(2, remarks);
            ps.setInt(3, applicationId);
            ps.executeUpdate();
            return "success";
        } catch (Exception e) { 
            e.printStackTrace(); 
            return e.getMessage(); 
        }
    }

    public String approveAndCreateRental(int applicationId, String remarks) {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false); 

            PreparedStatement psGet = conn.prepareStatement("SELECT student_id, property_id FROM application WHERE application_id = ?");
            psGet.setInt(1, applicationId);
            ResultSet rs = psGet.executeQuery();
            if (!rs.next()) return "Application not found in database.";
            int studentId = rs.getInt("student_id");
            int propertyId = rs.getInt("property_id");

            PreparedStatement psApp = conn.prepareStatement("UPDATE application SET status = 'Approved', remarks = ? WHERE application_id = ?");
            psApp.setString(1, remarks);
            psApp.setInt(2, applicationId);
            psApp.executeUpdate();

            PreparedStatement psProp = conn.prepareStatement("UPDATE property SET availability_status = 'Unavailable' WHERE property_id = ?");
            psProp.setInt(1, propertyId);
            psProp.executeUpdate();

            // FIXED: Added the 6-Month End Date Calculation!
            PreparedStatement psRental = conn.prepareStatement(
                "INSERT INTO rental (student_id, property_id, start_date, end_date) VALUES (?, ?, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 6 MONTH))"
            );
            psRental.setInt(1, studentId);
            psRental.setInt(2, propertyId);
            psRental.executeUpdate();

            conn.commit(); 
            return "success";
        } catch (Exception e) { 
            e.printStackTrace(); 
            return e.getMessage(); 
        }
    }

    public List<Application> getStudentApplications(int studentId) {
        List<Application> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT a.*, p.property_name FROM application a JOIN property p ON a.property_id = p.property_id WHERE a.student_id = ?");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application app = new Application();
                app.setApplicationId(rs.getInt("application_id"));
                app.setPropertyId(rs.getInt("property_id"));
                app.setApplicationDate(rs.getString("application_date"));
                
                app.setStatus(rs.getString("status"));
                app.setPropertyName(rs.getString("property_name"));
                app.setRemarks(rs.getString("remarks")); 
                
                list.add(app);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Application> getOwnerApplications(int ownerId) {
        List<Application> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT a.*, p.property_name, s.full_name FROM application a " +
                "JOIN property p ON a.property_id = p.property_id JOIN student s ON a.student_id = s.student_id WHERE p.ho_id = ?"
            );
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application app = new Application();
                app.setApplicationId(rs.getInt("application_id"));
                app.setPropertyId(rs.getInt("property_id"));
                app.setApplicationDate(rs.getString("application_date"));
                
                app.setStatus(rs.getString("status"));
                app.setPropertyName(rs.getString("property_name"));
                app.setStudentName(rs.getString("full_name"));
                app.setRemarks(rs.getString("remarks"));
                
                list.add(app);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
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
}