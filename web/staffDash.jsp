<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String roles = (String) session.getAttribute("roles");
    String userID = (String) session.getAttribute("userID");

    int approvedPayments = 0;
    int rejectedPayments = 0;
    int pendingPayments = 0;

    int solvedQuotations = 0;
    int coverNoteUploadedQuotations = 0;
    int pendingQuotations = 0;

    Map<String, Double> monthlyTotalPrices = new HashMap<>();
    Map<String, Double> monthlyTotalProfits = new HashMap<>();

    if (userID != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");

            // Fetch payment status counts
            PreparedStatement psPayment = con.prepareStatement("SELECT paymentStatus, COUNT(*) AS count FROM PaymentHistory GROUP BY paymentStatus");
            ResultSet rsPayment = psPayment.executeQuery();
            while (rsPayment.next()) {
                String status = rsPayment.getString("paymentStatus");
                int count = rsPayment.getInt("count");
                if ("Approved".equalsIgnoreCase(status)) {
                    approvedPayments = count;
                } else if ("Rejected".equalsIgnoreCase(status)) {
                    rejectedPayments = count;
                } else if ("Pending".equalsIgnoreCase(status)) {
                    pendingPayments = count;
                }
            }

            // Fetch quotation status counts
            PreparedStatement psQuotation = con.prepareStatement("SELECT notification_sent, cover_note IS NOT NULL AS coverNoteUploaded, COUNT(*) AS count FROM QuotationHistory GROUP BY notification_sent, cover_note IS NOT NULL");
            ResultSet rsQuotation = psQuotation.executeQuery();
            while (rsQuotation.next()) {
                boolean notificationSent = rsQuotation.getBoolean("notification_sent");
                boolean coverNoteUploaded = rsQuotation.getBoolean("coverNoteUploaded");
                int count = rsQuotation.getInt("count");
                if (notificationSent || coverNoteUploaded) {
                    solvedQuotations += count;
                } else {
                    pendingQuotations += count;
                }
            }

            // Fetch total prices per month
            PreparedStatement psTotalPrice = con.prepareStatement("SELECT DATE_FORMAT(date_submitted, '%Y-%m') AS month, SUM(price) AS total FROM PaymentHistory GROUP BY month");
            ResultSet rsTotalPrice = psTotalPrice.executeQuery();
            while (rsTotalPrice.next()) {
                String month = rsTotalPrice.getString("month");
                double total = rsTotalPrice.getDouble("total");
                double profit = total * 0.1; // Calculate 10% profit
                monthlyTotalPrices.put(month, total);
                monthlyTotalProfits.put(month, profit);
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

    // Convert the data for the chart
    StringBuilder months = new StringBuilder();
    StringBuilder totals = new StringBuilder();
    StringBuilder profits = new StringBuilder();
    DateFormatSymbols dfs = new DateFormatSymbols();
    for (Map.Entry<String, Double> entry : monthlyTotalPrices.entrySet()) {
        String[] parts = entry.getKey().split("-");
        String monthName = dfs.getMonths()[Integer.parseInt(parts[1]) - 1];
        String formattedMonth = monthName + " " + parts[0];

        if (months.length() > 0) {
            months.append(",");
            totals.append(",");
            profits.append(",");
        }
        months.append("'").append(formattedMonth).append("'");
        totals.append(entry.getValue());
        profits.append(monthlyTotalProfits.get(entry.getKey()));
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
        <title>Staff dashboard</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/staffDash.css">
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
                    <li class="active">
                        <a href="staffDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard </a>
                    </li>
                    <li class="">
                        <a href="staffProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="">
                        <a href="manageQuotation.jsp"><i class="material-icons">list_alt</i>Manage Quotation</a>
                    </li>
                    <li class="">
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
                            <h4 class="page-title">Dashboard</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Staff</a></li>
                                <!-- <li class="breadcrumb-item active" aria-current="page">Dashboard</li> -->
                            </ol>
                        </div>
                    </div>
                </div>
                <!------top-navbar-end----------->
                <!----main-content--->
                <div class="main-content">
                    <!-- Content Section -->
                    <section>
                        <!-- Centered Dashboard Widgets -->
                        <div class="row justify-content-center">
                            <!-- Widget 1: Payment Status -->
                            <div class="col-lg-4 col-md-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title text-center">Payment Status</h5>
                                    </div>
                                    <div class="card-body text-center">
                                        <canvas id="paymentStatusChart" width="200" height="200"></canvas>
                                    </div>
                                </div>
                            </div>
                            <!-- Widget 2: Quotation Status -->
                            <div class="col-lg-4 col-md-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title text-center">Quotation Status</h5>
                                    </div>
                                    <div class="card-body text-center">
                                        <canvas id="quotationStatusChart" width="200" height="200"></canvas>
                                    </div>
                                </div>
                            </div>
                            <!-- Widget 3: Total Price Per Month -->
                            <div class="col-lg-4 col-md-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title text-center">Total Price and Profit Per Month</h5>
                                    </div>
                                    <div class="card-body text-center">
                                        <canvas id="totalPricePerMonthChart" width="200" height="200"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- End Centered Dashboard Widgets -->
                    </section>
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
            });
        </script>

        <!-- Include Chart.js library -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
            // Payment Status Chart
            var paymentStatusCtx = document.getElementById('paymentStatusChart').getContext('2d');
            var paymentStatusChart = new Chart(paymentStatusCtx, {
                type: 'pie',
                data: {
                    labels: ['Approved', 'Rejected', 'Pending'],
                    datasets: [{
                            data: [<%= approvedPayments%>, <%= rejectedPayments%>, <%= pendingPayments%>],
                            backgroundColor: ['#36a2eb', '#ff6384', '#ffcd56']
                        }]
                },
                options: {
                    legend: {
                        position: 'right'
                    }
                }
            });

            // Quotation Status Chart
            var quotationStatusCtx = document.getElementById('quotationStatusChart').getContext('2d');
            var quotationStatusChart = new Chart(quotationStatusCtx, {
                type: 'pie',
                data: {
                    labels: ['Solved', 'Pending'],
                    datasets: [{
                            data: [<%= solvedQuotations%>, <%= pendingQuotations%>],
                            backgroundColor: ['#4caf50', '#ff6384']
                        }]
                },
                options: {
                    legend: {
                        position: 'right'
                    }
                }
            });

            // Total Price Per Month Chart
            var totalPricePerMonthCtx = document.getElementById('totalPricePerMonthChart').getContext('2d');
            var totalPricePerMonthChart = new Chart(totalPricePerMonthCtx, {
                type: 'bar',
                data: {
                    labels: [<%= months.toString()%>],
                    datasets: [
                        {
                            label: 'Total Price',
                            data: [<%= totals.toString()%>],
                            backgroundColor: '#36a2eb'
                        },
                        {
                            label: 'Total Profit',
                            data: [<%= profits.toString()%>],
                            backgroundColor: '#ffcd56'
                        }
                    ]
                },
                options: {
                    legend: {
                        display: true
                    },
                    scales: {
                        x: {
                            beginAtZero: true
                        },
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        </script>
    </body>
</html>
