package com.controller;

import com.dao.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ResetNotifyServlet", value = "/ResetNotifyServlet")
public class ResetNotifyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int month = Integer.parseInt(request.getParameter("month"));
        int year = Integer.parseInt(request.getParameter("year"));
        HttpSession session = request.getSession();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE QuotationHistory qh JOIN Customer c ON qh.userID = c.userID "
                        + "SET qh.notification_sent = FALSE, qh.notification_date = NULL "
                        + "WHERE MONTH(qh.policy_expiry_date) = ? AND YEAR(qh.policy_expiry_date) = ?")) {
            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            pstmt.executeUpdate();

            // Clear notification count and message
            session.removeAttribute("notificationCount");
            session.setAttribute("notificationMessage", "All notifications for " + month + "/" + year + " have been reset.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error resetting notifications: " + e.getMessage());
            return;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ResetNotifyServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("Notifications reset successfully");
    }
}
