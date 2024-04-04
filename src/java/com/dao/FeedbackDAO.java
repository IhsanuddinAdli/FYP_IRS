package com.dao;

import com.model.Feedback;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    public List<Feedback> getAllFeedback() throws SQLException, ClassNotFoundException {
        List<Feedback> feedbackList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT * FROM feedback")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedback(rs.getString("feedback"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setUserID(rs.getInt("userID"));
                feedbackList.add(feedback);
            }
        }
        return feedbackList;
    }
}
