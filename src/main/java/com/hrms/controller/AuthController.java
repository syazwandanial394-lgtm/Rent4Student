package com.hrms.controller;

import com.hrms.dao.AuthDAO;
import com.hrms.model.HouseOwner;
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
import java.io.InputStream;
import java.io.IOException;
import java.util.Base64;

@WebServlet("/auth")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AuthController extends HttpServlet {
    private AuthDAO authDAO = new AuthDAO(); 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("login".equals(action)) {
            String role = request.getParameter("role");
            
            if ("admin".equals(role)) {
                if ("admin@rentease.com".equals(request.getParameter("email")) && "admin123".equals(request.getParameter("password"))) {
                    session.setAttribute("userRole", "admin");
                    session.setAttribute("adminName", "System Administrator");
                    response.sendRedirect("admin-dashboard.jsp");
                } else { response.sendRedirect("login.jsp?error=invalid"); }
            } 
            else if ("student".equals(role)) {
                Student student = authDAO.loginStudent(request.getParameter("email"), request.getParameter("password"));
                if (student != null) {
                    // --- NEW SECURITY CHECK ---
                    if ("Blocked".equals(student.getAccountStatus()) || "Terminated".equals(student.getAccountStatus())) {
                        response.sendRedirect("login.jsp?error=blocked&username=" + student.getUsername() + "&role=Student");
                        return;
                    }
                    session.setAttribute("loggedUser", student);
                    session.setAttribute("userRole", "student");
                    response.sendRedirect("dashboard");
                } else { response.sendRedirect("login.jsp?error=invalid"); }
            } 
            else if ("owner".equals(role)) {
                HouseOwner owner = authDAO.loginHouseOwner(request.getParameter("email"), request.getParameter("password"));
                if (owner != null) {
                    // --- NEW SECURITY CHECK ---
                    if ("Blocked".equals(owner.getAccountStatus()) || "Terminated".equals(owner.getAccountStatus())) {
                        response.sendRedirect("login.jsp?error=blocked&username=" + owner.getUsername() + "&role=Owner");
                        return;
                    }
                    session.setAttribute("loggedUser", owner);
                    session.setAttribute("userRole", "owner");
                    response.sendRedirect("dashboard");
                } else { response.sendRedirect("login.jsp?error=invalid"); }
            }
        } 
        
        // --- NEW: HANDLES THE APPEAL SUBMISSION FROM THE RED POPUP ---
        else if ("submitAppeal".equals(action)) {
            String username = request.getParameter("username");
            String role = request.getParameter("role");
            String message = request.getParameter("appealMessage");
            
            authDAO.submitAppealTicket(username, role, message);
            response.sendRedirect("login.jsp?success=appeal_sent");
        }
        
        else if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("login.jsp");
        } 
        else if ("signup".equals(action)) {
            String role = request.getParameter("role");
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phoneNumber = request.getParameter("phoneNumber");

            // --- BULLETPROOF BASE64 IMAGE UPLOAD ---
            String base64Image = null; 
            try {
                Part filePart = request.getPart("profileImage");
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
                System.out.println("====== BASE64 IMAGE ENCODING ERROR (SIGNUP) ======");
                e.printStackTrace();
            }

            boolean success = false;
            
            if ("student".equals(role)) {
                Student s = new Student();
                s.setUsername(username);
                s.setFullName(fullName);
                s.setEmail(email);
                s.setPassword(password);
                s.setPhoneNumber(phoneNumber);
                s.setProfileImage(base64Image);
                s.setUniversity(request.getParameter("university"));
                s.setFaculty(request.getParameter("faculty"));
                s.setPreferredLocation(request.getParameter("preferredLocation")); 
                // Newly registered accounts start as Active automatically via DB Default!
                success = authDAO.registerStudent(s);
            } 
            else if ("owner".equals(role)) {
                HouseOwner ho = new HouseOwner();
                ho.setUsername(username);
                ho.setFullName(fullName);
                ho.setEmail(email);
                ho.setPassword(password);
                ho.setPhoneNumber(phoneNumber);
                ho.setProfileImage(base64Image); 
                success = authDAO.registerHouseOwner(ho);
            }

            if (success) {
                response.sendRedirect("login.jsp?success=registered");
            } else {
                response.sendRedirect("signup.jsp?error=failed");
            }
        }
    }
}