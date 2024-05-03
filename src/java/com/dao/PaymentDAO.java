package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.model.Payment;

public class PaymentDAO {

    public static void insertPayment(Connection conn, Payment payment) throws SQLException {
        String sql = "INSERT INTO Payment (quotation_id, payment_method, price, receipt_image, date_submitted, time_submitted) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, payment.getQuotationId());
            stmt.setString(2, payment.getPaymentMethod());
            stmt.setDouble(3, payment.getPrice());
            stmt.setBytes(4, payment.getReceiptImage());
            stmt.setDate(5, java.sql.Date.valueOf(payment.getDateSubmitted()));
            stmt.setTime(6, java.sql.Time.valueOf(payment.getTimeSubmitted()));
            stmt.executeUpdate();
        }
    }
}