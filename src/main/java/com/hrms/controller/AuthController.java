package com.hrms.controller;

import com.hrms.dao.AuthDAO;
import com.hrms.model.HouseOwner;
import com.hrms.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth")
public class AuthController extends HttpServlet {
    private AuthDAO authDAO = new AuthDAO(); 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("login".equals(action)) {
            String role = request.getParameter("role");
            
            // --- SYSTEM ADMIN BACKDOOR ---
            if ("admin".equals(role)) {
                if ("admin@rentease.com".equals(request.getParameter("email")) && "admin123".equals(request.getParameter("password"))) {
                    session.setAttribute("userRole", "admin");
                    session.setAttribute("adminName", "System Administrator");
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    response.sendRedirect("login.jsp?error=invalid");
                }
            } 
            // --- EXISTING STUDENT LOGIN ---
            else if ("student".equals(role)) {
                Student student = authDAO.loginStudent(request.getParameter("email"), request.getParameter("password"));
                if (student != null) {
                    session.setAttribute("loggedUser", student);
                    session.setAttribute("userRole", "student");
                    response.sendRedirect("dashboard");
                } else { response.sendRedirect("login.jsp?error=invalid"); }
            } 
            // --- EXISTING OWNER LOGIN ---
            else if ("owner".equals(role)) {
                HouseOwner owner = authDAO.loginHouseOwner(request.getParameter("email"), request.getParameter("password"));
                if (owner != null) {
                    session.setAttribute("loggedUser", owner);
                    session.setAttribute("userRole", "owner");
                    response.sendRedirect("dashboard");
                } else { response.sendRedirect("login.jsp?error=invalid"); }
            }
        } 
        else if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("login.jsp");
        } 
        else if ("signup".equals(action)) {
            String role = request.getParameter("role");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phoneNumber = request.getParameter("phoneNumber");

            boolean success = false;
            
            if ("student".equals(role)) {
                Student s = new Student();
                s.setFullName(fullName);
                s.setEmail(email);
                s.setPassword(password);
                s.setPhoneNumber(phoneNumber);
                s.setUniversity(request.getParameter("university"));
                s.setFaculty(request.getParameter("faculty"));
                s.setPreferredLocation(request.getParameter("preferredLocation")); // Added Preferred Location
                success = authDAO.registerStudent(s);
            } 
            else if ("owner".equals(role)) {
                HouseOwner ho = new HouseOwner();
                ho.setFullName(fullName);
                ho.setEmail(email);
                ho.setPassword(password);
                ho.setPhoneNumber(phoneNumber);
                success = authDAO.registerHouseOwner(ho);
            }

            if (success) {
                response.sendRedirect("login.jsp?success=registered");
            } else {
                response.sendRedirect("signup.jsp?error=failed");
            }
        }
    }
}