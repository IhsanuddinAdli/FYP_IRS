<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.dao.DBConnection"%>
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
        // Handle the case where userID is not found in the session
        out.println("UserID not found in the session.");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>History Page</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
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
                            <li class=""><a href="customerQuoList.jsp"><i class="material-icons">list_alt</i> Quotations List</a></li>
                        </ul>
                    </li>
                    <li class="active">
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
                                                    if (userID != null) {
                                                        try {
                                                            Connection conn = DBConnection.getConnection();
                                                            PreparedStatement ps = conn.prepareStatement(
                                                                    "SELECT COUNT(*) AS count FROM QuotationHistory WHERE userID = ? AND notification_sent = TRUE");
                                                            ps.setString(1, userID);
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
                                                    <img src="getImage?userID=<%= userID%>&roles=<%= roles%>" alt="Avatar" class="img-fluid rounded-circle" style="width:40px; height:40px; border-radius:50%;" />                                                    <span class="xp-user-live"></span>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                        <div class="xp-breadcrumbbar text-center">
                            <h4 class="page-title">History</h4>
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
                        <h2>History of Vehicle Insurance Purchases</h2>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Registration Number</th>
                                    <th>Vehicle Type</th>
                                    <th>Vehicle Model</th>
                                    <th>Coverage</th>
                                    <th>Policy Expiry Date</th>
                                    <th>Company</th>
                                    <th>Price (RM)</th>
                                    <th>Cover Note</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Retrieve and display data from QuotationHistory, VehicleHistory, and PaymentHistory tables -->
                                <%
                                    if (userID != null) {
                                        try {
                                            Connection conn = DBConnection.getConnection();

                                            // Query to retrieve data from QuotationHistory table based on userID
                                            PreparedStatement stmt1 = conn.prepareStatement("SELECT * FROM QuotationHistory WHERE userID = ?");
                                            stmt1.setString(1, userID);
                                            ResultSet rs1 = stmt1.executeQuery();

                                            // Iterate through the result set and display data in table rows
                                            while (rs1.next()) {
                                                int quotationId = rs1.getInt("quotation_id");
                                                String coverage = rs1.getString("coverage");
                                                String company = rs1.getString("company");
                                                String policyExpiryDate = rs1.getString("policy_expiry_date");

                                                // Query to retrieve data from VehicleHistory table based on quotationId
                                                PreparedStatement stmt2 = conn.prepareStatement("SELECT * FROM VehicleHistory WHERE quotation_id = ?");
                                                stmt2.setInt(1, quotationId);
                                                ResultSet rs2 = stmt2.executeQuery();

                                                // Iterate through the result set and display data in table rows
                                                while (rs2.next()) {
                                                    String registrationNumber = rs2.getString("registration_number");
                                                    String vehicleType = rs2.getString("vehicle_type");
                                                    String vehicleModel = rs2.getString("vehicle_model");

                                                    // Query to retrieve data from PaymentHistory table based on quotationId
                                                    PreparedStatement stmt3 = conn.prepareStatement("SELECT * FROM PaymentHistory WHERE quotation_id = ?");
                                                    stmt3.setInt(1, quotationId);
                                                    ResultSet rs3 = stmt3.executeQuery();

                                                    // Iterate through the result set and display data in table rows
                                                    while (rs3.next()) {
                                                        double price = rs3.getDouble("price");
                                %>
                                <tr>
                                    <td><%= registrationNumber%></td>
                                    <td><%= vehicleType%></td>
                                    <td><%= vehicleModel%></td>
                                    <td><%= coverage%></td>
                                    <td><%= policyExpiryDate%></td>
                                    <td><%= company%></td>
                                    <td><%= price%></td>
                                    <td>
                                        <%
                                            // Query to retrieve the cover_note from QuotationHistory table based on quotationId
                                            PreparedStatement stmt4 = conn.prepareStatement("SELECT cover_note FROM QuotationHistory WHERE quotation_id = ?");
                                            stmt4.setInt(1, quotationId);
                                            ResultSet rs4 = stmt4.executeQuery();

                                            // Check if the result set has data
                                            if (rs4.next()) {
                                                // Retrieve the cover_note binary data
                                                byte[] coverNoteData = rs4.getBytes("cover_note");
                                                // Check if coverNoteData is not null and has content
                                                if (coverNoteData != null && coverNoteData.length > 0) {
                                                    // Output a link to download or view the PDF
%>
                                        <a href="viewPDF?id=<%= quotationId%>" class="btn btn-primary" target="_blank">View Cover Note</a>
                                        <%
                                        } else {
                                        %>
                                        No file uploaded
                                        <%
                                                }
                                            }
                                            rs4.close();
                                            stmt4.close();
                                        %>
                                    </td>
                                </tr>
                                <%
                                                    }
                                                    rs3.close();
                                                    stmt3.close();
                                                }
                                                rs2.close();
                                                stmt2.close();
                                            }
                                            rs1.close();
                                            stmt1.close();
                                            conn.close();
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    } else {
                                        out.println("UserID not found in the session.");
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
    </body>
</html>
