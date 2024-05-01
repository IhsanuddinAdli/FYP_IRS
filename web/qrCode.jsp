<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Payment Page</title>
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
    </head>

    <body>
        <%
            String userID = (String) session.getAttribute("userID");
            Integer quotationId = (Integer) request.getAttribute("quotationId");
        %>
        <div class="wrapper">

            <div class="body-overlay"></div>

            <!-------sidebar--design------------>

            <div id="sidebar">
                <div class="sidebar-header">
                    <h3><img src="IMG/IRS.png" class="img-fluid" /><span>GuardWheels : IRS</span></h3>
                </div>
                <ul class="list-unstyled component m-0">
                    <li class="">
                        <a href="customerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>dashboard </a>
                    </li>
                    <li class="">
                        <a href="customerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="active">
                        <a href="customerQuo.jsp" class=""><i class="material-icons">border_color</i>Quotation</a>
                    </li>
                    <li class="">
                        <a href="customerFeedback.jsp" class=""><i class="material-icons">library_books</i>Feedback</a>
                    </li>
                    <li class="">
                        <a href="#" class=""><i class="material-icons">date_range</i>History</a>
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

                                            <li class="nav-item">
                                                <a class="nav-link" href="#">
                                                    <span class="material-icons">question_answer</span>
                                                </a>
                                            </li>

                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="customerProfile.jsp">
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
                            <h4 class="page-title">Payment</h4>
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
                        <!-- Payment Page -->
                        <div id="payment-page" class="row">
                            <!-- Left Section for Payment Submission -->
                            <div id="left-section" class="col-md-6">
                                <div class="payment-details">
                                    <h3>Payment Submission</h3>
                                    <!-- Form for Payment Submission -->
                                    <div class="account-number">
                                        <h4>7632754905</h4>
                                        <p>Muhammad Ihsanuddin Bin Adli</p>
                                        <p>CIMB</p>
                                        <!-- Display Account Number Image -->
                                        <img src="IMG/qr_bank.jpeg" alt="QR Code">
                                    </div>
                                </div>
                                <form action="customerQuo.jsp" method="POST" enctype="multipart/form-data">
                                    <label for="receipt">Upload Receipt:</label>
                                    <input type="file" id="receipt" name="receipt" accept="image/*" required>

                                    <button type="submit">Submit Payment</button>
                                </form>
                            </div>

                            <!-- Right Section for Transaction Details and Price -->
                            <div id="right-section" class="col-md-6">
                                <div class="transaction-details">
                                    <h3>Transaction Details</h3>
                                    <!-- Display Transaction Details here -->
                                    <input type="hidden" id="userID" name="userID" value="<%= userID%>">
                                    <input type="hidden" id="quotationId" name="quotationId" value="<%= quotationId%>">
                                    <p>Registration Number: <%= request.getParameter("registrationNumber")%></p>
                                    <%
                                        // Get the current date and time
                                        java.time.LocalDateTime now = java.time.LocalDateTime.now();
                                        // Format date
                                        String formattedDate = now.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                                        // Format time
                                        String formattedTime = now.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss"));
                                    %>
                                    <p>Date of Transaction: <%= formattedDate%></p>
                                    <p>Time of Transaction: <%= formattedTime%></p>
                                    <p>Policy Commencement Date: <%= request.getParameter("policyCommencementDate")%></p>
                                    <p>Policy Duration: <%= request.getParameter("policyDuration")%> years</p>
                                    <p>Policy Expiry Date: <%= request.getParameter("policyExpiryDate")%></p>
                                    <p>Your insurance price is: RM <%= request.getParameter("finalTotalPremium")%></p>
                                </div>
                            </div>
                        </div>
                        <!-- Payment Page End -->
                    </div>
                </div>
                <!-- Main content end -->

                <!----footer-design------------->

                <footer class="footer">
                    <div class="container-fluid">
                        <div class="footer-in">
                            <p class="mb-0">&copy 2021 Vishweb Design . All Rights Reserved.</p>
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
