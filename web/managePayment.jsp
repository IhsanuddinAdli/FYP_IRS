<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.dao.DBConnection"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Payments</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Your custom CSS file -->
        <link rel="stylesheet" href="CSS/manageQuotation.css">
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
                        <a href="staffDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard </a>
                    </li>
                    <li class="">
                        <a href="staffProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="">
                        <a href="manageQuotation.jsp"><i class="material-icons">list_alt</i>Manage Quotation</a>
                    </li>
                    <li class="active">
                        <a href="managePayment.jsp" class=""><i class="material-icons">payment</i>Manage Payment</a>
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
                                                <a class="nav-link" href="#" data-toggle="dropdown">
                                                    <span class="material-icons">notifications</span>
                                                    <span class="notification">4</span>
                                                </a>
                                                <ul class="dropdown-menu">
                                                    <li><a href="#">You Have 4 New Messages</a></li>
                                                    <li><a href="#">You Have 4 New Messages</a></li>
                                                    <li><a href="#">You Have 4 New Messages</a></li>
                                                    <li><a href="#">You Have 4 New Messages</a></li>
                                                </ul>
                                            </li>
                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="staffProfile.jsp">
                                                    <img src="IMG/avatar.jpg" style="width:40px; border-radius:50%;" />
                                                    <span class="xp-user-live"></span>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                        <div class="xp-breadcrumbbar text-center">
                            <h4 class="page-title">Manage Payment</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Staff</a></li>
                            </ol>
                        </div>
                    </div>
                </div>
                <!------top-navbar-end----------->
                <!----main-content--->
                <div class="main-content">
                    <div class="container">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Payment ID</th>
                                    <th>Customer Name</th>
                                    <th>Payment Method</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Receipt Image</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% try {
                                        Connection conn = DBConnection.getConnection();
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(
                                                "SELECT ph.quotation_id, c.firstname, ph.payment_method, ph.price, ph.paymentStatus, ph.receipt_image "
                                                + "FROM PaymentHistory ph "
                                                + "JOIN QuotationHistory qh ON ph.quotation_id = qh.quotation_id "
                                                + "JOIN Customer c ON qh.userID = c.userID"
                                    );
                                    if (!rs.isBeforeFirst()) { %>
                                <tr>
                                    <td colspan="7">No data found</td>
                                </tr>
                                <% }
                                    while (rs.next()) {
                                        int paymentId = rs.getInt("quotation_id");
                                        String customerName = rs.getString("firstname");
                                        String paymentMethod = rs.getString("payment_method");
                                        double amount = rs.getDouble("price");
                                        String status = rs.getString("paymentStatus");
                                        Blob blob = rs.getBlob("receipt_image"); // Fetch the blob data
                                        String base64Image = "";
                                        if (blob != null) {
                                            InputStream inputStream = blob.getBinaryStream();
                                            byte[] buffer = new byte[inputStream.available()];
                                            inputStream.read(buffer);
                                            base64Image = Base64.getEncoder().encodeToString(buffer);
                                        }%>
                                <tr data-payment-id="<%= paymentId%>">
                                    <td><%= paymentId%></td>
                                    <td><%= customerName%></td>
                                    <td><%= paymentMethod%></td>
                                    <td>RM<%= amount%></td>
                                    <td><%= status%></td>
                                    <td>
                                        <% if (!base64Image.isEmpty()) {%>
                                        <img src="data:image/jpeg;base64,<%= base64Image%>" alt="Receipt Image" width="100">
                                        <% } else { %>
                                        No Image
                                        <% }%>
                                    </td>
                                    <td>
                                        <form action="managePayment" method="post">
                                            <input type="hidden" name="paymentId" value="<%= paymentId%>">
                                            <button type="submit" name="status" value="Approved" class="btn btn-success">Approve</button>
                                            <button type="submit" name="status" value="Rejected" class="btn btn-danger">Reject</button>
                                        </form>
                                    </td>
                                </tr>
                                <% }
                                        rs.close();
                                        stmt.close();
                                        conn.close();
                                    } catch (SQLException e) {
                                    e.printStackTrace();
                                } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!----main-content-end--->
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
        <!-------complete html----------->
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

            <%
                    String message = request.getParameter("message");
                    if (message != null && !message.isEmpty()) {
            %>
                alert('<%= message%>');
            <%
                    }
            %>
            });

            function confirmDelete(paymentId) {
                if (confirm('Are you sure you want to delete this payment?')) {
                    window.location.href = 'deletePayment?paymentId=' + paymentId;
                }
            }
        </script>
    </body>

</html>
