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
            String viewAll = request.getParameter("viewAll");
            Double maxPrice = (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) ? Double.parseDouble(maxPriceStr) : null;

            boolean hasSearchParam = (searchLocation != null && !searchLocation.trim().isEmpty()) || maxPrice != null;

            // LOGIC 1: If they manually typed something into the search bar
            if (hasSearchParam) {
                isSearch = true;
                propertyList = propertyDAO.searchProperties(searchLocation, maxPrice);
            } 
            // LOGIC 2: If they explicitly clicked the "View All" button
            else if ("true".equals(viewAll)) {
                propertyList = propertyDAO.getAllProperties();
            } 
            // LOGIC 3: DEFAULT VIEW - Only show properties matching their Preferred Location!
            else {
                String prefLoc = student.getPreferredLocation();
                if (prefLoc != null && !prefLoc.trim().isEmpty()) {
                    propertyList = propertyDAO.searchProperties(prefLoc, null);
                    showingRecommendations = true;
                } else {
                    // Fallback if they haven't set a location yet
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
    }
}