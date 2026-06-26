package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.HouseOwner;
import com.hrms.model.Student;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuthDAO {
    
    public boolean registerStudent(Student s) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO student (username, full_name, email, password, phone_number, university, faculty, preferred_location, profile_image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, s.getUsername());
            ps.setString(2, s.getFullName());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getPassword());
            ps.setString(5, s.getPhoneNumber());
            ps.setString(6, s.getUniversity());
            ps.setString(7, s.getFaculty());
            ps.setString(8, s.getPreferredLocation());
            ps.setString(9, s.getProfileImage());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean registerHouseOwner(HouseOwner ho) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO house_owner (username, full_name, email, password, phone_number, profile_image) VALUES (?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, ho.getUsername());
            ps.setString(2, ho.getFullName());
            ps.setString(3, ho.getEmail());
            ps.setString(4, ho.getPassword());
            ps.setString(5, ho.getPhoneNumber());
            ps.setString(6, ho.getProfileImage());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Student loginStudent(String email, String password) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM student WHERE email = ? AND password = ?");
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Student s = new Student();
                s.setStudentId(rs.getInt("student_id"));
                s.setUsername(rs.getString("username"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
                s.setPhoneNumber(rs.getString("phone_number"));
                s.setUniversity(rs.getString("university"));
                s.setFaculty(rs.getString("faculty"));
                s.setPreferredLocation(rs.getString("preferred_location"));
                s.setProfileImage(rs.getString("profile_image"));
                return s;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public HouseOwner loginHouseOwner(String email, String password) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM house_owner WHERE email = ? AND password = ?");
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HouseOwner ho = new HouseOwner();
                ho.setHoId(rs.getInt("ho_id"));
                ho.setUsername(rs.getString("username"));
                ho.setFullName(rs.getString("full_name"));
                ho.setEmail(rs.getString("email"));
                ho.setPassword(rs.getString("password"));
                ho.setPhoneNumber(rs.getString("phone_number"));
                ho.setProfileImage(rs.getString("profile_image"));
                ho.setSubscriptionStatus(rs.getString("subscription_status"));
                return ho;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    
    public boolean updateSubscriptionStatus(int hoId, String status) {
        String sql = "UPDATE House_Owner SET subscription_status = ? WHERE ho_id = ?";
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, hoId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false;
        }
    }
}