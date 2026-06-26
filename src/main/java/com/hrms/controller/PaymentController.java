package com.hrms.controller;

import com.hrms.dao.RentalDAO;
import com.hrms.dao.PaymentDAO;
import com.hrms.model.Student;
import com.hrms.model.HouseOwner;
import com.hrms.model.Rental;
import com.hrms.model.Payment;
import com.hrms.model.Receipt;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/paymentController")
public class PaymentController extends HttpServlet {
    private RentalDAO rentalDAO = new RentalDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("student".equals(role)) {
            Student student = (Student) session.getAttribute("loggedUser");

            // Fetch active rentals for payment dropdown
            List<Rental> allRentals = rentalDAO.getRentalsByStudent(student.getStudentId());
            List<Rental> activeRentals = allRentals.stream()
                .filter(r -> !"Terminated".equals(r.getStatus()))
                .collect(Collectors.toList());
            request.setAttribute("activeRentals", activeRentals);

            // Fetch completed payment history
            List<Payment> paymentHistory = paymentDAO.getStudentPaymentHistory(student.getStudentId());
            request.setAttribute("paymentHistory", paymentHistory);

            request.getRequestDispatcher("payments.jsp").forward(request, response);
        } 
        else if ("owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            
            // Fetch the revenue receipts for the owner
            List<Receipt> receiptList = paymentDAO.getOwnerReceipts(owner.getHoId());
            request.setAttribute("receiptList", receiptList);
            
            request.getRequestDispatcher("receipts.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("payRent".equals(action)) {
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String paymentMethod = request.getParameter("paymentMethod");
            
            // Process the payment
            boolean success = paymentDAO.processPayment(rentalId, amount, paymentMethod);
            
            if (success) {
                response.sendRedirect("paymentController?success=true");
            } else {
                response.sendRedirect("paymentController?error=Transaction+Failed");
            }
        }
    }
}