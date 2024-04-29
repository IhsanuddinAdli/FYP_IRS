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
        <title>Calculate Quotation</title>
    </head>
    <body>
        <%
        // Retrieve quotation ID from request parameter
            int quotationId = Integer.parseInt(request.getParameter("quotationId"));

        // Initialize variables for data retrieval
            String vehicleType = "";
            String coverage = "";

        // Initialize connection and prepared statement
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                // Establish database connection
                conn = DBConnection.getConnection();

                // Prepare SQL statement to retrieve vehicle type and coverage based on quotation ID
                String sql = "SELECT vehicle_type, coverage FROM Quotation q INNER JOIN Vehicle v ON q.quotation_id = v.quotation_id WHERE q.quotation_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, quotationId);

                // Execute the query
                ResultSet rs = pstmt.executeQuery();

                // Check if a row is found
                if (rs.next()) {
                    vehicleType = rs.getString("vehicle_type");
                    coverage = rs.getString("coverage");
                } else {
                    // Handle case where no data is found for the given quotation ID
                    // You can redirect to an error page or display an error message here
                    out.println("No data found for the given quotation ID.");
                }

                // Close the result set
                rs.close();
            } catch (SQLException e) {
                // Handle SQL exception
                e.printStackTrace();
            } finally {
                // Close prepared statement and connection
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }

        // Set attributes to pass to the redirected page
            request.setAttribute("quotationId", quotationId);
            request.setAttribute("vehicleType", vehicleType);
            request.setAttribute("coverage", coverage);

        // Redirect to the appropriate page based on vehicleType and coverage
            String redirectUrl = "";
            switch (vehicleType) {
                case "Car":
                    redirectUrl = coverage.equals("comprehensive") ? "carComprehensive.jsp"
                            : coverage.equals("third-party-fire-theft") ? "carTPFT.jsp" : "";
                    break;
                case "Motorcycle":
                    redirectUrl = coverage.equals("comprehensive") ? "motoComprehensive.jsp"
                            : coverage.equals("third-party-motorcycle") ? "motoTP.jsp" : "";
                    break;
                case "Van":
                    redirectUrl = coverage.equals("comprehensive") ? "vanComprehensive.jsp"
                            : coverage.equals("third-party-fire-theft") ? "vanTPFT.jsp" : "";
                    break;
                case "Lorry":
                    redirectUrl = coverage.equals("comprehensive") ? "lorryComprehensive.jsp"
                            : coverage.equals("third-party-fire-theft") ? "lorryTPFT.jsp" : "";
                    break;
                default:
                    break;
            }

        // Check if redirect URL is not empty
            if (!redirectUrl.isEmpty()) {
                // Dispatch the request to the redirected page
                RequestDispatcher dispatcher = request.getRequestDispatcher(redirectUrl);
                dispatcher.forward(request, response);
            } else {
                // Handle case where redirect URL is empty
                // You can redirect to an error page or display an error message here
                out.println("Invalid vehicle type or coverage.");
            }
        %>
    </body>
</html>
