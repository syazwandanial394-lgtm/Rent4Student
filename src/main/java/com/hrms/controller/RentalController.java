package com.hrms.controller;

import com.hrms.dao.RentalDAO;
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

@WebServlet("/rentalController")
public class RentalController extends HttpServlet {
    private RentalDAO rentalDAO = new RentalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Rental> rentalList = null;
        if ("student".equals(role)) {
            Student student = (Student) session.getAttribute("loggedUser");
            rentalList = rentalDAO.getRentalsByStudent(student.getStudentId());
        } else if ("owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            rentalList = rentalDAO.getRentalsByOwner(owner.getHoId());
        }

        request.setAttribute("rentalList", rentalList);
        request.getRequestDispatcher("rentals.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Action 1: Student Requests to Terminate
        if ("requestTermination".equals(action)) {
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            String reason = request.getParameter("terminationReason");
            if(rentalDAO.requestTermination(rentalId, reason)){
                response.sendRedirect("rentalController?success=term_req");
            } else {
                response.sendRedirect("rentalController?error=true");
            }
        } 
        // Action 2: Owner Approves Termination
        else if ("approveTermination".equals(action)) {
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            int propertyId = Integer.parseInt(request.getParameter("propertyId"));
            if(rentalDAO.approveTermination(rentalId, propertyId)){
                response.sendRedirect("rentalController?success=term_app");
            } else {
                response.sendRedirect("rentalController?error=true");
            }
        }
    }
}