package com.controller;

import com.dao.ProfileDAO;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/uploadImage")
@MultipartConfig
public class UploadImageServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roles = request.getParameter("roles");
        int userID = Integer.parseInt(request.getParameter("userID"));
        Part filePart = request.getPart("imageFile");

        try (InputStream fileContent = filePart.getInputStream()) {
            ProfileDAO.updateProfileImage(userID, fileContent, roles);
            // Redirect to appropriate page after successful upload
            response.sendRedirect(getRedirectURL(roles));
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private String getRedirectURL(String roles) {
        // Determine the appropriate redirection URL based on the user's role
        switch (roles) {
            case "customer":
                return "customerProfile.jsp";
            case "staff":
                return "staffProfile.jsp";
            case "manager":
                return "managerProfile.jsp";
            case "admin":
                return "adminProfile.jsp";
            default:
                throw new IllegalArgumentException("Invalid user role: " + roles);
        }
    }
}
