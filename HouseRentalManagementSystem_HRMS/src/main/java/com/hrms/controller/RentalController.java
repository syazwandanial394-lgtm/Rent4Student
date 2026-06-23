package com.hrms.controller;

import com.hrms.dao.RentalDAO;
import com.hrms.model.HouseOwner;
import com.hrms.model.Student;
import com.hrms.model.Rental;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/rentalController")
public class RentalController extends HttpServlet {
    private RentalDAO rentalDAO = new RentalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null) { response.sendRedirect("login.jsp"); return; }

        List<Rental> rentalList = null;

        if ("student".equals(role)) {
            Student student = (Student) session.getAttribute("loggedUser");
            rentalList = rentalDAO.getRentalsByStudent(student.getStudentId());
        } else if ("owner".equals(role)) {
            HouseOwner owner = (HouseOwner) session.getAttribute("loggedUser");
            rentalList = rentalDAO.getRentalsByOwner(owner.getHoId());
        }

        request.setAttribute("rentalList", rentalList);
        request.getRequestDispatcher("rentals.jsp").forward(request, response);
    }
}