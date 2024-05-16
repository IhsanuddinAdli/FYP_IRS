package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class QuotationDAO {

    public static void updateCompanyName(Connection conn, int quotationId, String companyName) throws SQLException {
        String sql = "UPDATE quotation SET company = ? WHERE quotation_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, companyName);
            stmt.setInt(2, quotationId);
            stmt.executeUpdate();
        }
    }
}
