package com.controller;

import com.dao.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "NotifyServlet", value = "/NotifyServlet")
public class NotifyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int month = Integer.parseInt(request.getParameter("month"));
        int year = Integer.parseInt(request.getParameter("year"));
        HttpSession session = request.getSession();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE QuotationHistory qh JOIN Customer c ON qh.userID = c.userID "
                        + "SET qh.notification_sent = TRUE, qh.notification_date = NOW() "
                        + "WHERE MONTH(qh.policy_expiry_date) = ? AND YEAR(qh.policy_expiry_date) = ? AND qh.notification_sent = FALSE",
                        Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            int count = pstmt.executeUpdate();

            if (count > 0) {
                session.setAttribute("notificationCount", count);
                session.setAttribute("notificationMessage", "Sent notifications to " + count + " customers for policies expiring in " + month + "/" + year + ".");
                sendEmailToAffectedUsers(conn, month, year);
            } else {
                session.removeAttribute("notificationCount");
                session.removeAttribute("notificationMessage");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        response.sendRedirect("customerNotify.jsp");
    }

    private void sendEmailToAffectedUsers(Connection conn, int month, int year) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT email FROM Customer c JOIN QuotationHistory qh ON c.userID = qh.userID "
                + "WHERE MONTH(qh.policy_expiry_date) = ? AND YEAR(qh.policy_expiry_date) = ? AND qh.notification_sent = TRUE")) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String email = rs.getString("email");
                EmailUtility.sendEmail(email, "Insurance Expiry Notification", "Your insurance is about to expire. Please renew it as soon as possible.");
            }
        }
    }
}
