<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.Calendar"%>
<%@page import="com.dao.DBConnection"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Notifications</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="CSS/custom.css">
    </head>
    <body>
        <div class="container">
            <h2>Customer Notifications</h2>
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
        <!-- JavaScript Libraries -->
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script>
            $(document).ready(function () {
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
