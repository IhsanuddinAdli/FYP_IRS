<%@ page import="java.sql.*" %>
<%@ page import="com.model.Register" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Page</title>
    </head>
    <body>
        <jsp:useBean id="staff" class="com.model.Register" scope="request"/>

        <%
            staff.setFirstname(request.getParameter("firstname"));
            staff.setLastname(request.getParameter("lastname"));
            staff.setEmail(request.getParameter("email"));
            staff.setPhone(request.getParameter("phone"));
            staff.setPassword(request.getParameter("password"));

            // Debug output
            out.println("Roles Parameter: " + request.getParameter("roles"));

            staff.setRoles(request.getParameter("roles"));

            int result;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                String myURL = "jdbc:mysql://localhost/irs";
                Connection myConnection = DriverManager.getConnection(myURL, "root", "admin");

                String sInsertQry = "INSERT INTO staff(firstname, lastname, email, phone, password, roles) VALUES (?,?,?,?,?,?) ";

                PreparedStatement myPS = myConnection.prepareStatement(sInsertQry);

                myPS.setString(1, staff.getFirstname());
                myPS.setString(2, staff.getLastname());
                myPS.setString(3, staff.getEmail());
                myPS.setString(4, staff.getPhone());
                myPS.setString(5, staff.getPassword());
                myPS.setString(6, staff.getRoles());

                result = myPS.executeUpdate();

                myPS.close();
                myConnection.close();

                if (result > 0) {
                    response.sendRedirect("staffList.jsp"); // Redirect to staff list page
                } else {
                    out.println("Registration failed. Please try again."); // Display error message
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
    </body>
</html>
