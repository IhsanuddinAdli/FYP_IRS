package com.controller;

import java.io.IOException;
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
            response.sendRedirect("customerFeedback.jsp?status=error&message=Invalid+number+format");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("customerFeedback.jsp?status=error&message=" + e.getMessage().replace(" ", "+"));
        } catch (ClassNotFoundException e) {
            response.sendRedirect("customerFeedback.jsp?status=error&message=Class+Not+Found");
        } catch (Exception e) {
            response.sendRedirect("customerFeedback.jsp?status=error&message=Unexpected+Error");
        }
    }
}
