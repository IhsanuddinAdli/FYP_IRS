package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dao.DBConnection;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/deleteCoverNote")
public class DeleteCoverNoteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int quotationId = Integer.parseInt(request.getParameter("quotationId"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE QuotationHistory SET cover_note = NULL WHERE quotation_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quotationId);
            int row = pstmt.executeUpdate();
            if (row > 0) {
                request.setAttribute("message", "Cover note deleted successfully.");
            } else {
                request.setAttribute("message", "No such quotation ID exists or no update was necessary.");
            }
        } catch (SQLException e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DeleteCoverNoteServlet.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            String message = request.getAttribute("message") != null ? request.getAttribute("message").toString() : "Unknown error";
            response.sendRedirect("manageQuotation.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
        }
    }
}
