<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.dao.DBConnection"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Payments</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Your custom CSS file -->
        <link rel="stylesheet" href="CSS/managePayment.css">
    </head>
    <body>
        <div class="container">
            <h2>Manage Payments</h2>
            <!-- Table to display payments -->
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Customer Name</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Fetch and display payment data from the database -->
                    <%
                        try {
                            Connection conn = DBConnection.getConnection();
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM PaymentHistory");
                            while (rs.next()) {
                                int paymentId = rs.getInt("quotation_id");
                                String customerName = rs.getString("payment_method");
                                double amount = rs.getDouble("price");
                                String status = rs.getString("paymentStatus");
                    %>
                    <tr data-payment-id="<%= paymentId%>">
                        <td><%= paymentId%></td>
                        <td><%= customerName%></td>
                        <td>RM<%= amount%></td>
                        <td><%= status%></td>
                        <td>
                            <form action="managePayment" method="post">
                                <input type="hidden" name="paymentId" value="<%= paymentId%>">
                                <button type="submit" name="status" value="Approved" class="btn btn-success">Approve</button>
                                <button type="submit" name="status" value="Rejected" class="btn btn-danger">Reject</button>
                            </form>
                        </td>
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
        <!-- Your custom JavaScript file -->
        <script>
            $(document).ready(function () {
                // Handle approve button click
                $(".approve-btn").click(function () {
                    var paymentId = $(this).closest("tr").data("payment-id");
                    updatePaymentStatus(paymentId, "Approved");
                });

                // Handle reject button click
                $(".reject-btn").click(function () {
                    var paymentId = $(this).closest("tr").data("payment-id");
                    updatePaymentStatus(paymentId, "Rejected");
                });

                // Function to update payment status via AJAX
                function updatePaymentStatus(paymentId, status) {
                    // Simulate AJAX request (replace with actual AJAX call)
                    setTimeout(function () {
                        // Update the status in the table
                        $("tr[data-payment-id='" + paymentId + "'] td:eq(3)").text(status);
                    }, 500); // Simulate delay for demonstration purpose
                }
            });
        </script>
    </body>
</html>
