package com.controller;

import com.dao.PaymentDAO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import com.dao.DBConnection;
import com.model.Payment;

@WebServlet("/paymentSubmit")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class PaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        int quotationId = Integer.parseInt(request.getParameter("quotationId"));
        String paymentMethod = request.getParameter("paymentMethod");
        double price = Double.parseDouble(request.getParameter("finalTotalPremium"));
        LocalDate formattedDate = LocalDate.parse(request.getParameter("formattedDate"));
        LocalTime formattedTime = LocalTime.parse(request.getParameter("formattedTime"));
        String paymentStatus = request.getParameter("paymentStatus");

        // Get the receipt image if available
        Part filePart = request.getPart("receiptImage");
        byte[] receiptImage = null;
        if (filePart != null && filePart.getSize() > 0) {
            receiptImage = filePart.getInputStream().readAllBytes();
        }

        // Create Payment object
        Payment payment = new Payment(quotationId, paymentMethod, price, receiptImage, formattedDate, formattedTime, paymentStatus);

        // Insert into database
        try {
            Connection conn = DBConnection.getConnection();
            PaymentDAO.insertPayment(conn, payment);
            conn.close();
            // After inserting payment into database
            request.setAttribute("quotationId", quotationId);
            request.getRequestDispatcher("success.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace(); // Handle exception appropriately
        }
    }
}
