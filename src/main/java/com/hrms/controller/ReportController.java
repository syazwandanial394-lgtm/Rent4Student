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
            String email = "";
            if ("student".equals(role)) {
                Student s = (Student) session.getAttribute("loggedUser");
                email = s.getEmail();
            } else if ("owner".equals(role)) {
                HouseOwner ho = (HouseOwner) session.getAttribute("loggedUser");
                email = ho.getEmail();
            }

            // Fetch tickets and forward to JSP
            List<AdminReport> tickets = reportDAO.getReportsByEmail(email);
            request.setAttribute("ticketList", tickets);
            request.getRequestDispatcher("tickets.jsp").forward(request, response);
        } else {
            response.sendRedirect("dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("submitReport".equals(action)) {
            String email = request.getParameter("userEmail");
            String role = request.getParameter("userRole");
            String subject = request.getParameter("subject");
            String description = request.getParameter("description");

            try (Connection conn = DBUtil.getConnection()) {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO admin_report (user_email, user_role, subject, description) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, email);
                ps.setString(2, role);
                ps.setString(3, subject);
                ps.setString(4, description);
                ps.executeUpdate();
                
                // Redirect to the tickets page so they can see their new submission
                response.sendRedirect("reportController?action=viewTickets&success=true");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("reportController?action=viewTickets&error=true");
            }
        }
    }
}