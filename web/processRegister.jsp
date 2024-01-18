<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Process Register Page</title>
    </head>
    <body>
        <jsp:useBean id="customer" class="com.model.Register" scope="request"/>
        <%
            customer.setFirstname(request.getParameter("firstname"));
            customer.setLastname(request.getParameter("lastname"));
            customer.setEmail(request.getParameter("email"));
            customer.setPhone(request.getParameter("phone"));
            customer.setPassword(request.getParameter("password"));

            int result = 0;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                String myURL = "jdbc:mysql://localhost/irs";

                try (Connection myConnection = DriverManager.getConnection(myURL, "root", "admin")) {
                    String sInsertQry = "INSERT INTO customer(firstname, lastname, email, phone, password) VALUES (?,?,?,?,?)";

                    try (PreparedStatement myPS = myConnection.prepareStatement(sInsertQry)) {
                        myPS.setString(1, customer.getFirstname());
                        myPS.setString(2, customer.getLastname());
                        myPS.setString(3, customer.getEmail());
                        myPS.setString(4, customer.getPhone());
                        myPS.setString(5, customer.getPassword());

                        result = myPS.executeUpdate();

                        // Print the number of rows affected for debugging
                        System.out.println("Rows affected: " + result);
                    }
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
            }

            if (result > 0) {
                response.sendRedirect("login.jsp"); // Redirect to login page
            } else {
                out.println("Registration failed. Please try again."); // Display error message
            }
        %>
    </body>
</html>
