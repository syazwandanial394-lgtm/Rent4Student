package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Payment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    // CHANGED TO STRING: Now returns the exact error if it crashes
// --------------------------------------------------------
    // Replace processPayment in com.hrms.dao.PaymentDAO
    // --------------------------------------------------------
    public String processPayment(Payment p) {
        String sqlPayment = "INSERT INTO payment (rental_id, amount, payment_date, due_date, payment_method, payment_status) " +
                            "VALUES (?, ?, NOW(), CURDATE(), ?, 'Completed')";
                            
        String sqlReceipt = "INSERT INTO receipt (issue_date, amount_paid, receipt_status, payment_method, payment_id) " +
                            "VALUES (NOW(), ?, 'Issued', ?, ?)";

        // Try-with-resources automatically closes the connection when done
        try (Connection conn = DBUtil.getConnection()) {
            // Disable auto-commit to control the transaction manually
            conn.setAutoCommit(false); 

            try {
                // 1. Insert Payment and request the auto-generated primary key
                PreparedStatement psPayment = conn.prepareStatement(sqlPayment, java.sql.Statement.RETURN_GENERATED_KEYS);
                psPayment.setInt(1, p.getRentalId());
                psPayment.setDouble(2, p.getAmount());
                psPayment.setString(3, p.getPaymentMethod());
                psPayment.executeUpdate();

                // 2. Fetch the newly created payment_id
                int generatedPaymentId = 0;
                try (ResultSet rsKeys = psPayment.getGeneratedKeys()) {
                    if (rsKeys.next()) {
                        generatedPaymentId = rsKeys.getInt(1);
                    } else {
                        throw new java.sql.SQLException("Payment processing failed; could not obtain payment ID.");
                    }
                }

                // 3. Generate Receipt right after using that payment_id
                PreparedStatement psReceipt = conn.prepareStatement(sqlReceipt);
                psReceipt.setDouble(1, p.getAmount());
                psReceipt.setString(2, p.getPaymentMethod());
                psReceipt.setInt(3, generatedPaymentId);
                psReceipt.executeUpdate();

                // If both operations succeed, commit them together to the database
                conn.commit();
                return "success";

            } catch (Exception transactionEx) {
                // Rollback any partial database modifications if an error occurs
                conn.rollback();
                throw transactionEx; 
            }

        } catch (Exception e) { 
            e.printStackTrace(); 
            return e.getMessage();
        }
    }

    public List<Payment> getStudentPayments(int studentId) {
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT pay.*, p.property_name FROM payment pay " +
                "JOIN rental r ON pay.rental_id = r.rental_id " +
                "JOIN property p ON r.property_id = p.property_id " +
                "WHERE r.student_id = ? ORDER BY pay.payment_date DESC"
            );
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payment pay = new Payment();
                pay.setPaymentId(rs.getInt("payment_id"));
                pay.setRentalId(rs.getInt("rental_id"));
                pay.setAmount(rs.getDouble("amount"));
                pay.setPaymentDate(rs.getString("payment_date"));
                pay.setDueDate(rs.getString("due_date"));
                pay.setPaymentMethod(rs.getString("payment_method"));
                pay.setPaymentStatus(rs.getString("payment_status"));
                pay.setPropertyName(rs.getString("property_name"));
                list.add(pay);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}