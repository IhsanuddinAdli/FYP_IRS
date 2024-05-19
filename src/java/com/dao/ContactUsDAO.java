package com.dao;

import com.model.ContactUs;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ContactUsDAO {

    public static void saveContactUs(ContactUs contactUs) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO ContactUs (name, email, message) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, contactUs.getName());
            ps.setString(2, contactUs.getEmail());
            ps.setString(3, contactUs.getMessage());
            ps.executeUpdate();
        }
    }
}
