<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, com.dao.DBConnection" %>
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
        <title>Invoice - Cash on Delivery (COD)</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="CSS/customerPayment.css">
        <!-- Google fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!-- Google material icon -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <style>
            .invoice-container {
                padding: 30px;
                border: 1px solid #dee2e6;
                border-radius: 5px;
                background-color: #ffffff;
                width: 100%;
                margin: 0;
            }
            .invoice-header .company-details,
            .invoice-header .invoice-details {
                text-align: right;
            }
            .invoice-header .company-details h5,
            .invoice-header .invoice-details h5 {
                margin-top: 0;
            }
            .invoice-body .table thead th {
                border-bottom: 2px solid #dee2e6;
            }
            .invoice-footer {
                text-align: center;
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
                    <li><a href="customerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard</a></li>
                    <li><a href="customerProfile.jsp"><i class="material-icons">account_circle</i>Profile</a></li>
                    <li class="dropdown">
                        <a href="#quotationMenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle"><i class="material-icons">border_color</i>Quotation <b class="caret"></b></a>
                        <ul class="collapse list-unstyled menu" id="quotationMenu">
                            <li><a href="customerQuo.jsp"><i class="material-icons">list</i>Quotation Form</a></li>
                            <li><a href="customerQuoList.jsp"><i class="material-icons">list_alt</i>Quotations List</a></li>
                        </ul>
                    </li>
                    <li><a href="customerHistory.jsp"><i class="material-icons">date_range</i>History</a></li>
                    <li><a href="homePage.jsp"><i class="material-icons">power_settings_new</i>Sign Out</a></li>
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
                            <h4 class="page-title">Cash on Delivery (COD)</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Customer</a></li>
                            </ol>
                        </div>
                    </div>
                </div>
                <!------top-navbar-end----------->
                <!-- Main content start -->
                <div id="main-content-image">
                    <div class="container mt-5">
                        <!-- Invoice -->
                        <div class="invoice-container">
                            <div class="invoice-header">
                                <div class="row">
                                    <div class="col-sm-6 text-left">
                                        <h3>GuardWheels : IRS</h3>
                                        <address>
                                            Lot 822 B, Jalan Tengku Mizan, <br>
                                            Kg Duyong Besar<br>
                                            21300 Kuala Terengganu<br>
                                            Phone: 013-9816630<br>
                                            Email: <span class="no-transform">adliyong1974@yahoo.com</span>
                                        </address>
                                    </div>
                                    <div class="col-sm-6 text-right">
                                        <h3>Invoice</h3>
                                        <strong>Invoice Date:</strong> <%= java.time.LocalDate.now()%><br>
                                        <strong>Invoice Number:</strong> INV-<%= request.getParameter("quotationId")%>
                                    </div>
                                </div>
                            </div>
                            <div class="invoice-body">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <%
                                            Connection conn = null;
                                            PreparedStatement stmt = null;
                                            ResultSet rs = null;
                                            String customerName = "";

                                            try {
                                                conn = DBConnection.getConnection();
                                                String sql = "SELECT firstname, lastname FROM customer WHERE userID = ?";
                                                stmt = conn.prepareStatement(sql);
                                                stmt.setInt(1, Integer.parseInt(userID));
                                                rs = stmt.executeQuery();

                                                if (rs.next()) {
                                                    customerName = rs.getString("firstname") + " " + rs.getString("lastname");
                                                }
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            } finally {
                                                if (rs != null) try {
                                                    rs.close();
                                                } catch (SQLException e) {
                                                    e.printStackTrace();
                                                }
                                                if (stmt != null) try {
                                                    stmt.close();
                                                } catch (SQLException e) {
                                                    e.printStackTrace();
                                                }
                                                if (conn != null) try {
                                                    conn.close();
                                                } catch (SQLException e) {
                                                    e.printStackTrace();
                                                }
                                            }
                                        %>
                                        <%
                                            java.time.LocalDateTime now = java.time.LocalDateTime.now();
                                            String formattedDate = now.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                                            String formattedTime = now.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss"));
                                        %>
                                        <h5>Customer:</h5>
                                        <p><strong><%= customerName%></strong></p>
                                        <table class="table table-striped text-left">
                                            <thead>
                                                <tr>
                                                    <th>Description</th>
                                                    <th>Details</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>Company Name</td>
                                                    <td><%= request.getParameter("companyName")%></td>
                                                </tr>
                                                <tr>
                                                    <td>Registration Number</td>
                                                    <td><%= request.getParameter("registrationNumber")%></td>
                                                </tr>
                                                <tr>
                                                    <td>Date of Transaction</td>
                                                    <td><%= formattedDate%></td>
                                                </tr>
                                                <tr>
                                                    <td>Time of Transaction</td>
                                                    <td><%= formattedTime%></td>
                                                </tr>
                                                <tr>
                                                    <td>Policy Commencement Date</td>
                                                    <td><%= request.getParameter("policyCommencementDate")%></td>
                                                </tr>
                                                <tr>
                                                    <td>Policy Duration</td>
                                                    <td><%= request.getParameter("policyDuration")%> months</td>
                                                </tr>
                                                <tr>
                                                    <td>Policy Expiry Date</td>
                                                    <td><%= request.getParameter("policyExpiryDate")%></td>
                                                </tr>
                                                <tr>
                                                    <td>Insurance Price</td>
                                                    <td>RM <%= request.getParameter("finalTotalPremium")%></td>
                                                </tr>
                                                <tr>
                                                    <td>Additional Charge for COD</td>
                                                    <td>RM 10.00</td>
                                                </tr>
                                                <tr>
                                                    <td>Total Amount Payable</td>
                                                    <td>RM <%= String.format("%.2f", Double.parseDouble(request.getParameter("finalTotalPremium")) + 10.0)%></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="invoice-footer">
                                <form action="paymentSubmit" method="post" enctype="multipart/form-data">
                                    <input type="hidden" id="quotationId" name="quotationId" value="<%= request.getParameter("quotationId")%>">
                                    <input type="hidden" id="paymentMethod" name="paymentMethod" value="Cash on Delivery">
                                    <input type="hidden" id="formattedDate" name="formattedDate" value="<%= formattedDate%>">
                                    <input type="hidden" id="formattedTime" name="formattedTime" value="<%= formattedTime%>">
                                    <input type="hidden" id="finalTotalPremium" name="finalTotalPremium" value="<%= request.getParameter("finalTotalPremium")%>">
                                    <input type="hidden" id="paymentStatus" name="paymentStatus" value="Pending">
                                    <input type="hidden" id="companyName" name="companyName" value="<%= request.getParameter("companyName")%>">
                                    <button type="submit" class="btn btn-primary">Confirm Payment</button>
                                </form>
                            </div>
                        </div>
                        <!-- Invoice End -->
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
