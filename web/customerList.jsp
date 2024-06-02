<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Base64" %>
<%
    String roles = (String) session.getAttribute("roles");
    String userID = (String) session.getAttribute("userID");
    boolean hasImage = false;

    if (userID != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");

            // Check if user has uploaded an image
            PreparedStatement psImage = con.prepareStatement("SELECT profileIMG FROM admin WHERE userID = ?");
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
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Customer List</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/userList.css">
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
                        <a href="adminDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard </a>
                    </li>
                    <li class="">
                        <a href="adminProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="dropdown">
                        <a href="#homeSubmenu1" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <i class="material-icons">border_color</i>Manage Account
                        </a>
                        <ul class="collapse list-unstyled menu" id="homeSubmenu1">
                            <li class="active"><a href="customerList.jsp">Customer</a></li>
                            <li class=""><a href="staffList.jsp">Staff</a></li>
                            <li class=""><a href="managerList.jsp">Manager</a></li>
                        </ul>
                    </li>
                    <li class="">
                        <a href="adminReport.jsp" class=""><i class="material-icons">library_books</i>Report</a>
                    </li>
                    <li class="">
                        <a href="homePage.jsp" class=""><i class="material-icons">power_settings_new</i>Sign Out</a>
                    </li>
                </ul>
            </div>
            <!-------sidebar--design- close----------->
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
                                                <a class="nav-link" href="adminProfile.jsp">
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
                            <h4 class="page-title">Manage Customer</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Admin</a></li>
                                <!-- <li class="breadcrumb-item active" aria-curent="page">Dashboard</li> -->
                            </ol>
                        </div>
                    </div>
                </div>
                <!------top-navbar-end----------->
                <!----main-content--->
                <div class="main-content">
                    <div class="container-fluid">
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="card-title">List of Customers</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped" id="customerTable" width="100%" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Phone</th>
                                                <th>IC</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                String searchCustomerID = request.getParameter("userID");
                                                String query = "SELECT * FROM customer";

                                                if (searchCustomerID != null && !searchCustomerID.isEmpty()) {
                                                    query = "SELECT * FROM customer WHERE userID = " + searchCustomerID;
                                                }

                                                try {
                                                    Class.forName("com.mysql.jdbc.Driver");
                                                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");
                                                    Statement st = con.createStatement();
                                                    ResultSet rs = st.executeQuery(query);

                                                    while (rs.next()) {
                                                        // Retrieve customer details from the result set
                                                        String userIDs = rs.getString("userID");
                                                        String firstname = rs.getString("firstname");
                                                        String lastname = rs.getString("lastname");
                                                        String email = rs.getString("email");
                                                        String phone = rs.getString("phone");
                                                        String ICNumber = rs.getString("ICNumber");
                                                        String residence = rs.getString("residence");
                                                        String city = rs.getString("city");
                                                        String zipcode = rs.getString("zipcode");
                                                        String state = rs.getString("state");
                                                        String registrationDate = rs.getString("registration_date");
                                                        String registrationTime = rs.getString("registration_time");
                                                        Blob profileIMG = rs.getBlob("profileIMG");
                                                        String profileIMGBase64 = "";
                                                        if (profileIMG != null) {
                                                            byte[] imgData = profileIMG.getBytes(1, (int) profileIMG.length());
                                                            profileIMGBase64 = Base64.getEncoder().encodeToString(imgData);
                                                        }
                                            %>
                                            <tr>
                                                <td><%= userIDs%></td>
                                                <td><%= firstname%> <%= lastname%></td>
                                                <td><%= email%></td>
                                                <td><%= phone%></td>
                                                <td><%= ICNumber%></td>
                                                <td>
                                                    <button class="btn btn-info btn-sm viewBtn"
                                                            data-userid="<%= userIDs%>"
                                                            data-firstname="<%= firstname%>"
                                                            data-lastname="<%= lastname%>"
                                                            data-email="<%= email%>"
                                                            data-phone="<%= phone%>"
                                                            data-icnumber="<%= ICNumber%>"
                                                            data-residence="<%= residence%>"
                                                            data-city="<%= city%>"
                                                            data-zipcode="<%= zipcode%>"
                                                            data-state="<%= state%>"
                                                            data-registrationdate="<%= registrationDate%>"
                                                            data-registrationtime="<%= registrationTime%>"
                                                            data-profileimg="<%= profileIMGBase64%>"
                                                            data-toggle="modal" data-target="#customerModal">View</button>
                                                    <button class="btn btn-danger btn-sm" onclick="deleteCustomer('<%= userIDs%>')">Delete</button>
                                                </td>
                                            </tr>
                                            <%
                                                    }

                                                    con.close();
                                                } catch (Exception e) {
                                                    out.println("Error: " + e);
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!----main-content-end--->

                    <!-- Modal -->
                    <div class="modal fade" id="customerModal" tabindex="-1" role="dialog" aria-labelledby="customerModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="customerModalLabel">Customer Details</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <p><strong>ID:</strong> <span id="modalUserID"></span></p>
                                    <p><strong>Name:</strong> <span id="modalFirstname"></span> <span id="modalLastname"></span></p>
                                    <p><strong>Email:</strong> <span id="modalEmail"></span></p>
                                    <p><strong>Phone:</strong> <span id="modalPhone"></span></p>
                                    <p><strong>IC:</strong> <span id="modalICNumber"></span></p>
                                    <p><strong>Residence:</strong> <span id="modalResidence"></span></p>
                                    <p><strong>City:</strong> <span id="modalCity"></span></p>
                                    <p><strong>Zipcode:</strong> <span id="modalZipcode"></span></p>
                                    <p><strong>State:</strong> <span id="modalState"></span></p>
                                    <p><strong>Registration Date:</strong> <span id="modalRegistrationDate"></span></p>
                                    <p><strong>Registration Time:</strong> <span id="modalRegistrationTime"></span></p>
                                    <p><strong>Profile Image:</strong></p>
                                    <img id="modalProfileIMG" src="" alt="Profile Image" style="width:100px; height:100px; border-radius:50%;">
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
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

                                                            // View button click event
                                                            $(".viewBtn").on("click", function () {
                                                                var userID = $(this).data("userid");
                                                                var firstname = $(this).data("firstname");
                                                                var lastname = $(this).data("lastname");
                                                                var email = $(this).data("email");
                                                                var phone = $(this).data("phone");
                                                                var icnumber = $(this).data("icnumber");
                                                                var residence = $(this).data("residence");
                                                                var city = $(this).data("city");
                                                                var zipcode = $(this).data("zipcode");
                                                                var state = $(this).data("state");
                                                                var registrationDate = $(this).data("registrationdate");
                                                                var registrationTime = $(this).data("registrationtime");
                                                                var profileIMG = $(this).data("profileimg");

                                                                // Set the data to the modal
                                                                $("#modalUserID").text(userID);
                                                                $("#modalFirstname").text(firstname);
                                                                $("#modalLastname").text(lastname);
                                                                $("#modalEmail").text(email);
                                                                $("#modalPhone").text(phone);
                                                                $("#modalICNumber").text(icnumber);
                                                                $("#modalResidence").text(residence);
                                                                $("#modalCity").text(city);
                                                                $("#modalZipcode").text(zipcode);
                                                                $("#modalState").text(state);
                                                                $("#modalRegistrationDate").text(registrationDate);
                                                                $("#modalRegistrationTime").text(registrationTime);
                                                                if (profileIMG) {
                                                                    $("#modalProfileIMG").attr("src", "data:image/jpeg;base64," + profileIMG);
                                                                } else {
                                                                    $("#modalProfileIMG").attr("src", "IMG/avatar.jpg");
                                                                }
                                                            });
                                                        });

                                                        function deleteCustomer(customerID) {
                                                            if (confirm("Are you sure you want to delete this customer?")) {
                                                                // Send an AJAX request to processDeleteCustomer.jsp with the customerID parameter
                                                                $.ajax({
                                                                    type: "POST",
                                                                    url: "processDeleteCustomer.jsp",
                                                                    data: {customerID: customerID},
                                                                    success: function (response) {
                                                                        // Reload the page after successful deletion
                                                                        window.location.reload();
                                                                    },
                                                                    error: function (error) {
                                                                        console.log("Error:", error);
                                                                        alert("Error deleting customer. Please try again.");
                                                                    }
                                                                });
                                                            }
                                                        }
        </script>
    </body>
</html>
