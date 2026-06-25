package com.hrms.dao;

import com.hrms.config.DBUtil;
import com.hrms.model.Student;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StudentDAO {

    public boolean updateStudentProfile(Student s) {
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE student SET username = ?, full_name = ?, email = ?, phone_number = ?, university = ?, preferred_location = ?, faculty = ? WHERE student_id = ?"
            );
            ps.setString(1, s.getUsername());
            ps.setString(2, s.getFullName());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getPhoneNumber());
            ps.setString(5, s.getUniversity());
            ps.setString(6, s.getPreferredLocation());
            ps.setString(7, s.getFaculty());
            ps.setInt(8, s.getStudentId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Student getStudentById(int studentId) {
        Student student = null;
        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM student WHERE student_id = ?");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setUsername(rs.getString("username"));
                student.setPassword(rs.getString("password"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setPhoneNumber(rs.getString("phone_number"));
                student.setUniversity(rs.getString("university"));
                student.setPreferredLocation(rs.getString("preferred_location"));
                student.setFaculty(rs.getString("faculty"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return student;
    }

    // NEW: USE CASE 7 - SECURE ACCOUNT DELETION
    public boolean deleteStudentAccount(int studentId) {
        try (Connection conn = DBUtil.getConnection()) {
            // Turn off auto-commit so we can cancel if anything fails
            conn.setAutoCommit(false); 
            try {
                // 1. Free up any properties this student was actively renting
                PreparedStatement psFreeProp = conn.prepareStatement(
                    "UPDATE property SET availability_status = 'Available' " +
                    "WHERE property_id IN (SELECT property_id FROM rental WHERE student_id = ? AND (status != 'Terminated' OR status IS NULL))"
                );
                psFreeProp.setInt(1, studentId);
                psFreeProp.executeUpdate();

                // 2. Delete all their applications
                PreparedStatement psApp = conn.prepareStatement("DELETE FROM application WHERE student_id = ?");
                psApp.setInt(1, studentId);
                psApp.executeUpdate();

                // 3. Delete all their rentals
                PreparedStatement psRent = conn.prepareStatement("DELETE FROM rental WHERE student_id = ?");
                psRent.setInt(1, studentId);
                psRent.executeUpdate();

                // 4. Finally, delete the student profile
                PreparedStatement psStud = conn.prepareStatement("DELETE FROM student WHERE student_id = ?");
                psStud.setInt(1, studentId);
                int rowsAffected = psStud.executeUpdate();

                // If everything succeeds, commit the changes permanently!
                conn.commit();
                return rowsAffected > 0;
                
            } catch (Exception ex) {
                // If anything fails, rollback the entire transaction so the DB isn't corrupted
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