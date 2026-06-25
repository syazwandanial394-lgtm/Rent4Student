package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Receipt;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReceiptDAO {

    // --------------------------------------------------------
    // Updated method in com.hrms.dao.ReceiptDAO
    // --------------------------------------------------------
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
                
                // Keep these aligned with your updated database columns
                r.setReceiptStatus(rs.getString("receipt_status")); 
                r.setPaymentId(rs.getInt("payment_id"));            
                
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}