package com.controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dao.DBConnection;

@WebServlet("/transferData")
public class DataTransferServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String quotationIdStr = request.getParameter("quotationId");
        if (quotationIdStr != null) {
            try {
                int quotationId = Integer.parseInt(quotationIdStr);
                transferAndDeleteData(quotationId);
                request.setAttribute("quotationId", quotationId);
                request.getRequestDispatcher("customerFeedback.jsp?quotationId=" + quotationId).forward(request, response);
            } catch (NumberFormatException e) {
                response.getWriter().println("Invalid Quotation ID format!");
            } catch (Exception e) {
                e.printStackTrace(response.getWriter()); // Print stack trace to response for debugging
                response.getWriter().println("Error processing request: " + e.getMessage());
            }
        } else {
            response.getWriter().println("Quotation ID is missing!");
        }
    }

    private void transferAndDeleteData(int quotationId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Transfer data from Quotation to QuotationHistory
            transferQuotationData(conn, quotationId);

            // Transfer data from Addons to AddonsHistory
            transferAddonsData(conn, quotationId);

            // Transfer data from Vehicle to VehicleHistory
            transferVehicleData(conn, quotationId);

            // Transfer data from Payment to PaymentHistory
            transferPaymentData(conn, quotationId);

            // Delete the original data
            deleteOriginalData(conn, quotationId);

            conn.commit();
        } catch (SQLException | ClassNotFoundException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }

    private void transferQuotationData(Connection conn, int quotationId) throws SQLException {
        String sql = "INSERT INTO QuotationHistory (quotation_id, userID, coverage, policy_commencement_date, policy_duration, policy_expiry_date, selected_ncd) SELECT quotation_id, userID, coverage, policy_commencement_date, policy_duration, policy_expiry_date, selected_ncd FROM Quotation WHERE quotation_id = ?";
        executeInsert(conn, sql, quotationId);
    }

    private void transferAddonsData(Connection conn, int quotationId) throws SQLException {
        String sql = "INSERT INTO AddonsHistory (quotation_id, windscreen_cost, all_driver_cost, special_perils_cost, legal_liability_cost) SELECT quotation_id, windscreen_cost, all_driver_cost, special_perils_cost, legal_liability_cost FROM Addons WHERE quotation_id = ?";
        executeInsert(conn, sql, quotationId);
    }

    private void transferVehicleData(Connection conn, int quotationId) throws SQLException {
        String sql = "INSERT INTO VehicleHistory (quotation_id, owner_name, owner_id, dob, gender, marital_status, location, vehicle_type, local_import, registration_number, engine_number, chassis_number, insured_value, vehicle_body, vehicle_make, vehicle_model, manufacture_year, engine_capacity) SELECT quotation_id, owner_name, owner_id, dob, gender, marital_status, location, vehicle_type, local_import, registration_number, engine_number, chassis_number, insured_value, vehicle_body, vehicle_make, vehicle_model, manufacture_year, engine_capacity FROM Vehicle WHERE quotation_id = ?";
        executeInsert(conn, sql, quotationId);
    }

    private void transferPaymentData(Connection conn, int quotationId) throws SQLException {
        String sql = "INSERT INTO PaymentHistory (quotation_id, payment_method, price, receipt_image, date_submitted, time_submitted, paymentStatus) SELECT quotation_id, payment_method, price, receipt_image, date_submitted, time_submitted, paymentStatus FROM Payment WHERE quotation_id = ?";
        executeInsert(conn, sql, quotationId);
    }

    private void deleteOriginalData(Connection conn, int quotationId) throws SQLException {
        // Deleting data from dependent tables first
        deleteData(conn, "DELETE FROM Payment WHERE quotation_id = ?", quotationId);
        deleteData(conn, "DELETE FROM Vehicle WHERE quotation_id = ?", quotationId);
        deleteData(conn, "DELETE FROM Addons WHERE quotation_id = ?", quotationId);
        deleteData(conn, "DELETE FROM Quotation WHERE quotation_id = ?", quotationId);
    }

    private void executeInsert(Connection conn, String sql, int quotationId) throws SQLException {
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quotationId);
            pstmt.executeUpdate();
        }
    }

    private void deleteData(Connection conn, String sql, int quotationId) throws SQLException {
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quotationId);
            int affectedRows = pstmt.executeUpdate();
            System.out.println("Deleted rows: " + affectedRows); // For debugging, can be removed later
        }
    }
}
