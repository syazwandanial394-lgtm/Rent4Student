package com.hrms.controller;

import com.hrms.config.DBUtil;
import com.hrms.dao.ReportDAO;
import com.hrms.model.AdminReport;
import com.hrms.model.Student;
import com.hrms.model.HouseOwner;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

@WebServlet("/reportController")
public class ReportController extends HttpServlet {
    private ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("viewTickets".equals(action)) {
            String username = "";
            if ("student".equals(role)) {
                Student s = (Student) session.getAttribute("loggedUser");
                username = s.getUsername();
            } else if ("owner".equals(role)) {
                HouseOwner ho = (HouseOwner) session.getAttribute("loggedUser");
                username = ho.getUsername();
            }

            // FIXED: Fetch tickets using Username instead of Email
            List<AdminReport> tickets = reportDAO.getReportsByUsername(username);
            request.setAttribute("ticketList", tickets);
            request.getRequestDispatcher("tickets.jsp").forward(request, response);
        } else {
            response.sendRedirect("dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("submitTicket".equals(action)) {
            // Grab the hidden inputs from the JSP
            String username = request.getParameter("username");
            String role = request.getParameter("role");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message"); 

            try (Connection conn = DBUtil.getConnection()) {
                // FIXED: Insert into the correct table (support_tickets) matching the Admin portal
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO support_tickets (sender_name, sender_role, subject, message) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, username);
                ps.setString(2, role);
                ps.setString(3, subject);
                ps.setString(4, message);
                ps.executeUpdate();
                
                response.sendRedirect("reportController?action=viewTickets&success=created");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("reportController?action=viewTickets&error=true");
            }
        } else {
            response.sendRedirect("dashboard");
        }
    }
}