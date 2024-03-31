package com.controller;

import com.dao.CustomerDAO;
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
        String userID = request.getParameter("userID");
        Part filePart = request.getPart("imageFile"); // Retrieves <input type="file" name="imageFile">

        try (InputStream fileContent = filePart.getInputStream()) {
            CustomerDAO.updateProfileImage(userID, fileContent);
            // Redirect to customerProfile.jsp after successful upload
            response.sendRedirect("customerProfile.jsp");
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
