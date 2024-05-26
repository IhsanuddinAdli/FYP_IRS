<%@page import="com.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
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

    List<String> notifications = new ArrayList<>();
    if (userID != null) {
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                        "SELECT message FROM Notifications WHERE userID = ? AND isRead = FALSE ORDER BY created_at DESC")) {
            ps.setString(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    notifications.add(rs.getString("message"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>QR Code Payment Page</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/customerPayment.css">
        <!--google fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!--google material icon-->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <style>
            .qr-details {
                text-align: center;
                margin-bottom: 20px;
                padding: 20px;
                border: 2px solid #000; /* Black border */
                border-radius: 10px; /* Rounded corners */
                background-color: #f8f9fa; /* Light background */
                box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* Subtle shadow for premium look */
            }
            .qr-details p {
                margin: 0;
                font-weight: bold;
                color: #333; /* Darker text color */
            }
            .qr-image-container {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-bottom: 20px;
            }
            .qr-image {
                width: 150px; /* Adjust the width as needed */
                height: auto;
            }
        </style>
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
                    <li class=""><a href="customerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>dashboard </a></li>
                    <li class=""><a href="customerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a></li>
                    <li class="dropdown">
                        <a href="#quotationMenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle"><i class="material-icons">border_color</i>Quotation <b class="caret"></b></a>
                        <ul class="collapse list-unstyled menu" id="quotationMenu">
                            <li class=""><a href="customerQuo.jsp"><i class="material-icons">list</i> Quotation Form</a></li>
                            <li class=""><a href="customerQuoList.jsp"><i class="material-icons">list_alt</i> Quotations List</a></li>
                        </ul>
                    </li>
                    <li class=""><a href="customerHistory.jsp" class=""><i class="material-icons">date_range</i>History</a></li>
                    <li class=""><a href="homePage.jsp" class=""><i class="material-icons">power_settings_new</i>Sign Out</a></li>
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
                                                <% if (notifications.size() > 0) {%>
                                                <a class="nav-link" href="#" data-toggle="dropdown">
                                                    <span class="material-icons">notifications</span>
                                                    <span class="notification"><%= notifications.size()%></span>
                                                </a>
                                                <ul class="dropdown-menu">
                                                    <% for (String notification : notifications) {%>
                                                    <li><a href="#"><%= notification%></a></li>
                                                        <% } %>
                                                    <li class="dropdown-divider"></li>
                                                    <li>
                                                        <form method="post" action="ClearNotificationsServlet">
                                                            <button type="submit" class="btn btn-link" style="text-decoration: none;">Clear Notifications</button>
                                                        </form>
                                                    </li>
                                                </ul>
                                                <% } else { %>
                                                <a class="nav-link" href="#">
                                                    <span class="material-icons">notifications</span>
                                                </a>
                                                <ul class="dropdown-menu">
                                                    <li><a href="#">No new notifications.</a></li>
                                                </ul>
                                                <% }%>
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
                            <h4 class="page-title">QR Code Payment</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Customer</a></li>
                            </ol>
                        </div>
                    </div>
                </div>
                <!------top-navbar-end----------->
                <!-- Main content start -->
                <div id="main-content-image">
                    <div class="container">
                        <!-- Payment Page -->
                        <div id="payment-page" class="row">
                            <!-- Left Section for Payment Submission -->
                            <div id="left-section" class="col-md-6">
                                <div class="transaction-details">
                                    <h3>Transaction Details</h3>
                                    <p><strong>Company Name:</strong> <%= request.getParameter("companyName")%></p>
                                    <p><strong>Quotation ID:</strong> <%=request.getParameter("quotationId")%></p>
                                    <p><strong>Registration Number:</strong> <%= request.getParameter("registrationNumber")%></p>
                                    <%
                                        java.time.LocalDateTime now = java.time.LocalDateTime.now();
                                        String formattedDate = now.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                                        String formattedTime = now.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss"));
                                    %>
                                    <p><strong>Date of Transaction:</strong> <%= formattedDate%></p>
                                    <p><strong>Time of Transaction:</strong> <%= formattedTime%></p>
                                    <p><strong>Policy Commencement Date:</strong> <%= request.getParameter("policyCommencementDate")%></p>
                                    <p><strong>Policy Duration:</strong> <%= request.getParameter("policyDuration")%> months</p>
                                    <p><strong>Policy Expiry Date:</strong> <%= request.getParameter("policyExpiryDate")%></p>
                                    <p><strong>Your insurance price is:</strong> RM <%= request.getParameter("finalTotalPremium")%></p>
                                </div>
                            </div>
                            <!-- Right Section for QR Code and Payment Submission -->
                            <div id="right-section" class="col-md-6">
                                <div class="payment-details">
                                    <h3>Payment Submission</h3>
                                    <div class="qr-details">
                                        <p>7632754905</p>
                                        <p>CIMB</p>
                                        <p>Muhammad Ihsanuddin bin Adli</p>
                                    </div>
                                    <!-- Display QR code for payment -->
                                    <div class="qr-image-container">
                                        <img src="IMG/qr_bank.jpeg" alt="QR Code" class="qr-image">
                                    </div>
                                    <form action="paymentSubmit" method="POST" enctype="multipart/form-data" class="mt-4">
                                        <input type="hidden" id="quotationId" name="quotationId" value="<%= request.getParameter("quotationId")%>">
                                        <input type="hidden" id="paymentMethod" name="paymentMethod" value="QR Code">
                                        <input type="hidden" id="formattedDate" name="formattedDate" value="<%= formattedDate%>">
                                        <input type="hidden" id="formattedTime" name="formattedTime" value="<%= formattedTime%>">
                                        <input type="hidden" id="finalTotalPremium" name="finalTotalPremium" value="<%= request.getParameter("finalTotalPremium")%>">
                                        <input type="hidden" id="paymentStatus" name="paymentStatus" value="Pending">
                                        <input type="hidden" id="companyName" name="companyName" value="<%= request.getParameter("companyName")%>">
                                        <div class="form-group">
                                            <label for="receiptImage">Upload Payment Receipt</label>
                                            <input type="file" class="form-control-file" id="receiptImage" name="receiptImage" accept="image/*">
                                        </div>
                                        <button type="submit" class="btn btn-primary mt-2">Submit Payment</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- Payment Page End -->
                    </div>
                </div>
                <!-- Main content end -->
                <!----footer-design------------>
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
