package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.HouseOwner;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class HouseOwnerDAO {

    public boolean updateHouseOwnerProfile(HouseOwner o) {
        try (Connection conn = DBUtil.getConnection()) {
            // FIXED: Added username and profile_image to the UPDATE statement
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE house_owner SET username = ?, full_name = ?, email = ?, phone_number = ?, profile_image = ? WHERE ho_id = ?"
            );
            ps.setString(1, o.getUsername());
            ps.setString(2, o.getFullName());
            ps.setString(3, o.getEmail());
            ps.setString(4, o.getPhoneNumber());
            ps.setString(5, o.getProfileImage());
            ps.setInt(6, o.getHoId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSubscriptionStatus(int hoId, String status) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE house_owner SET subscription_status = ? WHERE ho_id = ?");
            ps.setString(1, status);
            ps.setInt(2, hoId);
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
                owner.setUsername(rs.getString("username")); 
                owner.setFullName(rs.getString("full_name"));
                owner.setEmail(rs.getString("email"));
                owner.setPassword(rs.getString("password"));
                owner.setPhoneNumber(rs.getString("phone_number"));
                owner.setProfileImage(rs.getString("profile_image")); 
                owner.setSubscriptionStatus(rs.getString("subscription_status"));
                owner.setRegistrationDate(rs.getString("registration_date")); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return owner;
    }

    public boolean deleteHouseOwnerAccount(int hoId) {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false); 
            try {
                PreparedStatement psReceipt = conn.prepareStatement("DELETE FROM receipt WHERE ho_id = ?");
                psReceipt.setInt(1, hoId);
                psReceipt.executeUpdate();

                PreparedStatement psPayment = conn.prepareStatement(
                    "DELETE FROM payment WHERE rental_id IN " +
                    "(SELECT rental_id FROM rental WHERE property_id IN (SELECT property_id FROM property WHERE ho_id = ?))"
                );
                psPayment.setInt(1, hoId);
                psPayment.executeUpdate();

                PreparedStatement psRental = conn.prepareStatement(
                    "DELETE FROM rental WHERE property_id IN (SELECT property_id FROM property WHERE ho_id = ?)"
                );
                psRental.setInt(1, hoId);
                psRental.executeUpdate();

                PreparedStatement psApp = conn.prepareStatement(
                    "DELETE FROM application WHERE property_id IN (SELECT property_id FROM property WHERE ho_id = ?)"
                );
                psApp.setInt(1, hoId);
                psApp.executeUpdate();

                PreparedStatement psProp = conn.prepareStatement("DELETE FROM property WHERE ho_id = ?");
                psProp.setInt(1, hoId);
                psProp.executeUpdate();

                PreparedStatement psOwner = conn.prepareStatement("DELETE FROM house_owner WHERE ho_id = ?");
                psOwner.setInt(1, hoId);
                int rowsAffected = psOwner.executeUpdate();

                conn.commit();
                return rowsAffected > 0;
                
            } catch (Exception ex) {
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