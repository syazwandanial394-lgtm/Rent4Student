package com.hrms.controller;

import com.hrms.dao.RentalDAO;
import com.hrms.model.HouseOwner;
import com.hrms.model.Student;
import com.hrms.model.Rental;
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

        if (role == null) { response.sendRedirect("login.jsp"); return; }

        String action = request.getParameter("action");

        // ROUTE 1: DUE PAYMENTS PAGE
        if ("duePayments".equals(action) && "owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            List<Rental> dueList = rentalDAO.getDuePaymentsByOwner(owner.getHoId());
            request.setAttribute("rentalList", dueList);
            request.getRequestDispatcher("due-payments.jsp").forward(request, response);
        } 
        // ROUTE 2: ACTIVE RENTALS PAGE (Default)
        else {
            List<Rental> rList = null;
            if ("student".equals(role)) {
                Student student = (Student) session.getAttribute("loggedUser");
                rList = rentalDAO.getRentalsByStudent(student.getStudentId());
            } else if ("owner".equals(role)) {
                HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
                rList = rentalDAO.getRentalsByOwner(owner.getHoId());
            }
            request.setAttribute("rentalList", rList);
            request.getRequestDispatcher("rentals.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("requestTermination".equals(action)) {
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            String reason = request.getParameter("terminationReason");
            rentalDAO.requestTermination(rentalId, reason);
            response.sendRedirect("rentalController?success=term_req");
        } 
        else if ("approveTermination".equals(action)) {
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            int propertyId = Integer.parseInt(request.getParameter("propertyId"));
            rentalDAO.approveTermination(rentalId, propertyId);
            response.sendRedirect("rentalController?success=term_app");
        }
        else if ("sendReminder".equals(action)) {
            response.sendRedirect("rentalController?action=duePayments&success=reminderSent");
        }
    }
}