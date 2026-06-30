package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.AdminReport;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {
    
    // FIXED: Query support_tickets by sender_name (username)
    public List<AdminReport> getReportsByUsername(String username) {
        List<AdminReport> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM support_tickets WHERE sender_name = ? ORDER BY created_at DESC"
            );
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdminReport r = new AdminReport();
                // We map the support_tickets columns to your AdminReport object!
                r.setReportId(rs.getInt("ticket_id"));
                r.setUserEmail(rs.getString("sender_name")); 
                r.setUserRole(rs.getString("sender_role"));
                r.setSubject(rs.getString("subject"));
                r.setDescription(rs.getString("message"));
                r.setStatus(rs.getString("status"));
                r.setSubmittedAt(rs.getString("created_at"));
                r.setAdminResponse(rs.getString("remarks"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // FIXED: Read all tickets from the correct table
    public List<AdminReport> getAllReports() {
        List<AdminReport> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM support_tickets ORDER BY created_at DESC"
            );
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdminReport r = new AdminReport();
                r.setReportId(rs.getInt("ticket_id"));
                r.setUserEmail(rs.getString("sender_name"));
                r.setUserRole(rs.getString("sender_role"));
                r.setSubject(rs.getString("subject"));
                r.setDescription(rs.getString("message"));
                r.setStatus(rs.getString("status"));
                r.setSubmittedAt(rs.getString("created_at"));
                r.setAdminResponse(rs.getString("remarks"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // FIXED: Ensure any updates hit the right table
    public boolean updateReportResponse(int reportId, String responseText) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE support_tickets SET remarks = ?, status = 'Resolved' WHERE ticket_id = ?"
            );
            ps.setString(1, responseText);
            ps.setInt(2, reportId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}