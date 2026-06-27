package com.hrms.controller;

import com.hrms.dao.ReportDAO;
import com.hrms.model.HouseOwner;
import com.hrms.model.Student;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reportController")
public class ReportController extends HttpServlet {
    private ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");
        
        if (role == null || "admin".equals(role)) { response.sendRedirect("login.jsp"); return; }

        // Figure out exactly who is logged in
        String username = "";
        if ("student".equals(role)) {
            Student s = (Student) session.getAttribute("loggedUser");
            username = s.getUsername();
        } else if ("owner".equals(role)) {
            HouseOwner ho = (HouseOwner) session.getAttribute("loggedUser");
            username = ho.getUsername();
        }

        String action = request.getParameter("action");
        
        if ("viewTickets".equals(action)) {
            request.setAttribute("ticketList", reportDAO.getTicketsByUser(username));
            request.getRequestDispatcher("tickets.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("submitTicket".equals(action)) {
            String username = request.getParameter("username");
            String role = request.getParameter("role");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            
            reportDAO.createTicket(username, role, subject, message);
            response.sendRedirect("reportController?action=viewTickets&success=created");
        }
    }
}