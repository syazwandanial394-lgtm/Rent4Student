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
    
    // FIXED: Changed from AuthDAO to HouseOwnerDAO
    private HouseOwnerDAO houseOwnerDAO;

    public void init() {
        houseOwnerDAO = new HouseOwnerDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String hoIdParam = request.getParameter("hoId");
        switch (action) {
            case "standard":
               
                if (hoIdParam != null && !hoIdParam.isEmpty()) {
                    int hoId = Integer.parseInt(hoIdParam);

                    // 1. Trigger the DAO method to update the column in phpMyAdmin to 'Premium'
                    boolean isUpdated = houseOwnerDAO.updateSubscriptionStatus(hoId, "Standard");

                    if (isUpdated) {
                        // 2. VERY IMPORTANT: Update the current session object 
                        // So the application immediately recognizes them as Premium without logging out
                        HttpSession session = request.getSession();
                        HouseOwner loggedUser = (HouseOwner) session.getAttribute("loggedUser");

                        if (loggedUser != null) {
                            loggedUser.setSubscriptionStatus("Standard");
                        }

                        // 3. Redirect them back to their properties page with a success flag
                        response.sendRedirect("properties?status=success");
                        return;
                    }
                }

                // If anything goes wrong, bounce them back to the upgrade screen with an error
                response.sendRedirect("subscribe.jsp?error=failed");
            break;
       
            case "pro":
                
                if (hoIdParam != null && !hoIdParam.isEmpty()) {
                    int hoId = Integer.parseInt(hoIdParam);

                    // 1. Trigger the DAO method to update the column in phpMyAdmin to 'Premium'
                    boolean isUpdated = houseOwnerDAO.updateSubscriptionStatus(hoId, "Pro");

                    if (isUpdated) {
                        // 2. VERY IMPORTANT: Update the current session object 
                        // So the application immediately recognizes them as Premium without logging out
                        HttpSession session = request.getSession();
                        HouseOwner loggedUser = (HouseOwner) session.getAttribute("loggedUser");

                        if (loggedUser != null) {
                            loggedUser.setSubscriptionStatus("Pro");
                        }

                        // 3. Redirect them back to their properties page with a success flag
                        response.sendRedirect("properties?status=success");
                        return;
                    }
                }

                // If anything goes wrong, bounce them back to the upgrade screen with an error
                response.sendRedirect("subscribe.jsp?error=failed");
            break;
              
            case "premium":

                if (hoIdParam != null && !hoIdParam.isEmpty()) {
                    int hoId = Integer.parseInt(hoIdParam);

                    // 1. Trigger the DAO method to update the column in phpMyAdmin to 'Premium'
                    boolean isUpdated = houseOwnerDAO.updateSubscriptionStatus(hoId, "Premium");

                    if (isUpdated) {
                        // 2. VERY IMPORTANT: Update the current session object 
                        // So the application immediately recognizes them as Premium without logging out
                        HttpSession session = request.getSession();
                        HouseOwner loggedUser = (HouseOwner) session.getAttribute("loggedUser");

                        if (loggedUser != null) {
                            loggedUser.setSubscriptionStatus("Premium");
                        }

                        // 3. Redirect them back to their properties page with a success flag
                        response.sendRedirect("properties?status=success");
                        return;
                    }
                }

                // If anything goes wrong, bounce them back to the upgrade screen with an error
                response.sendRedirect("subscribe.jsp?error=failed");
            break;   
        }
                
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forwarding any GET requests straight to the JSP page
        response.sendRedirect("subscribe.jsp");
    }
}