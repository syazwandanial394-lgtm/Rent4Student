package com.hrms.controller;

import com.hrms.dao.ReceiptDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/receipt")
public class ReceiptController extends HttpServlet {
    private ReceiptDAO receiptDAO = new ReceiptDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch all receipts
        request.setAttribute("receiptList", receiptDAO.getReceipts());
        request.getRequestDispatcher("receipts.jsp").forward(request, response);
    }
}