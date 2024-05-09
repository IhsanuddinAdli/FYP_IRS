package com.controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import com.dao.DBConnection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/uploadCoverNote")
@MultipartConfig(maxFileSize = 16177215) // Limit file size to around 16MB
public class UploadCoverNoteServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Get the PDF file as a part and the quotation ID from the request
        Part filePart = request.getPart("coverNotePdf");
        int quotationId = Integer.parseInt(request.getParameter("quotationId"));
        InputStream inputStream = null;
        if (filePart != null) {
            // Obtains input stream of the upload file
            inputStream = filePart.getInputStream();
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE QuotationHistory SET cover_note = ? WHERE quotation_id = ?";
            pstmt = conn.prepareStatement(sql);

            if (inputStream != null) {
                pstmt.setBlob(1, inputStream);
            }
            pstmt.setInt(2, quotationId);

            int row = pstmt.executeUpdate();
            if (row > 0) {
                request.setAttribute("message", "Cover note uploaded successfully.");
            } else {
                request.setAttribute("message", "No such quotation ID exists or no update was necessary.");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException ex) {
                    Logger.getLogger(UploadCoverNoteServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    Logger.getLogger(UploadCoverNoteServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            // Redirect with message
            String message = request.getAttribute("message") != null ? request.getAttribute("message").toString() : "Unknown error";
            response.sendRedirect("manageQuotation.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
        }
    }
}
