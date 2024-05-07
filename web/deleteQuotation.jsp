<%@page import="java.sql.SQLException"%>
<%@page import="com.dao.DBConnection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Delete Quotation</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="CSS/customerHistory.css">
    </head>
    <body>
        <%
            // Retrieve quotationId from request parameter
            String quotationIdStr = request.getParameter("quotation_id");
            int quotationId = Integer.parseInt(quotationIdStr);

            // Initialize a boolean flag to track if deletion is successful
            boolean deletionSuccess = false;

            // Delete related data from child tables first
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement pstmt1 = conn.prepareStatement("DELETE FROM addons WHERE quotation_id=?");
                    PreparedStatement pstmt2 = conn.prepareStatement("DELETE FROM vehicle WHERE quotation_id=?");) {
                // Set quotation_id parameter
                pstmt1.setInt(1, quotationId);
                pstmt2.setInt(1, quotationId);

                // Execute deletion queries for child tables
                pstmt1.executeUpdate();
                pstmt2.executeUpdate();

                // After successfully deleting from child tables, delete from the parent table
                try (PreparedStatement pstmt3 = conn.prepareStatement("DELETE FROM quotation WHERE quotation_id=?")) {
                    // Set quotation_id parameter
                    pstmt3.setInt(1, quotationId);

                    // Execute deletion query for the parent table
                    int rowsAffected = pstmt3.executeUpdate();
                    if (rowsAffected > 0) {
                        // Deletion successful
                        deletionSuccess = true;
                    }
                }
            } catch (SQLException e) {
                // Error occurred during deletion
                out.println("Error deleting quotation: " + e.getMessage());
            }

            // Display success or failure message
            if (deletionSuccess) {
                out.println("<h2>Quotation deleted successfully!</h2>");
            } else {
                out.println("<h2>Error deleting quotation!</h2>");
            }
        %>

        <!-- Link back to customerQuoList.jsp -->
        <a href="customerQuoList.jsp">Back to Quotation List</a>

        <!-- Bootstrap JS -->
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>

    </body>
</html>
