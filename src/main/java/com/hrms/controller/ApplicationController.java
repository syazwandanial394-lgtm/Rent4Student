package com.hrms.controller;

import com.hrms.dao.ApplicationDAO;
import com.hrms.dao.RentalDAO;
import com.hrms.model.HouseOwner;
import com.hrms.model.Student;
import com.hrms.model.Application;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/applicationController")
public class ApplicationController extends HttpServlet {
    private ApplicationDAO applicationDAO = new ApplicationDAO();
    private RentalDAO rentalDAO = new RentalDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null) { response.sendRedirect("login.jsp"); return; }

        List<Application> appList = null;

        if ("student".equals(role)) {
            Student student = (Student) session.getAttribute("loggedUser");
            appList = applicationDAO.getStudentApplications(student.getStudentId());
        } else if ("owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            appList = applicationDAO.getOwnerApplications(owner.getHoId());
        }

        request.setAttribute("applicationList", appList);
        request.getRequestDispatcher("applications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("confirmApply".equals(action)) {
            Student student = (Student) session.getAttribute("loggedUser");
            int propertyId = Integer.parseInt(request.getParameter("propertyId"));
            
            // SECURITY CHECK: Do they have an active rental?
            boolean hasRental = rentalDAO.hasActiveRental(student.getStudentId());
            // SECURITY CHECK: Do they already have a pending application for THIS house?
            boolean hasPending = applicationDAO.getPendingProperties(student.getStudentId()).contains(propertyId);
            
            // Only create application if BOTH checks pass
            if (!hasRental && !hasPending) {
                applicationDAO.createApplication(student.getStudentId(), propertyId);
            }
            response.sendRedirect("applicationController");
        } 
        else if ("updateStatus".equals(action)) {
            int appId = Integer.parseInt(request.getParameter("applicationId"));
            String newStatus = request.getParameter("status"); 
            
            // QOL ITEM 7: Grab the remarks from the modal form
            String remarks = request.getParameter("remarks"); 
            
            String result = "";
            if ("Approved".equals(newStatus)) {
                // Pass remarks into the approval method
                result = applicationDAO.approveAndCreateRental(appId, remarks);
            } else {
                // Pass remarks into the reject/cancel method
                result = applicationDAO.updateApplicationStatus(appId, newStatus, remarks);
            }
            
            if (!"success".equals(result)) {
                response.sendRedirect("applicationController?error=" + java.net.URLEncoder.encode(result, "UTF-8"));
            } else {
                response.sendRedirect("applicationController");
            }
        }
    }
}