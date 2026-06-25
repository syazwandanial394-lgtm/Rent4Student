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
            ResultSet rs = conn.prepareStatement("SELECT * FROM Receipt").executeQuery();
            while (rs.next()) {
                Receipt r = new Receipt();
                r.setReceiptId(rs.getInt("receipt_id"));
                r.setAmountPaid(rs.getDouble("amount_paid"));
                r.setIssueDate(rs.getString("issue_date"));
                r.setPaymentMethod(rs.getString("payment_method"));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}