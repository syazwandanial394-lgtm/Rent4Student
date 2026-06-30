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
        
        if (action == null) {
            // FIXED: Route through controller, not raw JSP
            response.sendRedirect("subscriptionController");
            return;
        }

        switch (action) {
            case "free":
                if (hoIdParam != null && !hoIdParam.isEmpty()) {
                    int hoId = Integer.parseInt(hoIdParam);
                    boolean isUpdated = houseOwnerDAO.updateSubscriptionStatus(hoId, "Free");

                    if (isUpdated) {
                        houseOwnerDAO.logSubscriptionChange(hoId, "Free", "Canceled");
                        
                        HttpSession session = request.getSession();
                        HouseOwner loggedUser = (HouseOwner) session.getAttribute("loggedUser");
                        if (loggedUser != null) {
                            loggedUser.setSubscriptionStatus("Free");
                        }
                        response.sendRedirect("properties?status=success");
                        return;
                    }
                }
                // FIXED: Route through controller
                response.sendRedirect("subscriptionController?error=failed");
            break;

            case "standard":
                if (hoIdParam != null && !hoIdParam.isEmpty()) {
                    int hoId = Integer.parseInt(hoIdParam);
                    boolean isUpdated = houseOwnerDAO.updateSubscriptionStatus(hoId, "Standard");

                    if (isUpdated) {
                        houseOwnerDAO.logSubscriptionChange(hoId, "Standard", "Subscribed");
                        
                        HttpSession session = request.getSession();
                        HouseOwner loggedUser = (HouseOwner) session.getAttribute("loggedUser");
                        if (loggedUser != null) {
                            loggedUser.setSubscriptionStatus("Standard");
                        }
                        response.sendRedirect("properties?status=success");
                        return;
                    }
                }
                response.sendRedirect("subscriptionController?error=failed");
            break;
       
            case "pro":
                if (hoIdParam != null && !hoIdParam.isEmpty()) {
                    int hoId = Integer.parseInt(hoIdParam);
                    boolean isUpdated = houseOwnerDAO.updateSubscriptionStatus(hoId, "Pro");

                    if (isUpdated) {
                        houseOwnerDAO.logSubscriptionChange(hoId, "Pro", "Subscribed");
                        
                        HttpSession session = request.getSession();
                        HouseOwner loggedUser = (HouseOwner) session.getAttribute("loggedUser");
                        if (loggedUser != null) {
                            loggedUser.setSubscriptionStatus("Pro");
                        }
                        response.sendRedirect("properties?status=success");
                        return;
                    }
                }
                response.sendRedirect("subscriptionController?error=failed");
            break;
              
            case "premium":
                if (hoIdParam != null && !hoIdParam.isEmpty()) {
                    int hoId = Integer.parseInt(hoIdParam);
                    boolean isUpdated = houseOwnerDAO.updateSubscriptionStatus(hoId, "Premium");

                    if (isUpdated) {
                        houseOwnerDAO.logSubscriptionChange(hoId, "Premium", "Subscribed");
                        
                        HttpSession session = request.getSession();
                        HouseOwner loggedUser = (HouseOwner) session.getAttribute("loggedUser");
                        if (loggedUser != null) {
                            loggedUser.setSubscriptionStatus("Premium");
                        }
                        response.sendRedirect("properties?status=success");
                        return;
                    }
                }
                response.sendRedirect("subscriptionController?error=failed");
            break;
            
            default:
                response.sendRedirect("subscriptionController");
            break;
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        HouseOwner loggedUser = (HouseOwner) session.getAttribute("loggedUser");
        
        if (loggedUser != null) {
            request.setAttribute("subHistory", houseOwnerDAO.getSubscriptionHistory(loggedUser.getHoId()));
            request.getRequestDispatcher("subscribe.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}