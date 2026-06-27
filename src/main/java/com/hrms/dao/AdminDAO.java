package com.hrms.dao;

import com.hrms.config.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    public List<Object[]> getAllUsers() {
        List<Object[]> users = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT student_id AS id, username, 'Student' AS role, account_status FROM student " +
                         "UNION " +
                         "SELECT ho_id AS id, username, 'Owner' AS role, account_status FROM house_owner " +
                         "ORDER BY role, username";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(new Object[]{rs.getInt("id"), rs.getString("username"), rs.getString("role"), rs.getString("account_status")});
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return users;
    }

    // Targets the correct table based on their role
    public boolean updateUserStatus(int userId, String role, String status) {
        String table = role.equalsIgnoreCase("Student") ? "student" : "house_owner";
        String idColumn = role.equalsIgnoreCase("Student") ? "student_id" : "ho_id";
        
        String sql = "UPDATE " + table + " SET account_status = ? WHERE " + idColumn + " = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Object[]> getAllTickets() {
        List<Object[]> tickets = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM support_tickets ORDER BY created_at DESC")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                tickets.add(new Object[]{
                    rs.getInt("ticket_id"),     
                    rs.getString("subject"),    
                    rs.getString("sender_name"),
                    rs.getString("sender_role"),
                    rs.getString("status"),     
                    rs.getString("created_at"), 
                    rs.getString("message"),    
                    rs.getString("remarks")     
                });
            }
        } catch (Exception e) { e.printStackTrace(); }
        return tickets;
    }

    public boolean resolveTicket(int ticketId, String status, String remarks) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE support_tickets SET status = ?, remarks = ? WHERE ticket_id = ?")) {
            ps.setString(1, status);
            ps.setString(2, remarks);
            ps.setInt(3, ticketId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Object[]> getActivityLogs() {
        List<Object[]> logs = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM activity_logs ORDER BY timestamp DESC")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                logs.add(new Object[]{rs.getInt("log_id"), rs.getString("admin_user"), rs.getString("action"), rs.getString("timestamp")});
            }
        } catch (Exception e) { e.printStackTrace(); }
        return logs;
    }
    public List<Object[]> getAllTransactions() {
        List<Object[]> transactions = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM payment ORDER BY payment_id DESC LIMIT 200")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Object[] txn = new Object[4];
                
                // Bulletproof fetching prevents crashes if column names differ
                try { txn[0] = rs.getString("payment_id"); } catch (Exception e) { txn[0] = "N/A"; }
                try { txn[1] = rs.getString("payment_date"); } catch (Exception e) { txn[1] = "Unknown Date"; }
                try { txn[2] = rs.getString("amount"); } catch (Exception e) { txn[2] = "0.00"; }
                try { txn[3] = rs.getString("status"); } catch (Exception e) { txn[3] = "Processed"; }
                
                transactions.add(txn);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return transactions;
    }

    // Write to Activity Log
    public void logActivity(String admin, String action) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO activity_logs (admin_user, action) VALUES (?, ?)")) {
            ps.setString(1, admin);
            ps.setString(2, action);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}