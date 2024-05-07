package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.DBConnection;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/managePayment")
public class ManagePaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int paymentId = Integer.parseInt(request.getParameter("paymentId"));
        String status = request.getParameter("status");

        try {
            updatePaymentStatus(paymentId, status);
            response.sendRedirect("managePayment.jsp"); // Redirect back to the managePayment.jsp page after updating
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error updating payment status: " + e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ManagePaymentServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void updatePaymentStatus(int paymentId, String status) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE PaymentHistory SET paymentStatus = ? WHERE quotation_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, paymentId);
            pstmt.executeUpdate();
        } finally {
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }
}
