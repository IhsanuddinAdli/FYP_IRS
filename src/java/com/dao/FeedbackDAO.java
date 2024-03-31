package com.dao;

import com.model.Feedback;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class FeedbackDAO {

    public boolean saveFeedback(Feedback feedback) throws SQLException, ClassNotFoundException {
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement("INSERT INTO feedback (feedback, rating, userID) VALUES (?, ?, ?)")) {
            ps.setString(1, feedback.getFeedback());
            ps.setInt(2, feedback.getRating());
            ps.setInt(3, feedback.getUserID());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
