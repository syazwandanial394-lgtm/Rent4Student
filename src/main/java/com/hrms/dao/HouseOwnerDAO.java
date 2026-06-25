package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.HouseOwner;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class HouseOwnerDAO {

    public boolean updateHouseOwnerProfile(HouseOwner o) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE house_owner SET full_name = ?, email = ?, phone_number = ? WHERE ho_id = ?"
            );
            ps.setString(1, o.getFullName());
            ps.setString(2, o.getEmail());
            ps.setString(3, o.getPhoneNumber());
            ps.setInt(4, o.getHoId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public HouseOwner getHouseOwnerById(int hoId) {
        HouseOwner owner = null;
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM house_owner WHERE ho_id = ?");
            ps.setInt(1, hoId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                owner = new HouseOwner();
                owner.setHoId(rs.getInt("ho_id"));
                owner.setFullName(rs.getString("full_name"));
                owner.setEmail(rs.getString("email"));
                owner.setPassword(rs.getString("password"));
                owner.setPhoneNumber(rs.getString("phone_number"));
                owner.setSubscriptionStatus(rs.getString("subscription_status"));
                owner.setRegistrationDate(rs.getString("registration_data")); // Maps column 'registration_data' to your model
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return owner;
    }

    // NEW: USE CASE 7 - SECURE ACCOUNT DELETION (LANDLORD TRANSACTION CASCADE)
    public boolean deleteHouseOwnerAccount(int hoId) {
        try (Connection conn = DBUtil.getConnection()) {
            // Turn off auto-commit so we can rollback if any constraint step fails
            conn.setAutoCommit(false); 
            try {
                // 1. Delete all receipts associated with this house owner
                PreparedStatement psReceipt = conn.prepareStatement("DELETE FROM receipt WHERE ho_id = ?");
                psReceipt.setInt(1, hoId);
                psReceipt.executeUpdate();

                // 2. Delete all payments connected to this owner's listed properties
                PreparedStatement psPayment = conn.prepareStatement(
                    "DELETE FROM payment WHERE rental_id IN " +
                    "(SELECT rental_id FROM rental WHERE property_id IN (SELECT property_id FROM property WHERE ho_id = ?))"
                );
                psPayment.setInt(1, hoId);
                psPayment.executeUpdate();

                // 3. Delete all active/historical rentals linked to this owner's properties
                PreparedStatement psRental = conn.prepareStatement(
                    "DELETE FROM rental WHERE property_id IN (SELECT property_id FROM property WHERE ho_id = ?)"
                );
                psRental.setInt(1, hoId);
                psRental.executeUpdate();

                // 4. Delete all tenant applications for this owner's properties
                PreparedStatement psApp = conn.prepareStatement(
                    "DELETE FROM application WHERE property_id IN (SELECT property_id FROM property WHERE ho_id = ?)"
                );
                psApp.setInt(1, hoId);
                psApp.executeUpdate();

                // 5. Delete all properties owned by this house owner
                PreparedStatement psProp = conn.prepareStatement("DELETE FROM property WHERE ho_id = ?");
                psProp.setInt(1, hoId);
                psProp.executeUpdate();

                // 6. Finally, delete the house owner account profile record itself
                PreparedStatement psOwner = conn.prepareStatement("DELETE FROM house_owner WHERE ho_id = ?");
                psOwner.setInt(1, hoId);
                int rowsAffected = psOwner.executeUpdate();

                // If all sequential updates and deletions succeed, write them to disk safely!
                conn.commit();
                return rowsAffected > 0;
                
            } catch (Exception ex) {
                // If any dependent block causes a database failure, abort entirely to secure data states
                conn.rollback();
                ex.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}