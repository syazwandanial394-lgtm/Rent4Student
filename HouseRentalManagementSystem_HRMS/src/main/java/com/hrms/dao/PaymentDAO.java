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
    public String processPayment(Payment p) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO payment (rental_id, amount, payment_date, due_date, payment_method, payment_status) " +
                "VALUES (?, ?, NOW(), CURDATE(), ?, 'Completed')"
            );
            ps.setInt(1, p.getRentalId());
            ps.setDouble(2, p.getAmount());
            ps.setString(3, p.getPaymentMethod());
            ps.executeUpdate();
            return "success";
        } catch (Exception e) { 
            e.printStackTrace(); 
            return e.getMessage(); // Grab the MySQL Error!
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