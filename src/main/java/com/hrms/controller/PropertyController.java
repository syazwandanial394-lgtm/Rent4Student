package com.hrms.controller;

import com.hrms.dao.ApplicationDAO;
import com.hrms.dao.PropertyDAO;
import com.hrms.dao.RentalDAO;
import com.hrms.model.HouseOwner;
import com.hrms.model.Property;
import com.hrms.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;
import java.util.List;

@WebServlet("/properties")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
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
            
            int totalHouses = propertyDAO.getTotalPropertiesByOwner(owner.getHoId());
            request.setAttribute("totalHouses", totalHouses);
            
        } else {
            Student student = (Student) session.getAttribute("loggedUser");
            hasActiveRental = rentalDAO.hasActiveRental(student.getStudentId());
            pendingProps = applicationDAO.getPendingProperties(student.getStudentId());

            String searchLocation = request.getParameter("searchLocation");
            String maxPriceStr = request.getParameter("maxPrice");
            String houseType = request.getParameter("houseType"); 
            
            Double maxPrice = (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) ? Double.parseDouble(maxPriceStr) : null;
            
            if (searchLocation != null && searchLocation.trim().isEmpty()) {
                searchLocation = null;
            }

            String prefLoc = student.getPreferredLocation();
            boolean hasFilters = (searchLocation != null) || maxPrice != null || (houseType != null && !houseType.trim().isEmpty() && !"Any".equalsIgnoreCase(houseType));

            if (hasFilters) {
                isSearch = true;
                String effectiveLocation = searchLocation;
                
                if (effectiveLocation == null && prefLoc != null && !prefLoc.trim().isEmpty()) {
                    effectiveLocation = prefLoc;
                    showingRecommendations = true; 
                }
                
                propertyList = propertyDAO.searchProperties(effectiveLocation, maxPrice, houseType);
            } 
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

        String base64Image = null; 
        
        // FIX: ONLY attempt to process an image upload if the user is Adding or Editing a property!
        if ("addProperty".equals(action) || "updateProperty".equals(action)) {
            try {
                Part filePart = request.getPart("propertyImage");
                if (filePart != null && filePart.getSize() > 0) {
                    InputStream inputStream = filePart.getInputStream();
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                    
                    byte[] imageBytes = outputStream.toByteArray();
                    String base64Data = Base64.getEncoder().encodeToString(imageBytes);
                    String contentType = filePart.getContentType(); 
                    
                    base64Image = "data:" + contentType + ";base64," + base64Data;
                    
                    inputStream.close();
                    outputStream.close();
                }
            } catch (Exception e) {
                System.out.println("====== BASE64 IMAGE ENCODING ERROR (PROPERTY) ======");
                e.printStackTrace();
            }
        }

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
            p.setPropertyImage(base64Image);

            if (propertyDAO.addProperty(p)) {
                response.sendRedirect("properties?success=added");
            } else {
                response.sendRedirect("properties?error=add_failed");
            }
        }
        else if ("updateProperty".equals(action)) {
            try {
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
                property.setPropertyImage(base64Image); // Will be null if no new image was selected

                boolean success = propertyDAO.updateProperty(property);

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
        else if ("deleteProperty".equals(action)) {
            try {
                int propertyId = Integer.parseInt(request.getParameter("propertyId"));
                boolean success = propertyDAO.deleteProperty(propertyId);
                
                if (success) {
                    response.sendRedirect("properties?success=deleted");
                } else {
                    response.sendRedirect("properties?error=delete_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("properties?error=invalid_id");
            }
        }
    }
}