package com.hrms.controller;

import com.hrms.dao.HouseOwnerDAO;
import com.hrms.dao.StudentDAO;
import com.hrms.model.Student;
import com.hrms.model.HouseOwner;
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

@WebServlet("/profileController")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ProfileController extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    private HouseOwnerDAO houseOwnerDAO = new HouseOwnerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("student".equals(role)) {
            Student currentSessionStudent = (Student) session.getAttribute("loggedUser");
            Student freshDbStudent = studentDAO.getStudentById(currentSessionStudent.getStudentId());
            if (freshDbStudent != null) {
                session.setAttribute("loggedUser", freshDbStudent);
            }
        }
        else if ("owner".equals(role)) {
            HouseOwner currentSessionOwner = (HouseOwner) session.getAttribute("loggedUser");
            HouseOwner freshDbOwner = houseOwnerDAO.getHouseOwnerById(currentSessionOwner.getHoId());
            if (freshDbOwner != null) {
                session.setAttribute("loggedUser", freshDbOwner); 
            }
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");
        String action = request.getParameter("action");

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
                
                // Creates a string that HTML <img> tags can read natively
                base64Image = "data:" + contentType + ";base64," + base64Data;
                
                inputStream.close();
                outputStream.close();
            }
        } catch (Exception e) {
            System.out.println("====== BASE64 IMAGE ENCODING ERROR ======");
            e.printStackTrace();
        }

        if ("student".equals(role)) {
            Student student = (Student) session.getAttribute("loggedUser");

            if ("deleteAccount".equals(action)) {
                if (studentDAO.deleteStudentAccount(student.getStudentId())) {
                    session.invalidate(); 
                    response.sendRedirect("login.jsp?success=deleted"); 
                    return;
                } else {
                    response.sendRedirect("profileController?error=delete_failed");
                    return;
                }
            }

            student.setUsername(request.getParameter("username"));
            student.setFullName(request.getParameter("fullName"));
            student.setEmail(request.getParameter("email"));
            student.setPhoneNumber(request.getParameter("phoneNumber"));
            student.setUniversity(request.getParameter("university"));
            student.setPreferredLocation(request.getParameter("preferredLocation"));
            student.setFaculty(request.getParameter("faculty"));
            
            // Only update if they actually picked a new picture
            if (base64Image != null) {
                student.setProfileImage(base64Image);
            }

            if (studentDAO.updateStudentProfile(student)) {
                session.setAttribute("loggedUser", student);
                response.sendRedirect("profileController?success=true");
            } else {
                response.sendRedirect("profileController?error=true");
            }
        }
        
        else if ("owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");

            if ("deleteAccount".equals(action)) {
                if (houseOwnerDAO.deleteHouseOwnerAccount(owner.getHoId())) {
                    session.invalidate(); 
                    response.sendRedirect("login.jsp?success=deleted"); 
                    return;
                } else {
                    response.sendRedirect("profileController?error=delete_failed");
                    return;
                }
            }

            owner.setUsername(request.getParameter("username"));
            owner.setFullName(request.getParameter("fullName"));
            owner.setEmail(request.getParameter("email"));
            owner.setPhoneNumber(request.getParameter("phoneNumber"));
            
            // Only update if they actually picked a new picture
            if (base64Image != null) {
                owner.setProfileImage(base64Image);
            }

            if (houseOwnerDAO.updateHouseOwnerProfile(owner)) {
                session.setAttribute("loggedUser", owner); 
                response.sendRedirect("profileController?success=true");
            } else {
                response.sendRedirect("profileController?error=true");
            }
        }
    }
}