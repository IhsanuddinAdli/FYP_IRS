package com.controller;

import com.dao.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ClearNotificationsServlet", value = "/ClearNotificationsServlet")
public class ClearNotificationsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userID");

        if (userId != null) {
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                            "UPDATE Notifications SET isRead = TRUE WHERE userID = ?")) {
                ps.setString(1, userId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(ClearNotificationsServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        response.sendRedirect("customerDash.jsp");
    }
}
