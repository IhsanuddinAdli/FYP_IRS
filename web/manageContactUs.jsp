<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.Calendar"%>
<%@page import="com.dao.DBConnection"%>
<%
    String roles = (String) session.getAttribute("roles");
    String userID = (String) session.getAttribute("userID");
    boolean hasImage = false;

    if (userID != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");

            // Check if user has uploaded an image
            PreparedStatement psImage = con.prepareStatement("SELECT profileIMG FROM manager WHERE userID = ?");
            psImage.setString(1, userID);
            ResultSet rsImage = psImage.executeQuery();
            if (rsImage.next()) {
                hasImage = rsImage.getBlob("profileIMG") != null;
            }
        } catch (SQLException e) {
            // Handle SQLException (print or log the error)
            e.printStackTrace();
            out.println("An error occurred while fetching data. Please try again later.");
        }
    } else {
        // Handle the case where userID is not found in the session
        out.println("UserID not found in the session.");
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Manage Contact Us</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="CSS/customerNotify.css">
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css">
        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!-- Google Material Icons -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>
    <body>
        <div class="wrapper">
            <div class="body-overlay"></div>
            <div id="sidebar">
                <div class="sidebar-header">
                    <h3><img src="IMG/IRS.png" class="img-fluid" /><span>GuardWheels : IRS</span></h3>
                </div>
                <ul class="list-unstyled component m-0">
                    <li class=""><a href="managerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard</a></li>
                    <li class=""><a href="managerProfile.jsp"><i class="material-icons">account_circle</i>Profile</a></li>
                    <li class=""><a href="customerNotify.jsp"><i class="material-icons">notifications_active</i>Customer Notify</a></li>
                    <li class="active"><a href="manageContactUs.jsp" class=""><i class="material-icons">mark_email_unread</i>Contact Us</a></li>
                    <li class=""><a href="homePage.jsp"><i class="material-icons">power_settings_new</i>Sign Out</a></li>
                </ul>
            </div>
            <div id="content">
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
                                                <a class="nav-link" href="#" data-toggle="dropdown">
                                                    <span class="material-icons">notifications</span>
                                                </a>
                                            </li>
                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="managerProfile.jsp">
                                                    <img src="<%= hasImage ? "getImage?userID=" + userID + "&roles=" + roles : "IMG/avatar.jpg"%>" style="width:40px; height:40px; border-radius:50%;" />
                                                    <span class="xp-user-live"></span>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                        <div class="xp-breadcrumbbar text-center">
                            <h4 class="page-title">Contact Us</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Manager</a></li>
                            </ol>
                        </div>
                    </div>
                </div>
                <div class="main-content">
                    <div class="container-fluid">
                        <div class="card mb-4">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped" id="contactusTable" width="100%" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th>No.</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Message</th>
                                                <th>Timestamp</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    Connection conn = DBConnection.getConnection();
                                                    Statement stmt = conn.createStatement();
                                                    String query = "SELECT id, name, email, message, timestamp FROM contactus";
                                                    ResultSet rs = stmt.executeQuery(query);
                                                    int rowNum = 1;
                                                    while (rs.next()) {
                                                        int id = rs.getInt("id");
                                                        String name = rs.getString("name");
                                                        String email = rs.getString("email");
                                                        String message = rs.getString("message");
                                                        Timestamp timestamp = rs.getTimestamp("timestamp");
                                            %>
                                            <tr>
                                                <td><%= rowNum++%></td>
                                                <td><%= name%></td>
                                                <td><%= email%></td>
                                                <td><%= message%></td>
                                                <td><%= timestamp%></td>
                                                <td>
                                                    <a href="mailto:<%= email%>?subject=Response to your message&body=Dear <%= name%>,%0D%0A%0D%0A" class="btn btn-primary btn-sm">Send Email</a>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                                rs.close();
                                                stmt.close();
                                                conn.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            %>
                                            <tr>
                                                <td colspan="6">Error retrieving data: <%= e.getMessage()%></td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
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
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>
        <script src="JS/jquery-3.3.1.min.js"></script>
        <!-- DataTables JavaScript -->
        <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap4.min.js"></script>
        <script>
            $(document).ready(function () {
                $('#contactusTable').DataTable({
                    "order": [],
                    "columnDefs": [
                        {"orderable": false, "targets": [0]}
                    ]
                });

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
