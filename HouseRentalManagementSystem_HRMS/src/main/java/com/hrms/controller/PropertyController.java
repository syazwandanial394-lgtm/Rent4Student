package com.hrms.controller;

import com.hrms.dao.PropertyDAO;
import com.hrms.dao.RentalDAO;
import com.hrms.dao.ApplicationDAO;
import com.hrms.model.HouseOwner;
import com.hrms.model.Property;
import com.hrms.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/properties")
public class PropertyController extends HttpServlet {
    private PropertyDAO propertyDAO = new PropertyDAO();
    private RentalDAO rentalDAO = new RentalDAO();
    private ApplicationDAO applicationDAO = new ApplicationDAO(); // Added to check for pending spam

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Property> propertyList;
        boolean hasActiveRental = false; 
        List<Integer> pendingProps = null; // List to track what properties they already applied to

        if ("owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            propertyList = propertyDAO.getPropertiesByOwner(owner.getHoId());
        } 
        else {
            Student student = (Student) session.getAttribute("loggedUser");
            propertyList = propertyDAO.getAllProperties();
            
            hasActiveRental = rentalDAO.hasActiveRental(student.getStudentId());
            // Fetch all property IDs where this student has a pending application
            pendingProps = applicationDAO.getPendingProperties(student.getStudentId());
        }

        request.setAttribute("propertyList", propertyList);
        request.setAttribute("hasActiveRental", hasActiveRental); 
        request.setAttribute("pendingProps", pendingProps); // Send to JSP
        request.getRequestDispatcher("properties.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        // Extra security check: Only owners should be able to post updates
        if (!"owner".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProperty".equals(action)) {
            try {
                // 1. Fetch form data and populate the Property model
                Property property = new Property();
                property.setPropertyId(Integer.parseInt(request.getParameter("propertyId")));
                property.setPropertyName(request.getParameter("propertyName"));
                property.setPropertyType(request.getParameter("propertyType"));
                property.setAddress(request.getParameter("address"));
                property.setDescription(request.getParameter("description"));
                property.setRentalRate(Double.parseDouble(request.getParameter("rentalRate")));
                property.setAvailabilityStatus(request.getParameter("availabilityStatus"));
                property.setCity(request.getParameter("city"));
                property.setPostcode(request.getParameter("postcode"));

                // 2. Call the DAO
                boolean success = propertyDAO.updateProperty(property);

                // 3. Redirect back to the properties page
                if (success) {
                    response.sendRedirect("properties?success=updated");
                } else {
                    response.sendRedirect("properties?error=update_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("properties?error=invalid_input");
            }
        }
    }
}