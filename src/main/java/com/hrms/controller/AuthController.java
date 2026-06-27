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
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

@WebServlet("/auth")
// REQUIRED FOR IMAGE UPLOADS
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AuthController extends HttpServlet {
    
    private AuthDAO authDAO = new AuthDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // ==========================================
        // 1. SIGN UP LOGIC
        // ==========================================
        if ("signup".equals(action)) {
            String role = request.getParameter("role");
            
            // --- Process the Profile Image ---
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
                    base64Image = "data:" + filePart.getContentType() + ";base64," + base64Data;
                }
            } catch (Exception e) {
                System.out.println("Image upload skipped or failed during signup.");
            }

            // --- Register Student ---
            if ("student".equals(role)) {
                Student s = new Student();
                s.setUsername(request.getParameter("username"));
                s.setFullName(request.getParameter("fullName"));
                s.setEmail(request.getParameter("email"));
                s.setPassword(request.getParameter("password"));
                s.setPhoneNumber(request.getParameter("phoneNumber"));
                s.setUniversity(request.getParameter("university"));
                s.setFaculty(request.getParameter("faculty"));
                s.setPreferredLocation(request.getParameter("preferredLocation"));
                s.setProfileImage(base64Image); // Inject the converted image

                if (authDAO.registerStudent(s)) {
                    response.sendRedirect("login.jsp?success=registered");
                } else {
                    response.sendRedirect("signup.jsp?error=failed");
                }
            } 
            // --- Register House Owner ---
            else if ("owner".equals(role)) {
                HouseOwner ho = new HouseOwner();
                ho.setUsername(request.getParameter("username"));
                ho.setFullName(request.getParameter("fullName"));
                ho.setEmail(request.getParameter("email"));
                ho.setPassword(request.getParameter("password"));
                ho.setPhoneNumber(request.getParameter("phoneNumber"));
                ho.setProfileImage(base64Image); // Inject the converted image

                if (authDAO.registerHouseOwner(ho)) {
                    response.sendRedirect("login.jsp?success=registered");
                } else {
                    response.sendRedirect("signup.jsp?error=failed");
                }
            }
        } 
        
        // ==========================================
        // 2. LOGIN LOGIC
        // ==========================================
        else if ("login".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            
            if ("admin".equals(role)) {
                if ("admin@gmail.com".equals(email) && "admin123".equals(password)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userRole", "admin");
                    session.setAttribute("adminName", "System Administrator");
                    response.sendRedirect("adminController?action=activityLogs");
                    return;
                }
            } else if ("student".equals(role)) {
                Student student = authDAO.loginStudent(email, password);
                if (student != null) {
                    if ("Blocked".equals(student.getAccountStatus()) || "Terminated".equals(student.getAccountStatus())) {
                        response.sendRedirect("login.jsp?error=blocked&username=" + student.getUsername() + "&role=Student");
                        return;
                    }
                    HttpSession session = request.getSession();
                    session.setAttribute("userRole", "student");
                    session.setAttribute("loggedUser", student);
                    response.sendRedirect("dashboard");
                    return;
                }
            } else if ("owner".equals(role)) {
                HouseOwner owner = authDAO.loginHouseOwner(email, password);
                if (owner != null) {
                    if ("Blocked".equals(owner.getAccountStatus()) || "Terminated".equals(owner.getAccountStatus())) {
                        response.sendRedirect("login.jsp?error=blocked&username=" + owner.getUsername() + "&role=House Owner");
                        return;
                    }
                    HttpSession session = request.getSession();
                    session.setAttribute("userRole", "owner");
                    session.setAttribute("loggedUser", owner);
                    response.sendRedirect("dashboard");
                    return;
                }
            }
            response.sendRedirect("login.jsp?error=invalid");
        }
        
        // ==========================================
        // 3. ACCOUNT APPEAL LOGIC
        // ==========================================
        else if ("submitAppeal".equals(action)) {
            String username = request.getParameter("username");
            String role = request.getParameter("role");
            String message = request.getParameter("appealMessage");
            
            authDAO.submitAppealTicket(username, role, message);
            response.sendRedirect("login.jsp?success=appeal_sent");
        }
        
        // ==========================================
        // 4. LOGOUT LOGIC
        // ==========================================
        else if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp");
        }
    }
}