package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Payment;
import com.hrms.model.Receipt;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean processPayment(int rentalId, double baseAmount, String paymentMethod) {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false); 
            try {
                // 1. Update Rental Status to Paid
                try (PreparedStatement ps1 = conn.prepareStatement("UPDATE rental SET payment_status = 'Paid' WHERE rental_id = ?")) {
                    ps1.setInt(1, rentalId);
                    ps1.executeUpdate();
                }

                // 2. Insert the Payment Record
                int paymentId = 0;
                String sqlPay = "INSERT INTO payment (rental_id, amount, payment_method, payment_date, payment_status) VALUES (?, ?, ?, CURDATE(), 'Completed')";
                try (PreparedStatement ps2 = conn.prepareStatement(sqlPay, Statement.RETURN_GENERATED_KEYS)) {
                    ps2.setInt(1, rentalId);
                    ps2.setDouble(2, baseAmount); 
                    ps2.setString(3, paymentMethod);
                    ps2.executeUpdate();
                    
                    try (ResultSet rs = ps2.getGeneratedKeys()) {
                        if (rs.next()) { paymentId = rs.getInt(1); }
                    }
                }

                // 3. Find the House Owner ID (Since your specific receipt table requires it)
                int hoId = 0;
                String sqlGetOwner = "SELECT p.ho_id FROM rental r JOIN property p ON r.property_id = p.property_id WHERE r.rental_id = ?";
                try (PreparedStatement psOwner = conn.prepareStatement(sqlGetOwner)) {
                    psOwner.setInt(1, rentalId);
                    try (ResultSet rsOwner = psOwner.executeQuery()) {
                        if (rsOwner.next()) {
                            hoId = rsOwner.getInt("ho_id");
                        }
                    }
                }

                // 4. Generate the Official Receipt (Matching YOUR exact database columns!)
                double totalPaid = baseAmount * 1.03; 
                String sqlRec = "INSERT INTO receipt (payment_id, ho_id, amount_paid, payment_method, issue_date, receipt_status) VALUES (?, ?, ?, ?, CURDATE(), 'Issued')";
                try (PreparedStatement ps3 = conn.prepareStatement(sqlRec)) {
                    ps3.setInt(1, paymentId);
                    ps3.setInt(2, hoId);
                    ps3.setDouble(3, totalPaid);
                    ps3.setString(4, paymentMethod); 
                    ps3.executeUpdate();
                }

                conn.commit(); 
                return true;
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
                System.out.println("PAYMENT ERROR: " + ex.getMessage());
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) { return false; }
    }

    public List<Payment> getStudentPaymentHistory(int studentId) {
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT p.payment_id, p.payment_date, pr.property_name, p.payment_status, p.amount, p.payment_method " +
                         "FROM payment p " +
                         "JOIN rental r ON p.rental_id = r.rental_id " +
                         "JOIN property pr ON r.property_id = pr.property_id " +
                         "WHERE r.student_id = ? ORDER BY p.payment_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setPaymentDate(rs.getString("payment_date"));
                p.setPropertyName(rs.getString("property_name"));
                p.setPaymentStatus(rs.getString("payment_status"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Receipt> getOwnerReceipts(int hoId) {
        List<Receipt> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT receipt_id, issue_date, payment_id, payment_method, amount_paid, receipt_status " +
                         "FROM receipt WHERE ho_id = ? ORDER BY issue_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Receipt rec = new Receipt();
                rec.setReceiptId(rs.getInt("receipt_id"));
                rec.setIssueDate(rs.getString("issue_date"));
                rec.setPaymentId(rs.getInt("payment_id"));
                rec.setPaymentMethod(rs.getString("payment_method"));
                rec.setAmountPaid(rs.getDouble("amount_paid"));
                rec.setReceiptStatus(rs.getString("receipt_status"));
                list.add(rec);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}