<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Manager Details</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Your custom CSS -->
        <!-- <link rel="stylesheet" href="your-custom.css"> -->
    </head>

    <body>
        <div class="container mt-5">
            <h2>Update Manager Details</h2>

            <%
                // Initialize variables
                String managerID = "";
                String firstname = "";
                String lastname = "";
                String email = "";
                String phone = "";
                String password = "";

                // Handle form submission and update staff details in the database
                if (request.getMethod().equalsIgnoreCase("post")) {
                    managerID = request.getParameter("managerID");
                    firstname = request.getParameter("firstname");
                    lastname = request.getParameter("lastname");
                    email = request.getParameter("email");
                    phone = request.getParameter("phone");
                    password = request.getParameter("password");

                    // Update staff details in the database
                    String updateQuery = "UPDATE manager SET firstname=?, lastname=?, email=?, phone=?, password=? WHERE userID=?";
                    try {
                        // Load the JDBC driver
                        Class.forName("com.mysql.jdbc.Driver");

                        // Connect to the database
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");

                        // Prepare the statement
                        PreparedStatement updateStmt = con.prepareStatement(updateQuery);
                        updateStmt.setString(1, firstname);
                        updateStmt.setString(2, lastname);
                        updateStmt.setString(3, email);
                        updateStmt.setString(4, phone);
                        updateStmt.setString(5, password);
                        updateStmt.setString(6, managerID);

                        // Execute the update query
                        int rowsUpdated = updateStmt.executeUpdate();

                        // Check if the update was successful
                        if (rowsUpdated > 0) {
            %>
            <div class="alert alert-success" role="alert">
                Manager details updated successfully!
            </div>
            <%
            } else {
            %>
            <div class="alert alert-danger" role="alert">
                Failed to update manager details.
            </div>
            <%
                        }

                        // Close resources
                        updateStmt.close();
                        con.close();
                    } catch (Exception e) {
                        out.println("Error: " + e.getMessage());
                    }
                }
            %>

            <form action="processUpdateManager.jsp" method="post">
                <!-- The existing code for displaying the form with staff details -->
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

                <button type="submit" class="btn btn-primary">Update</button>
            </form>
        </div>

        <!-- Bootstrap JS (optional) -->
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>
        <!-- Your custom JS -->
        <!-- <script src="your-custom.js"></script> -->
    </body>

</html>
