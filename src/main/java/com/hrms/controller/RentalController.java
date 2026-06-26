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
import java.util.stream.Collectors;

@WebServlet("/rentalController")
public class RentalController extends HttpServlet {
    private RentalDAO rentalDAO = new RentalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");
        String action = request.getParameter("action"); 

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // --- DUE PAYMENTS FLOW ---
        if ("duePayments".equals(action) && "owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            List<Rental> allRentals = rentalDAO.getRentalsByOwner(owner.getHoId()); 
            
            // Only show rentals that are NOT "Paid"
            List<Rental> dueRentals = allRentals.stream()
                .filter(r -> !"Paid".equals(r.getPaymentStatus()) && !"Terminated".equals(r.getStatus()))
                .collect(Collectors.toList());
            
            request.setAttribute("dueRentals", dueRentals);
            request.getRequestDispatcher("due-payments.jsp").forward(request, response);
            return; 
        }

        // --- STANDARD ACTIVE RENTALS FLOW ---
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

        if ("requestTermination".equals(action)) {
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            String reason = request.getParameter("terminationReason");
            if(rentalDAO.requestTermination(rentalId, reason)){
                response.sendRedirect("rentalController?success=term_req");
            } else {
                response.sendRedirect("rentalController?error=true");
            }
        } 
        
        else if ("sendReminder".equals(action)) {
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            
            // 1. Actually update the database so the student receives the warning
            rentalDAO.updatePaymentStatus(rentalId, "Overdue");
            
            // 2. Redirect back
            response.sendRedirect("rentalController?action=duePayments&success=reminder_sent");
        }
        
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