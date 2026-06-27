package com.hrms.controller;

import com.hrms.dao.RentalDAO;
import com.hrms.dao.StudentDAO;
import com.hrms.model.HouseOwner;
import com.hrms.model.Rental;
import com.hrms.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    private RentalDAO rentalDAO = new RentalDAO();
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
            Student sessionStudent = (Student) session.getAttribute("loggedUser");
            Student freshStudent = studentDAO.getStudentById(sessionStudent.getStudentId());
            if (freshStudent != null) {
                session.setAttribute("loggedUser", freshStudent);
                sessionStudent = freshStudent; 
            }

            // Check for active rentals to display on the dashboard
            List<Rental> rentals = rentalDAO.getRentalsByStudent(sessionStudent.getStudentId());
            if (rentals != null && !rentals.isEmpty()) {
                request.setAttribute("activeRental", rentals.get(0));
            }
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}