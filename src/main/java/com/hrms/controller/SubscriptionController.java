package com.hrms.controller;

import com.hrms.dao.HouseOwnerDAO;
import com.hrms.model.HouseOwner;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/subscriptionController")
public class SubscriptionController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HouseOwnerDAO houseOwnerDAO;

    public void init() {
        houseOwnerDAO = new HouseOwnerDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String hoIdParam = request.getParameter("hoId");
        
        // Safety check
        if (hoIdParam == null || hoIdParam.isEmpty() || action == null) {
            response.sendRedirect("subscribe.jsp?error=failed");
            return;
        }
        
        int hoId = Integer.parseInt(hoIdParam);
        String newStatus = "";

        // Determine the new tier based on the button clicked
        switch (action) {
            case "standard": 
                newStatus = "Standard"; 
                break;
            case "pro":      
                newStatus = "Pro"; 
                break;
            case "premium":  
                newStatus = "Premium"; 
                break;
            case "free":     
                newStatus = "Free"; // Handles the cancellation!
                break; 
            default:
                response.sendRedirect("subscribe.jsp?error=failed");
                return;
        }
        
        // Update database
        boolean isUpdated = houseOwnerDAO.updateSubscriptionStatus(hoId, newStatus);
        
        if (isUpdated) {
            // Update the live session so the UI changes immediately without requiring a relogin
            HttpSession session = request.getSession();
            HouseOwner loggedUser = (HouseOwner) session.getAttribute("loggedUser");
            if (loggedUser != null) {
                loggedUser.setSubscriptionStatus(newStatus);
            }
            
            // Send back to properties with a success alert
            response.sendRedirect("properties?success=updated");
        } else {
            response.sendRedirect("subscribe.jsp?error=failed");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("subscribe.jsp");
    }
}