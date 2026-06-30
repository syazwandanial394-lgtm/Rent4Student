package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Receipt;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReceiptDAO {
    
    public List<Receipt> getReceipts() {
        List<Receipt> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            ResultSet rs = conn.prepareStatement("SELECT * FROM receipt ORDER BY issue_date DESC").executeQuery();
            while (rs.next()) {
                Receipt r = new Receipt();
                r.setReceiptId(rs.getInt("receipt_id"));
                r.setAmountPaid(rs.getDouble("amount_paid"));
                r.setIssueDate(rs.getString("issue_date"));
                r.setPaymentMethod(rs.getString("payment_method"));
                r.setReceiptStatus(rs.getString("receipt_status")); 
                r.setPaymentId(rs.getInt("payment_id"));            
                r.setHoId(rs.getInt("ho_id"));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    
    public List<Receipt> getReceiptsByOwner(int hoId) {
        List<Receipt> list = new ArrayList<>();
        
        // THE MULTI-JOIN SQL QUERY
        // This links Receipt -> Payment -> Rental -> Property & Student
        String sql = "SELECT rec.*, prop.property_name, s.full_name AS tenant_name " +
                     "FROM receipt rec " +
                     "JOIN payment p ON rec.payment_id = p.payment_id " +
                     "JOIN rental r ON p.rental_id = r.rental_id " +
                     "JOIN property prop ON r.property_id = prop.property_id " +
                     "JOIN student s ON r.student_id = s.student_id " +
                     "WHERE rec.ho_id = ? ORDER BY rec.issue_date DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Receipt r = new Receipt();
                r.setReceiptId(rs.getInt("receipt_id"));
                r.setAmountPaid(rs.getDouble("amount_paid"));
                r.setIssueDate(rs.getString("issue_date"));
                r.setPaymentMethod(rs.getString("payment_method"));
                r.setReceiptStatus(rs.getString("receipt_status")); 
                r.setPaymentId(rs.getInt("payment_id"));            
                r.setHoId(rs.getInt("ho_id"));
                
                // Set the new QoL fields!
                r.setPropertyName(rs.getString("property_name"));
                r.setTenantName(rs.getString("tenant_name"));
                
                list.add(r);
            }
        } catch (Exception e) { 
            System.out.println("=== SQL ERROR IN GET RECEIPTS BY OWNER ===");
            System.out.println(e.getMessage());
            e.printStackTrace(); 
        }
        return list;
    }
}