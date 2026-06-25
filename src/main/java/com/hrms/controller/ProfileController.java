package com.hrms.controller;

import com.hrms.dao.StudentDAO;
import com.hrms.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/profileController")
public class ProfileController extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("student".equals(role)) {
            Student currentSessionStudent = (Student) session.getAttribute("loggedUser");
            Student freshDbStudent = studentDAO.getStudentById(currentSessionStudent.getStudentId());
            if (freshDbStudent != null) {
                session.setAttribute("loggedUser", freshDbStudent);
            }
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");
        String action = request.getParameter("action");

        if ("student".equals(role)) {
            Student student = (Student) session.getAttribute("loggedUser");

            // NEW: USE CASE 7 - Handle Account Deletion
            if ("deleteAccount".equals(action)) {
                if (studentDAO.deleteStudentAccount(student.getStudentId())) {
                    session.invalidate(); // Destroy the session (logout)
                    response.sendRedirect("login.jsp?success=deleted"); // Redirect to login
                    return;
                } else {
                    response.sendRedirect("profileController?error=delete_failed");
                    return;
                }
            }

            // Normal Profile Update Logic
            student.setUsername(request.getParameter("username"));
            student.setFullName(request.getParameter("fullName"));
            student.setEmail(request.getParameter("email"));
            student.setPhoneNumber(request.getParameter("phoneNumber"));
            student.setUniversity(request.getParameter("university"));
            student.setPreferredLocation(request.getParameter("preferredLocation"));
            student.setFaculty(request.getParameter("faculty"));

            if (studentDAO.updateStudentProfile(student)) {
                session.setAttribute("loggedUser", student);
                response.sendRedirect("profileController?success=true");
            } else {
                response.sendRedirect("profileController?error=true");
            }
        }
        
        if ("owner".equals(role))  {
            
        }
    }
}