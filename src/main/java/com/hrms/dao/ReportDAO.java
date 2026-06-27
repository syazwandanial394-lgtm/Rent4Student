package com.hrms.dao;

import com.hrms.config.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    public List<Object[]> getTicketsByUser(String username) {
        List<Object[]> tickets = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM support_tickets WHERE sender_name = ? ORDER BY created_at DESC")) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                tickets.add(new Object[]{
                    rs.getInt("ticket_id"),     
                    rs.getString("subject"),    
                    rs.getString("message"),    
                    rs.getString("status"),     
                    rs.getString("created_at"), 
                    rs.getString("remarks")     
                });
            }
        } catch (Exception e) { e.printStackTrace(); }
        return tickets;
    }

    public boolean createTicket(String username, String role, String subject, String message) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO support_tickets (sender_name, sender_role, subject, message) VALUES (?, ?, ?, ?)")) {
            ps.setString(1, username);
            ps.setString(2, role);
            ps.setString(3, subject);
            ps.setString(4, message);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}