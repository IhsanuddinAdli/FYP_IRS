<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.dao.DBConnection"%><%
    String roles = (String) session.getAttribute("roles");
    String userID = (String) session.getAttribute("userID");
    boolean hasImage = false;

    if (userID != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");

            // Check if user has uploaded an image
            PreparedStatement psImage = con.prepareStatement("SELECT profileIMG FROM staff WHERE userID = ?");
            psImage.setString(1, userID);
            ResultSet rsImage = psImage.executeQuery();
            if (rsImage.next()) {
                hasImage = rsImage.getBlob("profileIMG") != null;
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
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Manage Quotations</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="CSS/manageQuotation.css">
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css">
        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!-- Google Material Icons -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>
    <body>
        <div class="wrapper">
            <div class="body-overlay"></div>
            <!-- Sidebar Design -->
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
                        <a href="managePayment.jsp" class=""><i class="material-icons">payment</i>Manage Payment</a>
                    </li>
                    <li class="active">
                        <a href="manageQuotation.jsp"><i class="material-icons">list_alt</i>Manage Quotation</a>
                    </li>
                    <li class="">
                        <a href="homePage.jsp" class=""><i class="material-icons">power_settings_new</i>Sign Out</a>
                    </li>
                </ul>
            </div>
            <!-- Sidebar Design End -->
            <!-- Page Content Start -->
            <div id="content">
                <!-- Top Navbar Start -->
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
                            <h4 class="page-title">Manage Quotation</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Staff</a></li>
                            </ol>
                        </div>
                    </div>
                </div>
                <!-- Top Navbar End -->
                <!-- Main Content Start -->
                <div class="main-content">
                    <div class="container-fluid">
                        <div class="card mb-4">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped" id="quotationTable" width="100%" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th>No.</th>
                                                <th>Customer Name</th>
                                                <th>Policy Expiry Date</th>
                                                <th>Details</th>
                                                <th>Payment Status</th>
                                                <th>Action</th>
                                                <th>Cover Note</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% try {
                                                    Connection conn = DBConnection.getConnection();
                                                    Statement stmt = conn.createStatement();
                                                    ResultSet rs = stmt.executeQuery("SELECT qh.quotation_id, c.firstname, qh.policy_expiry_date, ph.paymentStatus, qh.cover_note FROM QuotationHistory qh JOIN Customer c ON qh.userID = c.userID LEFT JOIN PaymentHistory ph ON qh.quotation_id = ph.quotation_id");
                                                    int rowNumber = 1;
                                                    if (!rs.isBeforeFirst()) { %>
                                            <tr>
                                                <td colspan="7">No data found</td>
                                            </tr>
                                            <% }
                                                while (rs.next()) {
                                                    int quotationId = rs.getInt("quotation_id");
                                                    String customerName = rs.getString("firstname");
                                                    Date expiryDate = rs.getDate("policy_expiry_date");
                                                    String paymentStatus = rs.getString("paymentStatus");
                                                    String coverNotePath = rs.getString("cover_note");
                                                    boolean isUploadable = !"Pending".equals(paymentStatus) && !"Rejected".equals(paymentStatus);
                                            %>
                                            <tr data-quotation-id="<%= quotationId%>">
                                                <td><%= rowNumber++%></td>
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
                                                        <div class="container">
                                                            <% // Fetch details for the selected quotation
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
                                                            <div class="detail-section">
                                                                <h5>Customer Details:</h5>
                                                                <p><strong>Name:</strong> <%= detailRs.getString("firstname")%> <%= detailRs.getString("lastname")%></p>
                                                                <p><strong>Email:</strong> <%= detailRs.getString("email")%></p>
                                                                <p><strong>Phone:</strong> <%= detailRs.getString("phone")%></p>
                                                                <p><strong>Address:</strong> <%= detailRs.getString("residence")%>, <%= detailRs.getString("city")%>, <%= detailRs.getString("state")%>, <%= detailRs.getString("zipcode")%></p>
                                                            </div>

                                                            <div class="detail-section">
                                                                <h5>Vehicle Details:</h5>
                                                                <p><strong>Owner Name:</strong> <%= detailRs.getString("owner_name")%></p>
                                                                <p><strong>Registration Number:</strong> <%= detailRs.getString("registration_number")%></p>
                                                                <p><strong>Engine Number:</strong> <%= detailRs.getString("engine_number")%></p>
                                                                <p><strong>Chassis Number:</strong> <%= detailRs.getString("chassis_number")%></p>
                                                                <p><strong>Insured Value:</strong> RM<%= detailRs.getDouble("insured_value")%></p>
                                                                <p><strong>Vehicle Make and Model:</strong> <%= detailRs.getString("vehicle_make")%> <%= detailRs.getString("vehicle_model")%></p>
                                                                <p><strong>Manufacture Year:</strong> <%= detailRs.getInt("manufacture_year")%></p>
                                                                <p><strong>Vehicle Type:</strong> <%= detailRs.getString("vehicle_type")%></p>
                                                                <p><strong>Engine Capacity:</strong> <%= detailRs.getInt("engine_capacity")%> CC</p>
                                                                <p><strong>Location:</strong> <%= detailRs.getString("location")%></p>
                                                                <p><strong>Local or Import:</strong> <%= detailRs.getString("local_import")%></p>
                                                            </div>

                                                            <div class="detail-section">
                                                                <h5>Add-ons Details:</h5>
                                                                <p><strong>Windscreen Cost:</strong> RM<%= detailRs.getDouble("windscreen_cost")%></p>
                                                                <p><strong>All Driver Cost:</strong> RM<%= detailRs.getDouble("all_driver_cost")%></p>
                                                                <p><strong>Special Perils Cost:</strong> RM<%= detailRs.getDouble("special_perils_cost")%></p>
                                                                <p><strong>Legal Liability Cost:</strong> RM<%= detailRs.getDouble("legal_liability_cost")%></p>
                                                            </div>

                                                            <div class="detail-section">
                                                                <h5>Quotation Details:</h5>
                                                                <p><strong>Coverage:</strong> <%= detailRs.getString("coverage")%></p>
                                                                <p><strong>Policy Commencement Date:</strong> <%= detailRs.getDate("policy_commencement_date")%></p>
                                                                <p><strong>Policy Duration:</strong> <%= detailRs.getInt("policy_duration")%> months</p>
                                                                <p><strong>Selected NCD:</strong> <%= detailRs.getString("selected_ncd")%></p>
                                                            </div>

                                                            <% } else { %>
                                                            <p>No details found for this quotation.</p>
                                                            <% }
                                                                detailRs.close();
                                                                detailStmt.close();
                                                            %>
                                                        </div>
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
                                        %><tr><td colspan="7">Error retrieving data: <%= e.getMessage()%></td></tr><%
                                            } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Main Content End -->
                <!-- Footer Design -->
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="footer-in">
                            <p class="mb-0">&copy; 2024 RAZ WAWASAN SDN BHD (ADLI YONG)</p>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <!-- Complete HTML -->
        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>
        <script src="JS/jquery-3.3.1.min.js"></script>
        <!-- DataTables JavaScript -->
        <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap4.min.js"></script>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css">
        <script>
                                                        $(document).ready(function () {
                                                            $('#quotationTable').DataTable({
                                                                "order": [],
                                                                "columnDefs": [
                                                                    {"orderable": false, "targets": [3, 5, 6]}
                                                                ]
                                                            });

                                                            $(".xp-menubar").on('click', function () {
                                                                $("#sidebar").toggleClass('active');
                                                                $("#content").toggleClass('active');
                                                            });

                                                            $('.xp-menubar,.body-overlay').on('click', function () {
                                                                $("#sidebar,.body-overlay").toggleClass('show-nav');
                                                            });

            <% String message = request.getParameter("message");
                if (message != null && !message.isEmpty()) {%>
                                                            alert('<%= message%>');
            <% }%>
                                                        });

                                                        function confirmDelete(quotationId) {
                                                            if (confirm('Are you sure you want to delete this cover note?')) {
                                                                window.location.href = 'deleteCoverNote?quotationId=' + quotationId;
                                                            }
                                                        }
        </script>
    </body>
</html>
