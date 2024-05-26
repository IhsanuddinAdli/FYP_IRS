<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.dao.DBConnection"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Manage Quotations</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
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
                    <li class="active">
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
                            <h4 class="page-title">Manage Quotation</h4>
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
                                    <th>Quotation ID</th>
                                    <th>Customer Name</th>
                                    <th>Policy Expiry Date</th>
                                    <th>Details</th>
                                    <th>Payment Status</th>
                                    <th>Action</th>
                                    <th>Cover Note</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Connection conn = DBConnection.getConnection();
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery("SELECT qh.quotation_id, c.firstname, qh.policy_expiry_date, ph.paymentStatus, qh.cover_note FROM QuotationHistory qh JOIN Customer c ON qh.userID = c.userID LEFT JOIN PaymentHistory ph ON qh.quotation_id = ph.quotation_id");
                                        if (!rs.isBeforeFirst()) {
                                %><tr><td colspan="7">No data found</td></tr><%
                                    }
                                    while (rs.next()) {
                                        int quotationId = rs.getInt("quotation_id");
                                        String customerName = rs.getString("firstname");
                                        Date expiryDate = rs.getDate("policy_expiry_date");
                                        String paymentStatus = rs.getString("paymentStatus");
                                        String coverNotePath = rs.getString("cover_note");
                                        boolean isUploadable = !"Pending".equals(paymentStatus) && !"Rejected".equals(paymentStatus);
                                %>
                                <tr data-quotation-id="<%= quotationId%>">
                                    <td><%= quotationId%></td>
                                    <td><%= customerName%></td>
                                    <td><%= expiryDate%></td>
                                    <td>
                                        <button type="button" class="btn btn-info" data-toggle="modal" data-target="#detailsModal<%= quotationId%>">View Details</button>
                                    </td>
                                    <td><%= paymentStatus%></td>
                                    <td>
                                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#uploadModal<%= quotationId%>" <%= !isUploadable ? "disabled" : ""%>>
                                            <i class="material-icons">file_upload</i>
                                        </button>
                                        <button type="button" class="btn btn-danger" onclick="confirmDelete(<%= quotationId%>)" <%= !isUploadable ? "disabled" : ""%>>
                                            <i class="material-icons">delete</i>
                                        </button>
                                    </td>
                                    <td>
                                        <% if (coverNotePath != null && !coverNotePath.isEmpty()) {%>
                                        <form action="viewPDF" method="get" target="_blank">
                                            <input type="hidden" name="id" value="<%= quotationId%>">
                                            <button type="submit" class="btn btn-secondary">View Cover Note</button>
                                        </form>
                                        <% } else { %>
                                        No file uploaded
                                        <% }%>
                                    </td>
                                </tr>
                                <!-- Modal for Uploading Cover Note -->
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

                            <!-- Modal for Viewing Details -->
                            <div class="modal fade" id="detailsModal<%= quotationId%>" tabindex="-1" role="dialog" aria-labelledby="detailsModalLabel<%= quotationId%>" aria-hidden="true">
                                <div class="modal-dialog modal-lg" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="detailsModalLabel<%= quotationId%>">Details for Quotation ID: <%= quotationId%></h5>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <%
                                                // Fetch details for the selected quotation
                                                PreparedStatement detailStmt = conn.prepareStatement(
                                                        "SELECT qh.*, ah.*, vh.*, c.* FROM QuotationHistory qh "
                                                        + "JOIN AddonsHistory ah ON qh.quotation_id = ah.quotation_id "
                                                        + "JOIN VehicleHistory vh ON qh.quotation_id = vh.quotation_id "
                                                        + "JOIN Customer c ON qh.userID = c.userID "
                                                        + "WHERE qh.quotation_id = ?"
                                                );
                                                detailStmt.setInt(1, quotationId);
                                                ResultSet detailRs = detailStmt.executeQuery();
                                                if (detailRs.next()) {
                                            %>
                                            <h5>Customer Details:</h5>
                                            <p>Name: <%= detailRs.getString("firstname")%> <%= detailRs.getString("lastname")%></p>
                                            <p>Email: <%= detailRs.getString("email")%></p>
                                            <p>Phone: <%= detailRs.getString("phone")%></p>
                                            <p>Address: <%= detailRs.getString("residence")%>, <%= detailRs.getString("city")%>, <%= detailRs.getString("state")%>, <%= detailRs.getString("zipcode")%></p>

                                            <h5>Vehicle Details:</h5>
                                            <p>Owner Name: <%= detailRs.getString("owner_name")%></p>
                                            <p>Registration Number: <%= detailRs.getString("registration_number")%></p>
                                            <p>Engine Number: <%= detailRs.getString("engine_number")%></p>
                                            <p>Chassis Number: <%= detailRs.getString("chassis_number")%></p>
                                            <p>Insured Value: RM<%= detailRs.getDouble("insured_value")%></p>
                                            <p>Vehicle Make and Model: <%= detailRs.getString("vehicle_make")%> <%= detailRs.getString("vehicle_model")%></p>
                                            <p>Manufacture Year: <%= detailRs.getInt("manufacture_year")%></p>
                                            <p>Vehicle Type: <%= detailRs.getString("vehicle_type")%></p>
                                            <p>Engine Capacity: <%= detailRs.getInt("engine_capacity")%> CC</p>
                                            <p>Location: <%= detailRs.getString("location")%></p>
                                            <p>Local or Import: <%= detailRs.getString("local_import")%></p>

                                            <h5>Add-ons Details:</h5>
                                            <p>Windscreen Cost: RM<%= detailRs.getDouble("windscreen_cost")%></p>
                                            <p>All Driver Cost: RM<%= detailRs.getDouble("all_driver_cost")%></p>
                                            <p>Special Perils Cost: RM<%= detailRs.getDouble("special_perils_cost")%></p>
                                            <p>Legal Liability Cost: RM<%= detailRs.getDouble("legal_liability_cost")%></p>

                                            <h5>Quotation Details:</h5>
                                            <p>Coverage: <%= detailRs.getString("coverage")%></p>
                                            <p>Policy Commencement Date: <%= detailRs.getDate("policy_commencement_date")%></p>
                                            <p>Policy Duration: <%= detailRs.getInt("policy_duration")%> months</p>
                                            <p>Selected NCD: <%= detailRs.getString("selected_ncd")%></p>

                                            <%
                                            } else {
                                            %>
                                            <p>No details found for this quotation.</p>
                                            <%
                                                }
                                                detailRs.close();
                                                detailStmt.close();
                                            %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            %><tr><td colspan="7">Error retrieving data: <%= e.getMessage()%></td></tr><%
                                }%>
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

        function confirmDelete(quotationId) {
            if (confirm('Are you sure you want to delete this cover note?')) {
                window.location.href = 'deleteCoverNote?quotationId=' + quotationId;
            }
        }
        </script>
    </body>
</html>
