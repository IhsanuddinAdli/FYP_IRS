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
        <!-- Custom CSS similar to Manage Payments -->
        <link rel="stylesheet" href="CSS/managePayment.css">
    </head>
    <body>
        <div class="container">
            <h2>Customer Notifications</h2>
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
                    <select id="yearSelect" class="form-select" aria-label="Year select">
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
            <button id="notifyButton" class="btn btn-primary mb-3">Notify All</button>
            <table id="customerTable" class="table table-striped">
                <thead>
                    <tr>
                        <th>Customer Name</th>
                        <th>Registration Number</th>
                        <th>Policy End Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection conn = DBConnection.getConnection();
                            Statement stmt = conn.createStatement();
                            String query = "SELECT c.firstname, c.lastname, vh.registration_number, qh.policy_expiry_date "
                                    + "FROM Customer c "
                                    + "JOIN QuotationHistory qh ON c.userID = qh.userID "
                                    + "JOIN VehicleHistory vh ON qh.quotation_id = vh.quotation_id "
                                    + "ORDER BY MONTH(qh.policy_expiry_date)";
                            ResultSet rs = stmt.executeQuery(query);
                            while (rs.next()) {
                                String customerName = rs.getString("firstname") + " " + rs.getString("lastname");
                                String registrationNumber = rs.getString("registration_number");
                                Date policyEndDate = rs.getDate("policy_expiry_date");
                    %>
                    <tr>
                        <td><%= customerName%></td>
                        <td><%= registrationNumber%></td>
                        <td><%= policyEndDate%></td>
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
        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>
        <script>
            $(document).ready(function () {
                $('.month-button').click(function () {
                    var month = $(this).data('month');
                    var year = $('#yearSelect').val();
                    filterByMonthAndYear(month, year);
                });

                $('#notifyButton').click(function () {
                    alert('Notifications sent to all customers!');
                    // You can implement logic here to send notifications to all customers
                });
            });

            function filterByMonthAndYear(month, year) {
                $('#customerTable tbody tr').hide();
                $('#customerTable tbody tr').each(function () {
                    var policyEndDate = $(this).find('td:eq(2)').text();
                    var policyDate = new Date(policyEndDate);
                    var policyMonth = policyDate.getMonth() + 1;
                    var policyYear = policyDate.getFullYear();
                    if (policyMonth == month && policyYear == year) {
                        $(this).show();
                    }
                });
            }
        </script>
    </body>
</html>
