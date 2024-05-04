package com.controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dao.DBConnection;  // Use your DBConnection class

@WebServlet("/transferData")
public class DataTransferServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String quotationId = request.getParameter("quotationId");
        if (quotationId != null) {
            try {
                transferAndDeleteData(quotationId);
                response.sendRedirect("customerHistory.jsp");
            } catch (Exception e) {
                e.printStackTrace(response.getWriter()); // Print stack trace to response for debugging
                response.getWriter().println("Error processing request: " + e.getMessage());
            }
        } else {
            response.getWriter().println("Quotation ID is missing!");
        }
    }

    private void transferAndDeleteData(String quotationId) throws SQLException, ClassNotFoundException {
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

    private void transferQuotationData(Connection conn, String quotationId) throws SQLException {
        String sql = "INSERT INTO QuotationHistory (quotation_id, userID, coverage, policy_commencement_date, policy_duration, policy_expiry_date, selected_ncd) SELECT quotation_id, userID, coverage, policy_commencement_date, policy_duration, policy_expiry_date, selected_ncd FROM Quotation WHERE quotation_id = ?";
        executeInsert(conn, sql, quotationId);
    }

    private void transferAddonsData(Connection conn, String quotationId) throws SQLException {
        String sql = "INSERT INTO AddonsHistory (quotation_id, windscreen_cost, all_driver_cost, special_perils_cost, legal_liability_cost) SELECT quotation_id, windscreen_cost, all_driver_cost, special_perils_cost, legal_liability_cost FROM Addons WHERE quotation_id = ?";
        executeInsert(conn, sql, quotationId);
    }

    private void transferVehicleData(Connection conn, String quotationId) throws SQLException {
        String sql = "INSERT INTO VehicleHistory (quotation_id, owner_name, owner_id, dob, gender, marital_status, location, vehicle_type, local_import, registration_number, engine_number, chassis_number, insured_value, vehicle_body, vehicle_make, vehicle_model, manufacture_year, engine_capacity) SELECT quotation_id, owner_name, owner_id, dob, gender, marital_status, location, vehicle_type, local_import, registration_number, engine_number, chassis_number, insured_value, vehicle_body, vehicle_make, vehicle_model, manufacture_year, engine_capacity FROM Vehicle WHERE quotation_id = ?";
        executeInsert(conn, sql, quotationId);
    }

    private void transferPaymentData(Connection conn, String quotationId) throws SQLException {
        String sql = "INSERT INTO PaymentHistory (quotation_id, payment_method, price, receipt_image, date_submitted, time_submitted) SELECT quotation_id, payment_method, price, receipt_image, date_submitted, time_submitted FROM Payment WHERE quotation_id = ?";
        executeInsert(conn, sql, quotationId);
    }

    private void deleteOriginalData(Connection conn, String quotationId) throws SQLException {
        // Deleting data from dependent tables first
        deleteData(conn, "DELETE FROM Payment WHERE quotation_id = ?", quotationId);
        deleteData(conn, "DELETE FROM Vehicle WHERE quotation_id = ?", quotationId);
        deleteData(conn, "DELETE FROM Addons WHERE quotation_id = ?", quotationId);
        deleteData(conn, "DELETE FROM Quotation WHERE quotation_id = ?", quotationId);
    }

    private void executeInsert(Connection conn, String sql, String quotationId) throws SQLException {
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, Integer.parseInt(quotationId));
            pstmt.executeUpdate();
        }
    }

    private void deleteData(Connection conn, String sql, String quotationId) throws SQLException {
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, Integer.parseInt(quotationId));
            int affectedRows = pstmt.executeUpdate();
            System.out.println("Deleted rows: " + affectedRows); // For debugging, can be removed later
        }
    }
}
