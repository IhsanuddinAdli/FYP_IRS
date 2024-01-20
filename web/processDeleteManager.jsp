<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String managerIDToDelete = request.getParameter("managerID");

    if (managerIDToDelete != null && !managerIDToDelete.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String myURL = "jdbc:mysql://localhost/irs";
            Connection myConnection = DriverManager.getConnection(myURL, "root", "admin");

            // Delete staff record based on the staff ID
            String deleteQuery = "DELETE FROM manager WHERE userID = ?";
            PreparedStatement deletePS = myConnection.prepareStatement(deleteQuery);
            deletePS.setString(1, managerIDToDelete);

            int deleteResult = deletePS.executeUpdate();

            deletePS.close();
            myConnection.close();

            if (deleteResult > 0) {
                response.sendRedirect("managerList.jsp"); // Redirect to staff list page after successful deletion
            } else {
                out.println("Deletion failed. Please try again.");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Invalid manager ID for deletion.");
    }
%>
