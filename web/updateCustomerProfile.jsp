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

            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");

                String query = "UPDATE customer SET firstname=?, lastname=?, ICNumber=?, email=?, phone=?, password=?, residence=?, zipcode=?, city=?, state=? WHERE userID=?";
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
                    preparedStatement.setString(11, userID);

                    int rowsUpdated = preparedStatement.executeUpdate();

                    if (rowsUpdated > 0) {
                        out.println("Customer updated successfully.");
                    } else {
                        out.println("Customer not found or couldn't be updated.");
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
        %>
        <script>
            window.location.href = '<%= contextPath%>/customerProfile.jsp';
        </script>
    </body>
</html>
