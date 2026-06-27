package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.AdminReport;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {
    
    // Method 1: Fetch reports for a specific user (Used by Student/House Owner)
    public List<AdminReport> getReportsByEmail(String email) {
        List<AdminReport> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM admin_report WHERE user_email = ? ORDER BY submitted_at DESC"
            );
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdminReport r = new AdminReport();
                r.setReportId(rs.getInt("report_id"));
                r.setUserEmail(rs.getString("user_email"));
                r.setUserRole(rs.getString("user_role"));
                r.setSubject(rs.getString("subject"));
                r.setDescription(rs.getString("description"));
                r.setStatus(rs.getString("status"));
                r.setSubmittedAt(rs.getString("submitted_at"));
                r.setAdminResponse(rs.getString("admin_response"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Method 2: Fetch ALL reports (Used by Admin Dashboard)
    public List<AdminReport> getAllReports() {
        List<AdminReport> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM admin_report ORDER BY submitted_at DESC"
            );
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdminReport r = new AdminReport();
                r.setReportId(rs.getInt("report_id"));
                r.setUserEmail(rs.getString("user_email"));
                r.setUserRole(rs.getString("user_role"));
                r.setSubject(rs.getString("subject"));
                r.setDescription(rs.getString("description"));
                r.setStatus(rs.getString("status"));
                r.setSubmittedAt(rs.getString("submitted_at"));
                r.setAdminResponse(rs.getString("admin_response"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Method 3: Update a report with Admin's response
    public boolean updateReportResponse(int reportId, String responseText) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE admin_report SET admin_response = ?, status = 'Resolved' WHERE report_id = ?"
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