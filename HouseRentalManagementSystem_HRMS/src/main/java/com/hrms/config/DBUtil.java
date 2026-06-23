package com.hrms.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Ensure this matches your phpMyAdmin database name exactly
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/hrms_db", "root", "");
    }
}