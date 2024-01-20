<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String managerID = request.getParameter("userID");
    String roles = (String) session.getAttribute("roles");
    String firstname = "";
    String lastname = "";
    String ICNumber = "";
    String email = "";
    String phone = "";
    String password = "";
    String residence = "";
    String city = "";
    String zipcode = "";
    String state = "";

    if (managerID != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM manager WHERE userID = ? ");
            ps.setString(1, managerID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                managerID = rs.getString("userID");
                roles = rs.getString("roles");
                firstname = rs.getString("firstname");
                lastname = rs.getString("lastname");
                ICNumber = rs.getString("ICNumber");
                email = rs.getString("email");
                phone = rs.getString("phone");
                password = rs.getString("password");
                residence = rs.getString("residence");
                city = rs.getString("city");
                zipcode = rs.getString("zipcode");
                state = rs.getString("state");
                // Process retrieved data
            }
        } catch (SQLException e) {
            // Handle SQLException (print or log the error)
            e.printStackTrace();
            out.println("An error occurred while fetching customer data. Please try again later.");
        }
    } else {
        // Handle the case where customerID is not found in the request parameter
        out.println("userID not found in the request parameter.");
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Manager Details</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
    </head>

    <body>
        <div class="container mt-5">
            <h2>Update Manager Details</h2>
            <form action="processUpdateManager.jsp" method="post">
                <input type="hidden" name="managerID" value="<%= managerID%>">
                <div class="form-group">
                    <label for="firstname">Firstname:</label>
                    <input type="text" class="form-control" name="firstname" value="<%= firstname%>" >
                </div>

                <div class="form-group">
                    <label for="lastname">Lastname:</label>
                    <input type="text" class="form-control" name="lastname" value="<%= lastname%>" >
                </div>

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" class="form-control" name="email" value="<%= email%>" >
                </div>

                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="text" class="form-control" name="phone" value="<%= phone%>" >
                </div>

                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="text" class="form-control" name="password" value="<%= password%>" >
                </div>

                <!-- Add more form fields for other staff details -->

                <button type="submit" class="btn btn-primary">Update</button>
            </form>
        </div>

        <!-- Bootstrap JS (optional) -->
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>
    </body>
</html>
