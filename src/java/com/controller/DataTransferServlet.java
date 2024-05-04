package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dao.DBConnection;

@WebServlet("/transferData")
public class DataTransferServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve quotationId from the request parameter
        int quotationId = Integer.parseInt(request.getParameter("quotationId"));

        // Retrieve userID from session
        HttpSession session = request.getSession();
        String userID = (String) session.getAttribute("userID");

        // Retrieve and transfer data related to quotationId from original tables
        try {
            Connection conn = DBConnection.getConnection();
            retrieveAndTransferData(conn, quotationId, userID);
            conn.close();
            // Redirect to a confirmation page
            response.sendRedirect("customerHistory.jsp");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
            return;
        }
    }

    private void retrieveAndTransferData(Connection conn, int quotationId, String userID) throws SQLException, ClassNotFoundException {
        String selectQuotationSQL = "SELECT * FROM Quotation WHERE quotation_id = ?";
        String selectAddonsSQL = "SELECT * FROM Addons WHERE quotation_id = ?";
        String selectVehicleSQL = "SELECT * FROM Vehicle WHERE quotation_id = ?";
        String selectPaymentSQL = "SELECT * FROM Payment WHERE quotation_id = ?";

        try (PreparedStatement psQuotation = conn.prepareStatement(selectQuotationSQL);
                PreparedStatement psAddons = conn.prepareStatement(selectAddonsSQL);
                PreparedStatement psVehicle = conn.prepareStatement(selectVehicleSQL);
                PreparedStatement psPayment = conn.prepareStatement(selectPaymentSQL)) {

            psQuotation.setInt(1, quotationId);
            psAddons.setInt(1, quotationId);
            psVehicle.setInt(1, quotationId);
            psPayment.setInt(1, quotationId);

            ResultSet rsQuotation = psQuotation.executeQuery();
            ResultSet rsAddons = psAddons.executeQuery();
            ResultSet rsVehicle = psVehicle.executeQuery();
            ResultSet rsPayment = psPayment.executeQuery();

            transferToHistoryTables(conn, rsQuotation, rsAddons, rsVehicle, rsPayment, userID);
            deleteFromOriginalTables(conn, quotationId);
        }
    }

    private void transferToHistoryTables(Connection conn, ResultSet rsQuotation, ResultSet rsAddons, ResultSet rsVehicle,
            ResultSet rsPayment, String userID) throws SQLException {
        // Prepare insert statements for history tables
        String insertQuotationHistorySQL = "INSERT INTO QuotationHistory (quotation_id, userID, coverage, policy_commencement_date, policy_duration, policy_expiry_date, selected_ncd) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertAddonsHistorySQL = "INSERT INTO AddonsHistory (quotation_id, windscreen_cost, all_driver_cost, special_perils_cost, legal_liability_cost) VALUES (?, ?, ?, ?, ?)";
        String insertVehicleHistorySQL = "INSERT INTO VehicleHistory (quotation_id, owner_name, owner_id, dob, gender, marital_status, location, vehicle_type, local_import, registration_number, engine_number, chassis_number, insured_value, vehicle_body, vehicle_make, vehicle_model, manufacture_year, engine_capacity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPaymentHistorySQL = "INSERT INTO PaymentHistory (quotation_id, payment_method, price, receipt_image)";

        try (PreparedStatement psInsertQuotationHistory = conn.prepareStatement(insertQuotationHistorySQL);
                PreparedStatement psInsertAddonsHistory = conn.prepareStatement(insertAddonsHistorySQL);
                PreparedStatement psInsertVehicleHistory = conn.prepareStatement(insertVehicleHistorySQL);
                PreparedStatement psInsertPaymentHistory = conn.prepareStatement(insertPaymentHistorySQL)) {

            // Transfer data to QuotationHistory table
            if (rsQuotation.next()) {
                psInsertQuotationHistory.setInt(1, rsQuotation.getInt("quotation_id"));
                psInsertQuotationHistory.setString(2, userID);
                psInsertQuotationHistory.setString(3, rsQuotation.getString("coverage"));
                psInsertQuotationHistory.setDate(4, rsQuotation.getDate("policy_commencement_date"));
                psInsertQuotationHistory.setInt(5, rsQuotation.getInt("policy_duration"));
                psInsertQuotationHistory.setDate(6, rsQuotation.getDate("policy_expiry_date"));
                psInsertQuotationHistory.setString(7, rsQuotation.getString("selected_ncd"));
                psInsertQuotationHistory.executeUpdate();
            }

            // Transfer data to AddonsHistory table
            if (rsAddons.next()) {
                psInsertAddonsHistory.setInt(1, rsAddons.getInt("quotation_id"));
                psInsertAddonsHistory.setDouble(2, rsAddons.getDouble("windscreen_cost"));
                psInsertAddonsHistory.setDouble(3, rsAddons.getDouble("all_driver_cost"));
                psInsertAddonsHistory.setDouble(4, rsAddons.getDouble("special_perils_cost"));
                psInsertAddonsHistory.setDouble(5, rsAddons.getDouble("legal_liability_cost"));
                psInsertAddonsHistory.executeUpdate();
            }

            // Transfer data to VehicleHistory table
            if (rsVehicle.next()) {
                psInsertVehicleHistory.setInt(1, rsVehicle.getInt("quotation_id"));
                psInsertVehicleHistory.setString(2, rsVehicle.getString("owner_name"));
                psInsertVehicleHistory.setString(3, rsVehicle.getString("owner_id"));
                psInsertVehicleHistory.setDate(4, rsVehicle.getDate("dob"));
                psInsertVehicleHistory.setString(5, rsVehicle.getString("gender"));
                psInsertVehicleHistory.setString(6, rsVehicle.getString("marital_status"));
                psInsertVehicleHistory.setString(7, rsVehicle.getString("location"));
                psInsertVehicleHistory.setString(8, rsVehicle.getString("vehicle_type"));
                psInsertVehicleHistory.setString(9, rsVehicle.getString("local_import"));
                psInsertVehicleHistory.setString(10, rsVehicle.getString("registration_number"));
                psInsertVehicleHistory.setString(11, rsVehicle.getString("engine_number"));
                psInsertVehicleHistory.setString(12, rsVehicle.getString("chassis_number"));
                psInsertVehicleHistory.setDouble(13, rsVehicle.getDouble("insured_value"));
                psInsertVehicleHistory.setString(14, rsVehicle.getString("vehicle_body"));
                psInsertVehicleHistory.setString(15, rsVehicle.getString("vehicle_make"));
                psInsertVehicleHistory.setString(16, rsVehicle.getString("vehicle_model"));
                psInsertVehicleHistory.setInt(17, rsVehicle.getInt("manufacture_year"));
                psInsertVehicleHistory.setInt(18, rsVehicle.getInt("engine_capacity"));
                psInsertVehicleHistory.executeUpdate();
            }

            // Transfer data to PaymentHistory table
            if (rsPayment.next()) {
                psInsertPaymentHistory.setInt(1, rsPayment.getInt("quotation_id"));
                psInsertPaymentHistory.setString(2, rsPayment.getString("payment_method"));
                psInsertPaymentHistory.setDouble(3, rsPayment.getDouble("price"));
                // Set receipt_image from rsPayment as required
                psInsertPaymentHistory.setBytes(4, rsPayment.getBytes("receipt_image"));
                psInsertPaymentHistory.executeUpdate();
            }
        }
    }

    private void deleteFromOriginalTables(Connection conn, int quotationId) throws SQLException {
        String deleteQuotationSQL = "DELETE FROM Quotation WHERE quotation_id = ?";
        String deleteAddonsSQL = "DELETE FROM Addons WHERE quotation_id = ?";
        String deleteVehicleSQL = "DELETE FROM Vehicle WHERE quotation_id = ?";
        String deletePaymentSQL = "DELETE FROM Payment WHERE quotation_id = ?";

        try (PreparedStatement psDeleteQuotation = conn.prepareStatement(deleteQuotationSQL);
                PreparedStatement psDeleteAddons = conn.prepareStatement(deleteAddonsSQL);
                PreparedStatement psDeleteVehicle = conn.prepareStatement(deleteVehicleSQL);
                PreparedStatement psDeletePayment = conn.prepareStatement(deletePaymentSQL)) {

            psDeleteQuotation.setInt(1, quotationId);
            psDeleteAddons.setInt(1, quotationId);
            psDeleteVehicle.setInt(1, quotationId);
            psDeletePayment.setInt(1, quotationId);

            psDeleteQuotation.executeUpdate();
            psDeleteAddons.executeUpdate();
            psDeleteVehicle.executeUpdate();
            psDeletePayment.executeUpdate();
        }
    }
}
