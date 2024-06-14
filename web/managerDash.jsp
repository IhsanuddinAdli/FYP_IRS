<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
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
    boolean hasImage = false;

    int notified = 0;
    int notNotified = 0;

    Map<String, Integer> monthlyRegistrations = new LinkedHashMap<>();

    int verySatisfied = 0;
    int satisfied = 0;
    int neutral = 0;
    int dissatisfied = 0;
    int veryDissatisfied = 0;

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

            // Fetch notification status counts
            PreparedStatement psNotification = con.prepareStatement("SELECT notification_sent, COUNT(*) AS count FROM QuotationHistory GROUP BY notification_sent");
            ResultSet rsNotification = psNotification.executeQuery();
            while (rsNotification.next()) {
                if (rsNotification.getBoolean("notification_sent")) {
                    notified = rsNotification.getInt("count");
                } else {
                    notNotified = rsNotification.getInt("count");
                }
            }

            // Fetch customer engagement data
            PreparedStatement psEngagement = con.prepareStatement("SELECT DATE_FORMAT(registration_date, '%Y-%m') AS month, COUNT(*) AS count FROM customer GROUP BY month ORDER BY month");
            ResultSet rsEngagement = psEngagement.executeQuery();
            while (rsEngagement.next()) {
                String month = rsEngagement.getString("month");
                int count = rsEngagement.getInt("count");
                monthlyRegistrations.put(month, count);
            }

            // Fetch customer satisfaction data
            PreparedStatement psSatisfaction = con.prepareStatement("SELECT rating, COUNT(*) AS count FROM feedback GROUP BY rating");
            ResultSet rsSatisfaction = psSatisfaction.executeQuery();
            while (rsSatisfaction.next()) {
                int rating = rsSatisfaction.getInt("rating");
                int count = rsSatisfaction.getInt("count");
                switch (rating) {
                    case 5:
                        verySatisfied = count;
                        break;
                    case 4:
                        satisfied = count;
                        break;
                    case 3:
                        neutral = count;
                        break;
                    case 2:
                        dissatisfied = count;
                        break;
                    case 1:
                        veryDissatisfied = count;
                        break;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            out.println("An error occurred while fetching data. Please try again later.");
        }
    } else {
        out.println("UserID not found in the session.");
    }

    // Convert the data for the chart
    StringBuilder months = new StringBuilder();
    StringBuilder counts = new StringBuilder();
    DateFormatSymbols dfs = new DateFormatSymbols();
    for (Map.Entry<String, Integer> entry : monthlyRegistrations.entrySet()) {
        String[] parts = entry.getKey().split("-");
        String monthName = dfs.getMonths()[Integer.parseInt(parts[1]) - 1];
        String formattedMonth = monthName + " " + parts[0];

        if (months.length() > 0) {
            months.append(",");
            counts.append(",");
        }
        months.append("'").append(formattedMonth).append("'");
        counts.append(entry.getValue());
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, maximum-scale=1">
        <title>Manager Dashboard</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/managerDash.css">
        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!-- Google Material Icon -->
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
                        <a href="managerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard </a>
                    </li>
                    <li class="">
                        <a href="managerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="">
                        <a href="customerNotify.jsp" class=""><i class="material-icons">notifications_active</i>Customer Notify</a>
                    </li>
                    <li class="">
                        <a href="manageContactUs.jsp" class=""><i class="material-icons">mark_email_unread</i>Contact Us</a>
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
                            <h4 class="page-title">Dashboard</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Manager</a></li>
                                <!-- <li class="breadcrumb-item active" aria-current="page">Dashboard</li> -->
                            </ol>
                        </div>
                    </div>
                </div>
                <!------top-navbar-end----------->
                <!----main-content--->
                <div class="main-content">
                    <div class="container">
                        <!-- Customer Notifications Section -->
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4 d-flex align-items-center justify-content-center">
                                        <canvas id="customerNotificationChart" width="400" height="400"></canvas>
                                    </div>
                                    <div class="col-md-8 d-flex text-lg-left align-items-center">
                                        <div>
                                            <h5>Customer Notifications</h5><hr style="border: 1px solid">
                                            <p>This chart provides an overview of the notification statuses sent to customers. It categorizes notifications into two statuses:</p>
                                            <ul>
                                                <li><strong>Notified:</strong> Customers who have received notifications.</li>
                                                <li><strong>Not Yet Notified:</strong> Customers who have not yet received notifications.</li>
                                            </ul>
                                            <p>This chart helps in understanding the reach of notifications and identifying customers who may need follow-up actions.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Customer Engagement Section -->
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4 d-flex align-items-center justify-content-center">
                                        <canvas id="customerEngagementChart" width="400" height="400"></canvas>
                                    </div>
                                    <div class="col-md-8 d-flex text-lg-left align-items-center">
                                        <div>
                                            <h5>Customer Engagement</h5><hr style="border: 1px solid">
                                            <p>This chart displays the number of customer registrations per month, helping in understanding the engagement and growth of the customer base over time.</p>
                                            <ul>
                                                <li><strong>Monthly Registrations:</strong> The number of new customer registrations in each month.</li>
                                            </ul>
                                            <p>This chart helps in tracking the effectiveness of marketing campaigns and customer acquisition strategies.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Customer Satisfaction Section -->
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4 d-flex align-items-center justify-content-center">
                                        <canvas id="customerSatisfactionChart" width="400" height="400"></canvas>
                                    </div>
                                    <div class="col-md-8 d-flex text-lg-left align-items-center">
                                        <div>
                                            <h5>Customer Satisfaction</h5><hr style="border: 1px solid">
                                            <p>This chart provides an overview of customer satisfaction based on feedback ratings. The ratings are categorized into five levels:</p>
                                            <ul>
                                                <li><strong>Very Satisfied:</strong> Customers who rated their experience as very satisfied.</li>
                                                <li><strong>Satisfied:</strong> Customers who rated their experience as satisfied.</li>
                                                <li><strong>Neutral:</strong> Customers who rated their experience as neutral.</li>
                                                <li><strong>Dissatisfied:</strong> Customers who rated their experience as dissatisfied.</li>
                                                <li><strong>Very Dissatisfied:</strong> Customers who rated their experience as very dissatisfied.</li>
                                            </ul>
                                            <p>This chart helps in understanding customer sentiment and identifying areas for improvement in customer service and experience.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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
            });
        </script>

        <!-- Include Chart.js library -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
            // Customer Notifications Chart
            var customerNotificationCtx = document.getElementById('customerNotificationChart').getContext('2d');
            var customerNotificationChart = new Chart(customerNotificationCtx, {
                type: 'pie',
                data: {
                    labels: ['Notified', 'Not Yet Notified'],
                    datasets: [{
                            data: [<%=notified%>, <%=notNotified%>],
                            backgroundColor: ['#36a2eb', '#ff6384']
                        }]
                },
                options: {
                    legend: {
                        position: 'right'
                    }
                }
            });

            // Customer Engagement Chart
            var customerEngagementCtx = document.getElementById('customerEngagementChart').getContext('2d');
            var customerEngagementChart = new Chart(customerEngagementCtx, {
                type: 'line',
                data: {
                    labels: [<%= months.toString()%>],
                    datasets: [{
                            label: 'Customer Engagement',
                            data: [<%= counts.toString()%>],
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1,
                            fill: true
                        }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Customer Satisfaction Chart
            var customerSatisfactionCtx = document.getElementById('customerSatisfactionChart').getContext('2d');
            var customerSatisfactionChart = new Chart(customerSatisfactionCtx, {
                type: 'bar',
                data: {
                    labels: ['Very Satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very Dissatisfied'],
                    datasets: [{
                            label: 'Customer Satisfaction',
                            data: [<%=verySatisfied%>, <%=satisfied%>, <%=neutral%>, <%=dissatisfied%>, <%=veryDissatisfied%>],
                            backgroundColor: ['#4caf50', '#8bc34a', '#ffeb3b', '#ff9800', '#f44336']
                        }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        </script>
    </body>
</html>
