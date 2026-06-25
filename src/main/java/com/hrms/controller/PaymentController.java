package com.hrms.controller;

import com.hrms.dao.PaymentDAO;
import com.hrms.dao.RentalDAO;
import com.hrms.model.Student;
import com.hrms.model.Payment;
import com.hrms.model.Rental;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/paymentController")
public class PaymentController extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();
    private RentalDAO rentalDAO = new RentalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null || !"student".equals(role)) { 
            response.sendRedirect("login.jsp"); return; 
        }

        Student student = (Student) session.getAttribute("loggedUser");
        
        List<Rental> activeRentals = rentalDAO.getRentalsByStudent(student.getStudentId());
        List<Payment> paymentHistory = paymentDAO.getStudentPayments(student.getStudentId());

        request.setAttribute("activeRentals", activeRentals);
        request.setAttribute("paymentHistory", paymentHistory);
        request.getRequestDispatcher("payments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("payRent".equals(action)) {
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            double baseAmount = Double.parseDouble(request.getParameter("amount"));
            String method = request.getParameter("paymentMethod");

            // QOL ITEM 9: Add 3% Service Fee and round to 2 decimal places
            double totalAmountWithFee = baseAmount + (baseAmount * 0.03);
            totalAmountWithFee = Math.round(totalAmountWithFee * 100.0) / 100.0;

            Payment p = new Payment();
            p.setRentalId(rentalId);
            p.setAmount(totalAmountWithFee); // Save the total including fee
            p.setPaymentMethod(method);
            
            // Catch the response
            String result = paymentDAO.processPayment(p);

            if ("success".equals(result)) {
                response.sendRedirect("paymentController?success=true");
            } else {
                // Send the exact error message to the screen!
                response.sendRedirect("paymentController?error=" + java.net.URLEncoder.encode(result, "UTF-8"));
            }
        }
    }
}