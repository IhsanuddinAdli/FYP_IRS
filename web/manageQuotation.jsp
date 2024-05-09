<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.dao.DBConnection"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Quotations</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Your custom CSS file -->
        <link rel="stylesheet" href="CSS/manageQuotation.css">
    </head>
    <body>
        <div class="container">
            <h2>Manage Quotations</h2>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Quotation ID</th>
                        <th>Customer Name</th>
                        <th>Policy Commencement Date</th>
                        <th>Policy Duration</th>
                        <th>Policy Expiry Date</th>
                        <th>Selected NCD</th>
                        <th>Payment Status</th>
                        <th>Action</th>
                        <th>Cover Note</th>
                    </tr>
                </thead>
                <tbody>
                    <% try {
                            Connection conn = DBConnection.getConnection();
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT qh.quotation_id, c.firstname, qh.policy_commencement_date, qh.policy_duration, qh.policy_expiry_date, qh.selected_ncd, ph.paymentStatus, qh.cover_note FROM QuotationHistory qh JOIN Customer c ON qh.userID = c.userID LEFT JOIN PaymentHistory ph ON qh.quotation_id = ph.quotation_id");
                            while (rs.next()) {
                                int quotationId = rs.getInt("quotation_id");
                                String customerName = rs.getString("firstname");
                                Date commencementDate = rs.getDate("policy_commencement_date");
                                int duration = rs.getInt("policy_duration");
                                Date expiryDate = rs.getDate("policy_expiry_date");
                                String ncd = rs.getString("selected_ncd");
                                String paymentStatus = rs.getString("paymentStatus");
                                String coverNotePath = rs.getString("cover_note");
                                boolean isUploadable = !"Pending".equals(paymentStatus) && !"Rejected".equals(paymentStatus);
                    %>
                    <tr data-quotation-id="<%= quotationId%>">
                        <td><%= quotationId%></td>
                        <td><%= customerName%></td>
                        <td><%= commencementDate%></td>
                        <td><%= duration%> months</td>
                        <td><%= expiryDate%></td>
                        <td><%= ncd%></td>
                        <td><%= paymentStatus%></td>
                        <td>
                            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#uploadModal<%= quotationId%>" <%= !isUploadable ? "disabled" : ""%>>Upload Cover Note</button>
                            <!-- Updated Delete Button with disable condition -->
                            <button type="button" class="btn btn-danger" onclick="confirmDelete(<%= quotationId%>)" <%= !isUploadable ? "disabled" : ""%>>Delete Cover Note</button>
                        </td>
                        <td>
                            <% if (coverNotePath != null && !coverNotePath.isEmpty()) {%>
                            <a href="viewPDF?id=<%= quotationId%>" target="_blank">View PDF</a>
                            <% } else { %>
                            No file uploaded
                            <% }%>
                        </td>
                    </tr>
                    <!-- Modal -->
                <div class="modal fade" id="uploadModal<%= quotationId%>" tabindex="-1" role="dialog" aria-labelledby="modalLabel<%= quotationId%>" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="modalLabel<%= quotationId%>">Upload Cover Note for Quotation ID: <%= quotationId%></h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <form action="uploadCoverNote" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="quotationId" value="<%= quotationId%>">
                                    <div class="form-group">
                                        <label for="fileInput<%= quotationId%>">Select PDF file:</label>
                                        <input type="file" class="form-control-file" id="fileInput<%= quotationId%>" name="coverNotePdf" accept="application/pdf" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Upload</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <% }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }%>
                </tbody>
            </table>
        </div>
        <!-- Optional JavaScript; choose one of the two! -->

        <!-- Option 1: jQuery and Bootstrap Bundle (includes Popper) -->
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>

        <%
            String message = request.getParameter("message");
            if (message != null && !message.isEmpty()) {
        %>
        <script>
            $(document).ready(function () {
                alert('<%= message%>');
            });
        </script>
        <%
            }
        %>
        <script>
            function confirmDelete(quotationId) {
                if (confirm('Are you sure you want to delete this cover note?')) {
                    // If confirmed, redirect to the servlet that handles deletion
                    window.location.href = 'deleteCoverNote?quotationId=' + quotationId;
                }
            }
        </script>

    </body>
</html>
