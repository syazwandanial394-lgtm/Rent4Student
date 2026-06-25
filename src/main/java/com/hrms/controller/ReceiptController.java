package com.hrms.controller;

import com.hrms.dao.ReceiptDAO;
import com.hrms.model.HouseOwner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/receipt")
public class ReceiptController extends HttpServlet {
    private ReceiptDAO receiptDAO = new ReceiptDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");
        
        // Intercept House Owners and pipe their specific receipts instead
        if ("owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            request.setAttribute("receiptList", receiptDAO.getReceiptsByOwner(owner.getHoId()));
            request.getRequestDispatcher("receipts.jsp").forward(request, response);
            return; // Stops execution here so it doesn't run the admin code below
        }

        // Fetch all receipts
        if ("admin".equals(role)) {
            request.setAttribute("receiptList", receiptDAO.getReceipts());
            request.getRequestDispatcher("receipts.jsp").forward(request, response);
        }
    }
}