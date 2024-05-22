package com.controller;

import com.dao.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        Map<String, List<String>> userEmailsAndPolicies = new HashMap<>();

        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT c.userID, c.email, vh.registration_number, qh.policy_expiry_date "
                + "FROM Customer c "
                + "JOIN QuotationHistory qh ON c.userID = qh.userID "
                + "JOIN VehicleHistory vh ON qh.quotation_id = vh.quotation_id "
                + "WHERE MONTH(qh.policy_expiry_date) = ? AND YEAR(qh.policy_expiry_date) = ? AND qh.notification_sent = TRUE")) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int userID = rs.getInt("userID");
                String email = rs.getString("email");
                String registrationNumber = rs.getString("registration_number");
                Date policyEndDate = rs.getDate("policy_expiry_date");
                String messageDetail = "Vehicle " + registrationNumber + " policy ends on " + policyEndDate + ".";

                userEmailsAndPolicies.putIfAbsent(email, new ArrayList<String>());
                userEmailsAndPolicies.get(email).add(messageDetail);

                // Insert notification into the database
                try (PreparedStatement notificationPs = conn.prepareStatement(
                        "INSERT INTO Notifications (userID, message) VALUES (?, ?)")) {
                    notificationPs.setInt(1, userID);
                    notificationPs.setString(2, messageDetail);
                    notificationPs.executeUpdate();
                }
            }

            for (Map.Entry<String, List<String>> entry : userEmailsAndPolicies.entrySet()) {
                String toEmail = entry.getKey();
                String body = "Your insurance policies for the following vehicles are about to expire:\n" + String.join("\n", entry.getValue());
                EmailUtility.sendEmail(toEmail, "Insurance Expiry Notification", body);
            }
        }
    }
}
