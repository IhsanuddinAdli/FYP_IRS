package com.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dao.DBConnection;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/viewPDF")
public class ViewPDFServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int quotationId = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement("SELECT cover_note FROM QuotationHistory WHERE quotation_id = ?");
            stmt.setInt(1, quotationId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                byte[] pdfData = rs.getBytes("cover_note");
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "inline; filename=quotation_" + quotationId + ".pdf");
                OutputStream out = response.getOutputStream();
                out.write(pdfData);
                out.flush();
                out.close();
            } else {
                response.getWriter().println("PDF not found for quotation ID: " + quotationId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error retrieving PDF data: " + e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ViewPDFServlet.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ViewPDFServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ViewPDFServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ViewPDFServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
}
