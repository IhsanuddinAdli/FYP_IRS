<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.Calendar"%>
<%@page import="com.dao.DBConnection"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Customer Notifications</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/managerDash.css">
        <!--oogle fonts -->
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
                    <li>
                        <a href="managerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard </a>
                    </li>
                    <li>
                        <a href="managerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="active">
                        <a href="customerNotify.jsp" class=""><i class="material-icons">notifications_active</i>Customer Notify</a>
                    </li>
                    <li>
                        <a href="managerReport.jsp" class=""><i class="material-icons">library_books</i>Report</a>
                    </li>
                    <li>
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
                                                <a class="nav-link" href="managerProfile.jsp">
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
                            <h4 class="page-title">Customer Notifications</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Manager</a></li>
                                <!-- <li class="breadcrumb-item active" aria-curent="page">Dashboard</li> -->
                            </ol>
                        </div>
                    </div>
                </div>
                <!------top-navbar-end----------->
                <!----main-content--->
                <div class="main-content">
                    <div class="container">
                        <form method="POST" action="NotifyServlet">
                            <div class="row mb-3">
                                <div class="col">
                                    <div class="btn-group" role="group" aria-label="Month Navigation">
                                        <%
                                            String[] monthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                                            for (int i = 1; i <= 12; i++) {
                                        %>
                                        <button type="button" class="btn btn-secondary month-button" data-month="<%= i%>"><%= monthNames[i - 1]%></button>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="col">
                                    <select id="yearSelect" class="custom-select" aria-label="Year select" name="year">
                                        <option value="">Select Year</option>
                                        <%
                                            Calendar cal = Calendar.getInstance();
                                            int currentYear = cal.get(Calendar.YEAR);
                                            for (int i = currentYear; i <= currentYear + 5; i++) {
                                        %>
                                        <option value="<%= i%>"><%= i%></option>
                                        <% } %>
                                    </select>
                                </div>
                            </div>
                            <input type="hidden" name="month" id="hiddenMonth" />
                            <button type="submit" id="notifyButton" class="btn btn-primary mb-3">Notify All</button>
                            <button type="button" id="resetButton" class="btn btn-warning mb-3">Reset All</button>
                        </form>
                        <table id="customerTable" class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Customer Name</th>
                                    <th>Registration Number</th>
                                    <th>Owner Name</th>
                                    <th>Policy End Date</th>
                                    <th>Notification Sent</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Connection conn = DBConnection.getConnection();
                                        Statement stmt = conn.createStatement();
                                        String query = "SELECT c.firstname, c.lastname, vh.registration_number, vh.owner_name, qh.policy_expiry_date, qh.notification_sent "
                                                + "FROM Customer c "
                                                + "JOIN QuotationHistory qh ON c.userID = qh.userID "
                                                + "JOIN VehicleHistory vh ON qh.quotation_id = vh.quotation_id "
                                                + "ORDER BY MONTH(qh.policy_expiry_date)";
                                        ResultSet rs = stmt.executeQuery(query);
                                        while (rs.next()) {
                                            String customerName = rs.getString("firstname") + " " + rs.getString("lastname");
                                            String registrationNumber = rs.getString("registration_number");
                                            String ownerName = rs.getString("owner_name");
                                            Date policyEndDate = rs.getDate("policy_expiry_date");
                                            boolean notificationSent = rs.getBoolean("notification_sent");
                                %>
                                <tr>
                                    <td><%= customerName%></td>
                                    <td><%= registrationNumber%></td>
                                    <td><%= ownerName%></td>
                                    <td><%= policyEndDate%></td>
                                    <td class="notification-status"><%= notificationSent ? "✔️" : "Pending"%></td>
                                </tr>
                                <%
                                        }
                                        rs.close();
                                        stmt.close();
                                        conn.close();
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                %>
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

                $('.month-button').click(function () {
                    $(this).siblings().removeClass('active'); // Remove active class from other buttons
                    $(this).addClass('active'); // Add active class to clicked button
                    var month = $(this).data('month');
                    $('#hiddenMonth').val(month);
                    filterByMonthAndYear();
                });

                $('#yearSelect').change(filterByMonthAndYear);

                $('#notifyButton').click(function (e) {
                    e.preventDefault();  // Prevent the default form submission
                    var month = $('#hiddenMonth').val();
                    var year = $('#yearSelect').val();
                    if (!month || !year) {
                        alert('Please select both month and year.');
                        return false;
                    }
                    if (confirm("Are you sure you want to notify all customers for the selected month and year?")) {
                        // Only submit the form if user confirms
                        $(this).closest('form').submit();
                    }
                });

                function filterByMonthAndYear() {
                    var selectedMonth = $('.month-button.active').data('month');
                    var selectedYear = $('#yearSelect').val();
                    if (!selectedMonth || !selectedYear) {
                        return; // Do not proceed if either month or year is not selected
                    }

                    $('table#customerTable tbody tr').each(function () {
                        var policyEndDate = new Date($(this).find('td:eq(3)').text());
                        var policyMonth = policyEndDate.getMonth() + 1; // JavaScript months are zero-indexed
                        var policyYear = policyEndDate.getFullYear();

                        if (policyMonth === selectedMonth && policyYear === parseInt(selectedYear)) {
                            $(this).show();
                        } else {
                            $(this).hide();
                        }
                    });
                }

                $('#resetButton').click(function () {
                    var month = $('#hiddenMonth').val();
                    var year = $('#yearSelect').val();
                    if (!month || !year) {
                        alert('Please select both month and year.');
                        return false;
                    }
                    if (confirm("Are you sure you want to reset all notifications for the selected month and year?")) {
                        $.post('ResetNotifyServlet', {month: month, year: year}, function (response) {
                            alert('Notifications reset successfully!');
                            location.reload(); // Reload the page to show the reset status
                        }).fail(function () {
                            alert('Failed to reset notifications.');
                        });
                    }
                });
            });
        </script>
    </body>
</html>
