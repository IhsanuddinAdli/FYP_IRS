package com.controller;

import com.dao.FeedbackDAO;
import com.model.Feedback;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/submitFeedback")
public class FeedbackServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
        String feedback = request.getParameter("feedback");
        int rating = Integer.parseInt(request.getParameter("rating"));
        int userID = Integer.parseInt(request.getParameter("userID"));

        // Create Feedback object
        Feedback feedbackObj = new Feedback();
        feedbackObj.setFeedback(feedback);
        feedbackObj.setRating(rating);
        feedbackObj.setUserID(userID);

        // Call DAO method to store feedback
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        boolean success = false;
        try {
            success = feedbackDAO.saveFeedback(feedbackObj);
        } catch (SQLException ex) {
            Logger.getLogger(FeedbackServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(FeedbackServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (success) {
            // Redirect to success page or show a success message
            response.sendRedirect("feedbackSuccess.jsp");
        } else {
            // Redirect to error page or show an error message
            response.sendRedirect("feedbackError.jsp");
        }
    }
}
