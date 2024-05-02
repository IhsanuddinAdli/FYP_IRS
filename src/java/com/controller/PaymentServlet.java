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
        // Check if the request object is null
        if (request != null) {
            // Declare quotationId variable outside of if block
            int quotationId;

            // Get form data
            String quotationIdParam = request.getParameter("quotationId");
            if (quotationIdParam != null) {
                quotationId = Integer.parseInt(quotationIdParam);
                String paymentMethod = request.getParameter("paymentMethod");
                double price = Double.parseDouble(request.getParameter("finalTotalPremium"));
                LocalDate formattedDate = LocalDate.parse(request.getParameter("formattedDate"));
                LocalTime formattedTime = LocalTime.parse(request.getParameter("formattedTime"));

                // Check if the request comes from qrCode.jsp or cod.jsp
                if (request.getParameter("receiptImage") != null) {
                    // Request comes from qrCode.jsp, handle insertion with image
                    Part filePart = request.getPart("receiptImage");
                    String fileName = filePart.getSubmittedFileName();
                    byte[] receiptImage = filePart.getInputStream().readAllBytes();
                    insertPaymentWithImage(quotationId, paymentMethod, price, formattedDate, formattedTime, receiptImage, response);
                } else {
                    // Request comes from cod.jsp, handle insertion without image
                    insertPaymentWithoutImage(quotationId, paymentMethod, price, formattedDate, formattedTime, response);
                }
            } else {
                // Handle the case when quotationId parameter is null
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Null quotationId parameter");
            }
        } else {
            // Handle the case when request object is null
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Null request object");
        }
    }

// Insert into database with image
    private void insertPaymentWithImage(int quotationId, String paymentMethod, double price, LocalDate formattedDate, LocalTime formattedTime, byte[] receiptImage, HttpServletResponse response) throws IOException {
        Payment payment = new Payment(quotationId, paymentMethod, price, receiptImage, formattedDate, formattedTime);
        try {
            Connection conn = DBConnection.getConnection();
            PaymentDAO.insertPaymentWithImage(conn, payment);
            conn.close();
            response.sendRedirect("success.jsp"); // Redirect to success page
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace(); // Handle exception appropriately
        }
    }

// Insert into database without image
    private void insertPaymentWithoutImage(int quotationId, String paymentMethod, double price, LocalDate formattedDate, LocalTime formattedTime, HttpServletResponse response) throws IOException {
        Payment payment = new Payment(quotationId, paymentMethod, price, formattedDate, formattedTime);
        try {
            Connection conn = DBConnection.getConnection();
            PaymentDAO.insertPaymentWithoutImage(conn, payment);
            conn.close();
            response.sendRedirect("success.jsp"); // Redirect to success page
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace(); // Handle exception appropriately
        }
    }
}
