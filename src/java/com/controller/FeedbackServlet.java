package com.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.FeedbackDAO;
import com.model.Feedback;

@WebServlet("/submitFeedback")
public class FeedbackServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIDStr = request.getParameter("userID");
        String quotationIdStr = request.getParameter("quotationId");
        String feedbackStr = request.getParameter("feedback");
        String ratingStr = request.getParameter("rating");

        try {
            int userID = Integer.parseInt(userIDStr);
            int quotationId = Integer.parseInt(quotationIdStr);
            int rating = Integer.parseInt(ratingStr);

            Feedback feedback = new Feedback(userID, quotationId, feedbackStr, rating);
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            feedbackDAO.insertFeedback(feedback);

            response.sendRedirect("feedbackSuccess.jsp?quotationId=" + quotationId + "&status=success");
        } catch (NumberFormatException e) {
            String errorMessage = URLEncoder.encode("Invalid number format", StandardCharsets.UTF_8.toString());
            response.sendRedirect("customerFeedback.jsp?status=error&message=" + errorMessage);
        } catch (SQLException e) {
            e.printStackTrace();
            String errorMessage = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8.toString());
            response.sendRedirect("customerFeedback.jsp?status=error&message=" + errorMessage);
        } catch (ClassNotFoundException e) {
            String errorMessage = URLEncoder.encode("Class Not Found", StandardCharsets.UTF_8.toString());
            response.sendRedirect("customerFeedback.jsp?status=error&message=" + errorMessage);
        } catch (Exception e) {
            String errorMessage = URLEncoder.encode("Unexpected Error", StandardCharsets.UTF_8.toString());
            response.sendRedirect("customerFeedback.jsp?status=error&message=" + errorMessage);
        }
    }
}
