<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String userID = (String) session.getAttribute("userID");
    String roles = (String) session.getAttribute("roles");
    String firstname = "";
    String lastname = "";
    String ICNumber = "";
    String email = "";
    String phone = "";
    String password = "";
    String residence = "";
    String city = "";
    String zipcode = "";
    String state = "";
    boolean hasImage = false;

    if (userID != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM manager WHERE userID = ? ");
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                roles = rs.getString("roles") != null ? rs.getString("roles") : "";
                firstname = rs.getString("firstname") != null ? rs.getString("firstname") : "";
                lastname = rs.getString("lastname") != null ? rs.getString("lastname") : "";
                ICNumber = rs.getString("ICNumber") != null ? rs.getString("ICNumber") : "";
                email = rs.getString("email") != null ? rs.getString("email") : "";
                phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                password = rs.getString("password") != null ? rs.getString("password") : "";
                residence = rs.getString("residence") != null ? rs.getString("residence") : "";
                city = rs.getString("city") != null ? rs.getString("city") : "";
                zipcode = rs.getString("zipcode") != null ? rs.getString("zipcode") : "";
                state = rs.getString("state") != null ? rs.getString("state") : "";
                hasImage = rs.getBlob("profileIMG") != null;
            }
        } catch (SQLException e) {
            // Handle SQLException (print or log the error)
            e.printStackTrace();
            out.println("An error occurred while fetching customer data. Please try again later.");
        }
    } else {
        // Handle the case where customerID is not found in the session
        out.println("userID not found in the session.");
    }
%>

<!DOCTYPE html>
<html lang=" en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Profile Page</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/profile.css">
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
                        <a href="managerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard </a>
                    </li>
                    <li class="active">
                        <a href="managerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="">
                        <a href="customerNotify.jsp" class=""><i class="material-icons">notifications_active</i>Customer Notify</a>
                    </li>
                    <li class="">
                        <a href="managerReport.jsp" class=""><i class="material-icons">library_books</i>Report</a>
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
                            <h4 class="page-title">Profile</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Manager</a></li>
                                <!-- <li class="breadcrumb-item active" aria-curent="page">Dashboard</li> -->
                            </ol>
                        </div>
                    </div>
                </div>
                <!------top-navbar-end----------->
                <!-- modal for updating profile image -->
                <div class="modal fade" id="updateImageModal" tabindex="-1" role="dialog" aria-labelledby="updateImageModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <form id="updateImageForm" action="uploadImage" method="post" enctype="multipart/form-data">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="updateImageModalLabel">Update Profile Image</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label for="imageFile">Choose Image:</label>
                                        <input type="file" class="form-control-file" id="imageFile" name="imageFile">
                                    </div>
                                    <input type="hidden" name="userID" value="<%= userID%>">
                                    <input type="hidden" name="roles" value="<%= roles%>">
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-primary">Upload Image</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!----main-content--->
                <div id="main-content-image">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body text-center">
                                        <img src="getImage?userID=<%= userID%>&roles=<%= roles%>" alt="Avatar" class="img-fluid rounded-circle mb-3 shadow-sm" style="width: 120px; height: 120px;">
                                        <h4 class="card-title"><%= firstname%> <%= lastname%></h4>
                                        <p class="text-muted"><%= roles%></p>
                                    </div>
                                    <div class="card-footer text-center">
                                        <button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#updateImageModal">Update Image</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">Profile Details</h5>
                                        <form id="profileForm">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="firstname">First Name</label>
                                                        <input type="text" class="form-control" id="firstname" value="<%= firstname%>" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="lastname">Last Name</label>
                                                        <input type="text" class="form-control" id="lastname" value="<%= lastname%>" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="ICNumber">IC Number</label>
                                                        <input type="text" class="form-control" id="ICNumber" value="<%= ICNumber%>" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="email">Email</label>
                                                        <input type="email" class="form-control" id="email" value="<%= email%>" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="phone">Phone</label>
                                                        <input type="text" class="form-control" id="phone" value="<%= phone%>" readonly>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="password">Password</label>
                                                        <input type="password" class="form-control" id="password" value="<%= password%>" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="residence">Residence</label>
                                                        <input type="text" class="form-control" id="residence" value="<%= residence%>" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="zipcode">Zip Code</label>
                                                        <input type="text" class="form-control" id="zipcode" value="<%= zipcode%>" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="city">City</label>
                                                        <input type="text" class="form-control" id="city" value="<%= city%>" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="state">State</label>
                                                        <input type="text" class="form-control" id="state" value="<%= state%>" readonly>
                                                    </div>
                                                </div>
                                            </div>
                                            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#updateProfileModal" id="updateProfileModalButton">Update Profile</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!----main-content-end--->
                <!-- Modal for Updating Profile -->
                <div class="modal fade" id="updateProfileModal" tabindex="-1" role="dialog" aria-labelledby="updateProfileModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="updateProfileModalLabel">Update Profile</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <form id="updateProfileForm" action="updateEmployeeProfile.jsp" method="post">
                                    <div class="form-group">
                                        <input type="hidden" class="form-control" id="userID" name="userID" value="<%= userID%>">
                                        <input type="hidden" class="form-control" id="roles" name="roles" value="<%= roles%>">

                                        <label for="firstname">Firstname</label>
                                        <input type="text" class="form-control" id="firstname" name="firstname" required value="<%= firstname%>">
                                    </div>
                                    <div class="form-group">
                                        <label for="lastname">Lastname</label>
                                        <input type="text" class="form-control" id="lastname" name="lastname" required value="<%= lastname%>">
                                    </div>
                                    <div class="form-group">
                                        <label for="ICNumber">IC Number</label>
                                        <input type="text" class="form-control" id="ICNumber" name="ICNumber" required value="<%= ICNumber%>">
                                    </div>
                                    <div class="form-group">
                                        <label for="email">Email</label>
                                        <input type="text" class="form-control" id="email" name="email" required value="<%= email%>">
                                    </div>
                                    <div class="form-group">
                                        <label for="phone">Phone</label>
                                        <input type="text" class="form-control" id="phone" name="phone" required value="<%= phone%>">
                                    </div>
                                    <div class="form-group">
                                        <label for="password">Password</label>
                                        <input type="text" class="form-control" id="password" name="password" required value="<%= password%>">
                                    </div>
                                    <div class="form-group">
                                        <label for="residence">Residence</label>
                                        <input type="text" class="form-control" id="residence" name="residence" required value="<%= residence%>">
                                    </div>
                                    <div class="form-group">
                                        <label for="zipcode">Zipcode</label>
                                        <input type="text" class="form-control" id="zipcode" name="zipcode" required value="<%= zipcode%>">
                                    </div>
                                    <div class="form-group">
                                        <label for="city">City</label>
                                        <input type="text" class="form-control" id="city" name="city" required value="<%= city%>">
                                    </div>
                                    <div class="form-group">
                                        <label for="state">State</label>
                                        <input type="text" class="form-control" id="state" name="state" value="<%= state%>">
                                    </div>
                                    <div class="text-right">
                                        <div class="text-right">
                                            <a href="updateEmployeeProfile.jsp?userID=<%= userID%>&roles=<%= roles%>">
                                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                            </a>
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
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

        <script>
            // Trigger the modal when the "Update Profile" button is clicked
            $(document).ready(function () {
                $('#updateProfileModalButton').click(function () {
                    $('#updateProfileModal').modal('show');
                });
            });
        </script>
    </body>
</html>