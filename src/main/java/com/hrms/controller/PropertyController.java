package com.hrms.controller;

import com.hrms.dao.ApplicationDAO;
import com.hrms.dao.PropertyDAO;
import com.hrms.dao.RentalDAO;
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
    private ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Property> propertyList = null;
        boolean hasActiveRental = false; 
        List<Integer> pendingProps = null; 
        
        boolean isSearch = false;
        boolean showingRecommendations = false;

        if ("owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            propertyList = propertyDAO.getPropertiesByOwner(owner.getHoId());
        } else {
            Student student = (Student) session.getAttribute("loggedUser");
            hasActiveRental = rentalDAO.hasActiveRental(student.getStudentId());
            pendingProps = applicationDAO.getPendingProperties(student.getStudentId());

            // Get parameters
            String searchLocation = request.getParameter("searchLocation");
            String maxPriceStr = request.getParameter("maxPrice");
            String houseType = request.getParameter("houseType"); 
            
            Double maxPrice = (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) ? Double.parseDouble(maxPriceStr) : null;
            
            // Clean up empty string
            if (searchLocation != null && searchLocation.trim().isEmpty()) {
                searchLocation = null;
            }

            String prefLoc = student.getPreferredLocation();

            boolean hasFilters = (searchLocation != null) || maxPrice != null || (houseType != null && !houseType.trim().isEmpty() && !"Any".equalsIgnoreCase(houseType));

            // THE COMBO FIX:
            if (hasFilters) {
                isSearch = true;
                
                String effectiveLocation = searchLocation;
                
                // If they used a filter (like Studio) but left the location blank, inject their preferred location!
                if (effectiveLocation == null && prefLoc != null && !prefLoc.trim().isEmpty()) {
                    effectiveLocation = prefLoc;
                    showingRecommendations = true; // Keeps the "Recommended in..." text on screen
                }
                
                propertyList = propertyDAO.searchProperties(effectiveLocation, maxPrice, houseType);
            } 
            // DEFAULT VIEW
            else {
                if (prefLoc != null && !prefLoc.trim().isEmpty()) {
                    propertyList = propertyDAO.searchProperties(prefLoc, null, null);
                    showingRecommendations = true;
                } else {
                    propertyList = propertyDAO.getAllProperties();
                }
            }
        }

        request.setAttribute("propertyList", propertyList);
        request.setAttribute("showingRecommendations", showingRecommendations);
        request.setAttribute("hasActiveRental", hasActiveRental); 
        request.setAttribute("pendingProps", pendingProps); 
        request.setAttribute("isSearch", isSearch);
        
        request.getRequestDispatcher("properties.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("addProperty".equals(action)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            
            Property p = new Property();
            p.setHoId(owner.getHoId());
            p.setPropertyName(request.getParameter("propertyName"));
            p.setPropertyType(request.getParameter("propertyType"));
            p.setDescription(request.getParameter("description"));
            p.setAddress(request.getParameter("address"));
            p.setCity(request.getParameter("city"));
            p.setPostcode(request.getParameter("postcode"));
            p.setRentalRate(Double.parseDouble(request.getParameter("rentalRate")));

            if (propertyDAO.addProperty(p)) {
                response.sendRedirect("properties?success=added");
            } else {
                response.sendRedirect("properties?error=add_failed");
            }
        }

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