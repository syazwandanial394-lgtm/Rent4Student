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
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM rental WHERE student_id = ? AND status != 'Terminated'");
            ps.setInt(1, studentId);
            return ps.executeQuery().next();
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Rental> getRentalsByStudent(int studentId) {
        List<Rental> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT r.*, p.property_name, s.full_name as student_name FROM rental r JOIN property p ON r.property_id = p.property_id JOIN student s ON r.student_id = s.student_id WHERE r.student_id = ? ORDER BY r.start_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(extractRental(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Rental> getRentalsByOwner(int hoId) {
        List<Rental> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT r.*, p.property_name, s.full_name as student_name FROM rental r JOIN property p ON r.property_id = p.property_id JOIN student s ON r.student_id = s.student_id WHERE p.ho_id = ? ORDER BY r.start_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(extractRental(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // THE NEW METHOD: Specifically filters out only the pending payments!
    public List<Rental> getDuePaymentsByOwner(int hoId) {
        List<Rental> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT r.*, p.property_name, s.full_name as student_name FROM rental r JOIN property p ON r.property_id = p.property_id JOIN student s ON r.student_id = s.student_id WHERE p.ho_id = ? AND r.payment_status = 'Pending' AND r.status != 'Terminated'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(extractRental(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean updatePaymentStatus(int rentalId, String status) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE rental SET payment_status = ? WHERE rental_id = ?");
            ps.setString(1, status);
            ps.setInt(2, rentalId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean requestTermination(int rentalId, String reason) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE rental SET status = 'Termination_Requested', termination_reason = ? WHERE rental_id = ?");
            ps.setString(1, reason);
            ps.setInt(2, rentalId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean approveTermination(int rentalId, int propertyId) {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                PreparedStatement ps1 = conn.prepareStatement("UPDATE rental SET status = 'Terminated' WHERE rental_id = ?");
                ps1.setInt(1, rentalId);
                ps1.executeUpdate();

                PreparedStatement ps2 = conn.prepareStatement("UPDATE property SET availability_status = 'Available' WHERE property_id = ?");
                ps2.setInt(1, propertyId);
                ps2.executeUpdate();

                conn.commit();
                return true;
            } catch (Exception ex) {
                conn.rollback(); return false;
            } finally { conn.setAutoCommit(true); }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Helper method to keep code clean
    private Rental extractRental(ResultSet rs) throws Exception {
        Rental r = new Rental();
        r.setRentalId(rs.getInt("rental_id"));
        r.setPropertyId(rs.getInt("property_id"));
        r.setStudentId(rs.getInt("student_id"));
        r.setStartDate(rs.getString("start_date"));
        r.setEndDate(rs.getString("end_date"));
        r.setRentalRate(rs.getDouble("rental_rate"));
        r.setStatus(rs.getString("status"));
        r.setPaymentStatus(rs.getString("payment_status"));
        r.setPropertyName(rs.getString("property_name"));
        r.setStudentName(rs.getString("student_name"));
        try { r.setTerminationReason(rs.getString("termination_reason")); } catch (Exception e) {}
        return r;
    }
}