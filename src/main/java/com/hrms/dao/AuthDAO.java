package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.HouseOwner;
import com.hrms.model.Student;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuthDAO {

    public Student loginStudent(String email, String password) {
        Student student = null;
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM Student WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return student;
    }

    public HouseOwner loginHouseOwner(String email, String password) {
        HouseOwner owner = null;
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM House_Owner WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                owner = new HouseOwner();
                owner.setHoId(rs.getInt("ho_id"));
                owner.setFullName(rs.getString("full_name"));
                owner.setEmail(rs.getString("email"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return owner;
    }

    public boolean registerStudent(Student s) {
        try (Connection conn = DBUtil.getConnection()) {
            // Updated to include preferred_location
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO Student (full_name, email, password, phone_number, university, faculty, preferred_location) VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getPassword());
            ps.setString(4, s.getPhoneNumber());
            ps.setString(5, s.getUniversity());
            ps.setString(6, s.getFaculty());
            ps.setString(7, s.getPreferredLocation());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    public boolean registerHouseOwner(HouseOwner ho) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO House_Owner (full_name, email, password, phone_number) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, ho.getFullName());
            ps.setString(2, ho.getEmail());
            ps.setString(3, ho.getPassword());
            ps.setString(4, ho.getPhoneNumber());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
}