<%@ page import="java.sql.*" %>
<%@ page import="com.model.Register" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Page</title>
    </head>
    <body>
        <jsp:useBean id="manager" class="com.model.Register" scope="request"/>

        <%
            manager.setFirstname(request.getParameter("firstname"));
            manager.setLastname(request.getParameter("lastname"));
            manager.setEmail(request.getParameter("email"));
            manager.setPhone(request.getParameter("phone"));
            manager.setPassword(request.getParameter("password"));

            // Debug output
            out.println("Roles Parameter: " + request.getParameter("roles"));

            manager.setRoles(request.getParameter("roles"));

            int result;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                String myURL = "jdbc:mysql://localhost/irs";
                Connection myConnection = DriverManager.getConnection(myURL, "root", "admin");

                String sInsertQry = "INSERT INTO manager(firstname, lastname, email, phone, password, roles) VALUES (?,?,?,?,?,?) ";

                PreparedStatement myPS = myConnection.prepareStatement(sInsertQry);

                myPS.setString(1, manager.getFirstname());
                myPS.setString(2, manager.getLastname());
                myPS.setString(3, manager.getEmail());
                myPS.setString(4, manager.getPhone());
                myPS.setString(5, manager.getPassword());
                myPS.setString(6, manager.getRoles());

                result = myPS.executeUpdate();

                myPS.close();
                myConnection.close();

                if (result > 0) {
                    response.sendRedirect("managerList.jsp"); // Redirect to manager list page
                } else {
                    out.println("Registration failed. Please try again."); // Display error message
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
    </body>
</html>
