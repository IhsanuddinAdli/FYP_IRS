<%@page import="java.sql.SQLException"%>
<%@page import="com.dao.DBConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer Quotation List</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="CSS/customerQuoList.css">
        <!-- Confirmation Script -->
        <script>
            function confirmDelete(quotationId) {
                var confirmDelete = confirm("Are you sure you want to delete this quotation?");
                if (confirmDelete) {
                    window.location.href = "deleteQuotation.jsp?quotation_id=" + quotationId;
                }
            }
        </script>
    </head>
    <body>

        <div class="container">
            <h2>Customer Quotation List</h2>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Quotation ID</th>
                        <th>Registration Number</th>
                        <th>Insured Value</th>
                        <th>Vehicle Model</th>
                        <th>Manufacture Year</th>
                        <th>Engine Capacity</th>
                        <th>Coverage</th>
                        <th>Action</th> <!-- New column for actions -->
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Retrieve userID from session
                        String userID = (String) session.getAttribute("userID");

                        // Check if userID is not null
                        if (userID != null && !userID.isEmpty()) {
                            try (Connection conn = DBConnection.getConnection();
                                    PreparedStatement pstmt = conn.prepareStatement("SELECT q.quotation_id, v.registration_number, v.insured_value, v.vehicle_model, v.manufacture_year, v.engine_capacity, q.coverage "
                                            + "FROM Quotation q "
                                            + "INNER JOIN Vehicle v ON q.quotation_id = v.quotation_id "
                                            + "WHERE q.userID=?")) {
                                pstmt.setString(1, userID);
                                try (ResultSet rs = pstmt.executeQuery()) {
                                    // Loop through the result set and display each quotation
                                    while (rs.next()) {
                                        int quotationId = rs.getInt("quotation_id");
                                        String regNumber = rs.getString("registration_number");
                                        double insuredValue = rs.getDouble("insured_value");
                                        String vehicleModel = rs.getString("vehicle_model");
                                        int manufactureYear = rs.getInt("manufacture_year");
                                        int engineCapacity = rs.getInt("engine_capacity");
                                        String coverage = rs.getString("coverage");

                                        // Display the quotation details in a table row
%>
                    <tr>
                        <td><%= quotationId%></td>
                        <td><%= regNumber%></td>
                        <td><%= insuredValue%></td>
                        <td><%= vehicleModel%></td>
                        <td><%= manufactureYear%></td>
                        <td><%= engineCapacity%></td>
                        <td><%= coverage%></td>
                        <!-- Action buttons -->
                        <td>
                            <a href="javascript:void(0);" onclick="confirmDelete(<%= quotationId%>)">Delete Quotation</a>
                            <form action="calculateQuotation.jsp" method="POST">
                                <input type="hidden" name="quotationId" value="<%= quotationId%>">
                                <button type="submit">Calculate</button>
                            </form>
                        </td>
                    </tr>
                    <%
                                    }
                                }
                            } catch (SQLException e) {
                                out.println("<tr><td colspan='8'>Error retrieving quotations: " + e.getMessage() + "</td></tr>");
                            }
                        } else {
                            out.println("<tr><td colspan='8'>No quotations found for the user.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- Bootstrap JS -->
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>

    </body>
</html>
