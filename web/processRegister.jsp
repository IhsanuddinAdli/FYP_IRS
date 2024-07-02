<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
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
            customer.setRoles(request.getParameter("roles"));

            int result = 0;
            boolean emailExists = false;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                String myURL = "jdbc:mysql://localhost/irs";

                try (Connection myConnection = DriverManager.getConnection(myURL, "root", "admin")) {
                    String checkEmailQuery = "SELECT COUNT(*) FROM customer WHERE email = ?";
                    try (PreparedStatement checkPS = myConnection.prepareStatement(checkEmailQuery)) {
                        checkPS.setString(1, customer.getEmail());
                        try (ResultSet rs = checkPS.executeQuery()) {
                            if (rs.next()) {
                                emailExists = rs.getInt(1) > 0;
                            }
                        }
                    }

                    if (!emailExists) {
                        String sInsertQry = "INSERT INTO customer(firstname, lastname, email, phone, password, roles) VALUES (?,?,?,?,?,?)";
                        try (PreparedStatement myPS = myConnection.prepareStatement(sInsertQry)) {
                            myPS.setString(1, customer.getFirstname());
                            myPS.setString(2, customer.getLastname());
                            myPS.setString(3, customer.getEmail());
                            myPS.setString(4, customer.getPhone());
                            myPS.setString(5, customer.getPassword());
                            myPS.setString(6, customer.getRoles());

                            result = myPS.executeUpdate();
                        }
                    }
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
            }

            if (emailExists) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Email is already registered. Please use a different email.');");
                out.println("location='register.jsp';");
                out.println("</script>");
            } else if (result > 0) {
                response.sendRedirect("login.jsp"); // Redirect to login page
            } else {
                out.println("Registration failed. Please try again."); // Display error message
            }
        %>
    </body>
</html>
