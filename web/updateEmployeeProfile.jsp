<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Profile</title>
    </head>
    <body>
        <h1>Update Profile</h1>
        <%
            String userID = request.getParameter("userID");
            String firstname = request.getParameter("firstname");
            String lastname = request.getParameter("lastname");
            String ICNumber = request.getParameter("ICNumber");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String residence = request.getParameter("residence");
            String zipcode = request.getParameter("zipcode");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String roles = request.getParameter("roles"); // Replace with actual role obtained from session

            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");

                String query = ""; // Initialize the query

                // Adjust the query based on the user's role
                switch (roles) {
                    case "staff":
                        query = "UPDATE staff SET firstname=?, lastname=?, ICNumber=?, email=?, phone=?, password=?, residence=?, zipcode=?, city=?, state=? WHERE userID=?";
                        break;
                    case "manager":
                        query = "UPDATE manager SET firstname=?, lastname=?, ICNumber=?, email=?, phone=?, password=?, residence=?, zipcode=?, city=?, state=? WHERE userID=?";
                        break;
                    case "admin":
                        query = "UPDATE admin SET firstname=?, lastname=?, ICNumber=?, email=?, phone=?, password=?, residence=?, zipcode=?, city=?, state=? WHERE userID=?";
                        break;
                    default:
                        out.println("Invalid user role");
                        return;
                }

                try (PreparedStatement preparedStatement = con.prepareStatement(query)) {
                    preparedStatement.setString(1, firstname);
                    preparedStatement.setString(2, lastname);
                    preparedStatement.setString(3, ICNumber);
                    preparedStatement.setString(4, email);
                    preparedStatement.setString(5, phone);
                    preparedStatement.setString(6, password);
                    preparedStatement.setString(7, residence);
                    preparedStatement.setInt(8, Integer.parseInt(zipcode)); // Assuming zipcode is an integer
                    preparedStatement.setString(9, city);
                    preparedStatement.setString(10, state);
                    preparedStatement.setString(11, userID); // Assuming staffID, managerID, adminID are correct column names

                    int rowsUpdated = preparedStatement.executeUpdate();

                    if (rowsUpdated > 0) {
                        out.println(roles + " updated successfully.");
                    } else {
                        out.println(roles + " not found or couldn't be updated.");
                    }
                } catch (SQLException e) {
                    out.println("SQL Error: " + e.getMessage());
                }

                con.close();
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>

        <%-- Redirect to profile.jsp  --%>
        <%
            String contextPath = request.getContextPath();
            String encodedRole = java.net.URLEncoder.encode(roles, "UTF-8");
        %>
        <script>
            var redirectURL = '<%= contextPath%>/';

            switch ('<%= roles%>') {
                case 'staff':
                    redirectURL += 'staffProfile.jsp';
                    break;
                case 'admin':
                    redirectURL += 'adminProfile.jsp';
                    break;
                case 'manager':
                    redirectURL += 'managerProfile.jsp';
                    break;
                default:
                    // Handle other roles or provide a default redirection
                    break;
            }

            window.location.href = redirectURL;
        </script>

    </body>
</html>
