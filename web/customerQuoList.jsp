<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.dao.DBConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userID = (String) session.getAttribute("userID");
    String roles = (String) session.getAttribute("roles");
    if (userID != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM customer WHERE userID = ? ");
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                roles = rs.getString("roles");
            }
        } catch (SQLException e) {
            // Handle SQLException (print or log the error)
            e.printStackTrace();
            out.println("An error occurred while fetching customer data. Please try again later.");
        }
    } else {
        // Handle the case where customerID is not found in the session
        out.println("CustomerID not found in the session.");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Customer Quotation List</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="CSS/customerHistory.css">
        <!--google fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!--google material icon-->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>
    <body>
        <div class="wrapper">
            <div class="body-overlay"></div>
            <!-------sidebar--design------------>
            <div id="sidebar">
                <div class="sidebar-header">
                    <h3><img src="IMG/IRS.png" class="img-fluid" /><span>GuardWheels : IRS</span></h3>
                </div>
                <ul class="list-unstyled component m-0">
                    <li class="">
                        <a href="customerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard </a>
                    </li>
                    <li class="">
                        <a href="customerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="dropdown">
                        <a href="#quotationMenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <i class="material-icons">border_color</i>Quotation <b class="caret"></b>
                        </a>
                        <ul class="collapse list-unstyled menu" id="quotationMenu">
                            <li class=""><a href="customerQuo.jsp"><i class="material-icons">list</i> Quotation Form</a></li>
                            <li class="active"><a href="customerQuoList.jsp"><i class="material-icons">list_alt</i> Quotations List</a></li>
                        </ul>
                    </li>
                    <li class="">
                        <a href="customerHistory.jsp" class=""><i class="material-icons">date_range</i>History</a>
                    </li>
                    <li class="">
                        <a href="homePage.jsp" class=""><i class="material-icons">power_settings_new</i>Sign Out</a>
                    </li>
                </ul>
            </div>
            <!-------sidebar--design- close----------->
            <!-------page-content start----------->
            <div id="content">
                <!------top-navbar-start----------->
                <div class="top-navbar">
                    <div class="xd-topbar">
                        <div class="row">
                            <div class="col-2 col-md-1 col-lg-1 order-2 order-md-1 align-self-center">
                                <div class="xp-menubar">
                                    <span class="material-icons text-white">signal_cellular_alt</span>
                                </div>
                            </div>
                            <div class="col-md-5 col-lg-3 order-3 order-md-2"></div>
                            <div class="col-10 col-md-6 col-lg-8 order-1 order-md-3">
                                <div class="xp-profilebar text-right">
                                    <nav class="navbar p-0">
                                        <ul class="nav navbar-nav flex-row ml-auto">
                                            <li class="dropdown nav-item">
                                                <%
                                                    String userId = (String) session.getAttribute("userID");
                                                    if (userId != null) {
                                                        try {
                                                            Connection conn = DBConnection.getConnection();
                                                            PreparedStatement ps = conn.prepareStatement(
                                                                    "SELECT COUNT(*) AS count FROM QuotationHistory WHERE userID = ? AND notification_sent = TRUE");
                                                            ps.setString(1, userId);
                                                            ResultSet rs = ps.executeQuery();
                                                            if (rs.next() && rs.getInt("count") > 0) {
                                                                int notifications = rs.getInt("count");
                                                                out.println("<a class='nav-link' href='#' data-toggle='dropdown'><span class='material-icons'>notifications</span><span class='notification'>" + notifications + "</span></a>");
                                                                out.println("<ul class='dropdown-menu'><li><a href='#'>You have " + notifications + " new notifications.</a></li></ul>");
                                                            } else {
                                                                out.println("<a class='nav-link' href='#'><span class='material-icons'>notifications</span></a>");
                                                                out.println("<ul class='dropdown-menu'><li><a href='#'>No new notifications.</a></li></ul>");
                                                            }
                                                            rs.close();
                                                            ps.close();
                                                            conn.close();
                                                        } catch (SQLException e) {
                                                            e.printStackTrace();
                                                        }
                                                    }
                                                %>
                                            </li>
                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="customerProfile.jsp">
                                                    <img src="getImage?userID=<%= userID%>&roles=<%= roles%>" alt="Avatar" class="img-fluid rounded-circle" style="width:40px; height:40px; border-radius:50%;" />
                                                    <span class="xp-user-live"></span>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                        <div class="xp-breadcrumbbar text-center">
                            <h4 class="page-title">Customer Quotation List</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Customer</a></li>
                                <!-- <li class="breadcrumb-item active" aria-curent="page">Dashboard</li> -->
                            </ol>
                        </div>
                    </div>
                </div>
                <!------top-navbar-end----------->
                <!-- Main content start -->
                <div id="main-content-image">
                    <div class="container">
                        <h2>Customer Quotation List</h2>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Quotation ID</th>
                                    <th>Registration Number</th>
                                    <th>Vehicle Type</th>
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
//                                    String userID = (String) session.getAttribute("userID");

                                    // Check if userID is not null
                                    if (userID != null && !userID.isEmpty()) {
                                        try (Connection conn = DBConnection.getConnection();
                                                PreparedStatement pstmt = conn.prepareStatement("SELECT q.quotation_id, v.registration_number, v.vehicle_type, v.vehicle_model, v.manufacture_year, v.engine_capacity, q.coverage "
                                                        + "FROM Quotation q "
                                                        + "INNER JOIN Vehicle v ON q.quotation_id = v.quotation_id "
                                                        + "WHERE q.userID=?")) {
                                            pstmt.setString(1, userID);
                                            try (ResultSet rs = pstmt.executeQuery()) {
                                                // Loop through the result set and display each quotation
                                                while (rs.next()) {
                                                    int quotationId = rs.getInt("quotation_id");
                                                    String regNumber = rs.getString("registration_number");
                                                    String vehicleType = rs.getString("vehicle_type");
                                                    String vehicleModel = rs.getString("vehicle_model");
                                                    int manufactureYear = rs.getInt("manufacture_year");
                                                    int engineCapacity = rs.getInt("engine_capacity");
                                                    String coverage = rs.getString("coverage");

                                                    // Display the quotation details in a table row
                                %>
                                <tr>
                                    <td><%= quotationId%></td>
                                    <td><%= regNumber%></td>
                                    <td><%= vehicleType%></td>
                                    <td><%= vehicleModel%></td>
                                    <td><%= manufactureYear%></td>
                                    <td><%= engineCapacity%></td>
                                    <td><%= coverage%></td>
                                    <!-- Action buttons -->
                                    <td>
                                        <!--<a href="javascript:void(0);" onclick="confirmDelete(<%= quotationId%>)">Delete Quotation</a>-->
                                        <form action="calculateQuotation.jsp" method="POST">
                                            <input type="hidden" name="quotationId" value="<%= quotationId%>">
                                            <button type="submit" class="btn btn-primary">Calculate</button>
                                        </form>
                                        <button type="button" class="btn btn-danger"  onclick="confirmDelete(<%= quotationId%>)">Delete</button>
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
                </div>
                <!-- Main content end -->
                <!----footer-design------------->
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="footer-in">
                            <p class="mb-0">&copy; 2024 RAZ WAWASAN SDN BHD (ADLI YONG)</p>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>
        <script src="JS/jquery-3.3.1.min.js"></script>
        <script>
                                            $(document).ready(function () {
                                                $(".xp-menubar").on('click', function () {
                                                    $("#sidebar").toggleClass('active');
                                                    $("#content").toggleClass('active');
                                                });
                                                $('.xp-menubar,.body-overlay').on('click', function () {
                                                    $("#sidebar,.body-overlay").toggleClass('show-nav');
                                                });
                                            });
        </script>
        <!-- Confirmation Script -->
        <script>
            function confirmDelete(quotationId) {
                var confirmDelete = confirm("Are you sure you want to delete this quotation?");
                if (confirmDelete) {
                    window.location.href = "deleteQuotation.jsp?quotation_id=" + quotationId;
                }
            }
        </script>
    </body>
</html>
