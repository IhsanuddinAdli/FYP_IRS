package com.dao;

import com.model.Feedback;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public void insertFeedback(Feedback feedback) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO feedback (userID, quotation_id, feedback, rating) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedback.getUserID());
            ps.setInt(2, feedback.getQuotationId());
            ps.setString(3, feedback.getFeedback());
            ps.setInt(4, feedback.getRating());
            ps.executeUpdate();
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
