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
        
        // --- SECURITY: Kick out anyone who isn't an admin ---
        if (!"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        // --- ROUTING: Send admin to the correct module with data ---
        if ("manageUsers".equals(action)) {
            request.setAttribute("userList", adminDAO.getAllUsers());
            request.getRequestDispatcher("admin-users.jsp").forward(request, response);
        } 
        else if ("viewTickets".equals(action)) {
            request.setAttribute("ticketList", adminDAO.getAllTickets());
            request.getRequestDispatcher("admin-tickets.jsp").forward(request, response);
        } 
        else if ("activityLogs".equals(action)) {
            request.setAttribute("logList", adminDAO.getActivityLogs());
            request.getRequestDispatcher("admin-logs.jsp").forward(request, response);
        } 
        else if ("transactionLogs".equals(action)) {
            request.setAttribute("transactionList", adminDAO.getAllTransactions());
            request.getRequestDispatcher("admin-transactions.jsp").forward(request, response);
        }
        else {
            // Default fallback
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
            String targetRole = request.getParameter("targetRole");
            String status = request.getParameter("status");
            
            boolean success = adminDAO.updateUserStatus(userId, targetRole, status);
            
            if (success) {
                adminDAO.logActivity(adminName, "Changed " + targetRole + " (ID: " + userId + ") account status to " + status);
                response.sendRedirect("adminController?action=manageUsers&success=updated");
            } else {
                response.sendRedirect("adminController?action=manageUsers&error=failed");
            }
        }
        else if ("resolveTicket".equals(action)) {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            String ticketStatus = request.getParameter("status");
            String remarks = request.getParameter("remarks");
            
            boolean success = adminDAO.resolveTicket(ticketId, ticketStatus, remarks);
            
            if (success) {
                adminDAO.logActivity(adminName, "Resolved ticket #" + ticketId + " with status: " + ticketStatus);
                response.sendRedirect("adminController?action=viewTickets&success=resolved");
            } else {
                response.sendRedirect("adminController?action=viewTickets&error=failed");
            }
        }
    }
}