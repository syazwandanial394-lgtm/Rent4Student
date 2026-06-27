package com.hrms.controller;

import com.hrms.dao.AdminDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/adminController")
public class AdminController extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (!"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("manageUsers".equals(action)) {
            request.setAttribute("userList", adminDAO.getAllUsers());
            request.getRequestDispatcher("admin-users.jsp").forward(request, response);
        } else if ("viewTickets".equals(action)) {
            request.setAttribute("ticketList", adminDAO.getAllTickets());
            request.getRequestDispatcher("admin-tickets.jsp").forward(request, response);
        } else if ("activityLogs".equals(action)) {
            request.setAttribute("logList", adminDAO.getActivityLogs());
            request.getRequestDispatcher("admin-logs.jsp").forward(request, response);
        } else {
            response.sendRedirect("admin-dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String adminName = (String) session.getAttribute("adminName");
        
        if ("updateStatus".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String targetRole = request.getParameter("targetRole"); // Tells us if it's a student or owner
            String status = request.getParameter("status"); // 'Active', 'Blocked', 'Terminated'
            
            boolean success = adminDAO.updateUserStatus(userId, targetRole, status);
            
            if (success) {
                adminDAO.logActivity(adminName, "Changed " + targetRole + " (ID: " + userId + ") status to " + status);
                response.sendRedirect("adminController?action=manageUsers&success=updated");
            } else {
                response.sendRedirect("adminController?action=manageUsers&error=failed");
            }
        }
    }
}