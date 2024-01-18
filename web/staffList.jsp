<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang=" en">

    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Staff List</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/staffList.css">


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
                        <a href="adminDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>dashboard </a>
                    </li>

                    <li class="">
                        <a href="profile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>

                    <li class="dropdown active">
                        <a href="#homeSubmenu1" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <i class="material-icons">border_color</i>Manage Account
                        </a>
                        <ul class="collapse list-unstyled menu" id="homeSubmenu1">
                            <li><a href="customerList.jsp">Customer</a></li>
                            <li><a href="staffList.jsp">Staff</a></li>
                            <li><a href="managerList.jsp">Manager</a></li>
                        </ul>
                    </li>

                    <li class="">
                        <a href="#" class=""><i class="material-icons">library_books</i>Report</a>
                    </li>

                    <li class="">
                        <a href="#" class=""><i class="material-icons">power_settings_new</i>Sign Out</a>
                    </li>

                    <!-- <li class="">
                            <a href="#" class=""><i class="material-icons">library_books</i>calender </a>
                        </li> -->

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

                            <div class="col-md-5 col-lg-3 order-3 order-md-2">
                                <!-- <div class="xp-searchbar">
                                    <form>
                                        <div class="input-group">
                                            <input type="search" class="form-control" placeholder="Search">
                                            <div class="input-group-append">
                                                <button class="btn" type="submit" id="button-addon2">Go
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div> -->
                            </div>

                            <div class="col-10 col-md-6 col-lg-8 order-1 order-md-3">
                                <div class="xp-profilebar text-right">
                                    <nav class="navbar p-0">
                                        <ul class="nav navbar-nav flex-row ml-auto">
                                            <li class="dropdown nav-item active">
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

                                            <li class="nav-item">
                                                <a class="nav-link" href="#">
                                                    <span class="material-icons">question_answer</span>
                                                </a>
                                            </li>

                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="#" data-toggle="dropdown">
                                                    <img src="IMG/avatar.jpg" style="width:40px; border-radius:50%;" />
                                                    <span class="xp-user-live"></span>
                                                </a>
                                                <ul class="dropdown-menu small-menu">
                                                    <li><a href="#">
                                                            <span class="material-icons">person_outline</span>
                                                            Profile
                                                        </a></li>
                                                    <li><a href="#">
                                                            <span class="material-icons">logout</span>
                                                            Logout
                                                        </a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>

                        </div>

                        <div class="xp-breadcrumbbar text-center">
                            <h4 class="page-title">Manage Staff</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Admin</a></li>
                                <!-- <li class="breadcrumb-item active" aria-curent="page">Dashboard</li> -->
                            </ol>
                        </div>


                    </div>
                </div>
                <!------top-navbar-end----------->

                <!----main-content--->
                <!-- Inside the main-content section -->
                <div class="main-content">
                    <div class="container-fluid">
                        <!-- Add Staff Button (Moved to the top right corner) -->
                        <div class="text-right mb-4">
                            <button class="btn btn-primary" data-toggle="modal" data-target="#addStaffModal">Add Staff</button>
                        </div>

                        <!-- Staff Table -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="card-title">List of Staff</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered" id="staffTable" width="100%" cellspacing="0">
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
                                                String searchStaffID = request.getParameter("userID");
                                                String query = "SELECT * FROM staff";

                                                if (searchStaffID != null && !searchStaffID.isEmpty()) {
                                                    query = "SELECT * FROM staff WHERE userID = " + searchStaffID;
                                                }

                                                try {
                                                    Class.forName("com.mysql.jdbc.Driver");
                                                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");
                                                    Statement st = con.createStatement();
                                                    ResultSet rs = st.executeQuery(query);

                                                    while (rs.next()) {
                                                        // Retrieve staff details from the result set
                                                        String userID = rs.getString("userID");
                                                        String firstname = rs.getString("firstname");
                                                        String email = rs.getString("email");
                                                        String phone = rs.getString("phone");
                                                        String ICNumber = rs.getString("ICNumber");
                                            %>
                                            <tr>
                                                <td><%= userID%></td>
                                                <td><%= firstname%></td>
                                                <td><%= email%></td>
                                                <td><%= phone%></td>
                                                <td><%= ICNumber%></td>
                                                <td>
                                                    <a href="editStaffList.jsp?userID=<%= userID%>" class="btn btn-info btn-sm">View</a>
                                                    <button class="btn btn-danger btn-sm" onclick="deleteStaff('<%= userID%>')">Delete</button>
                                                </td>
                                            </tr>
                                            <%
                                                    }

                                                    con.close();
                                                } catch (Exception e) {
                                                    out.println("Error: " + e);
                                                }
                                            %>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add Staff Modal -->
                    <div class="modal fade" id="addStaffModal" tabindex="-1" role="dialog" aria-labelledby="addStaffModalLabel"
                         aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="addStaffModalLabel">Add Staff</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <!-- Add a form to input staff information -->
                                    <form action="processRegisterStaff.jsp" method="post">
                                        <div class="form-group">
                                            <label for="firstname">Firstname:</label>
                                            <input type="text" class="form-control" name="firstname" id="firstname" placeholder="Enter Staff Firstname" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="lastname">Lastname</label>
                                            <input type="text" class="form-control" name="lastname" id="staffName" placeholder="Enter Staff Lastname" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="email">Email:</label>
                                            <input type="email" class="form-control" name="email" id="email" placeholder="Enter Staff Email" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="phone">Phone:</label>
                                            <input type="text" class="form-control" name="phone" id="phone" placeholder="Enter Staff Phone" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="password">Password:</label>
                                            <input type="text" class="form-control" name="password" id="password" placeholder="Enter Staff Password" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="confirmPassword">Cofirm Password:</label>
                                            <input type="text" class="form-control" name="confirmPassword" id="confirmPassword" placeholder="Re-Enter Staff Password" required>
                                        </div>

                                        <input type="hidden" name="roles" id="roles" value="staff">
                                        <!-- Add more input fields based on your staff information -->
                                        <button type="submit" class="btn btn-primary">ADD</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Confirmation Modal -->
                <div class="modal fade" id="confirmationModal" tabindex="-1" role="dialog" aria-labelledby="confirmationModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="confirmationModalLabel">Confirmation</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <p>Are you sure you want to delete this staff member?</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                <!-- Add a hidden input to store the staffID to be deleted -->
                                <input type="hidden" id="staffIDToDelete">
                                <button type="button" class="btn btn-danger" onclick="confirmDelete()">Delete</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!----main-content-end--->

                <!----footer-design------------->

                <footer class="footer">
                    <div class="container-fluid">
                        <div class="footer-in">
                            <p class="mb-0">&copy 2021 Vishweb Design . All Rights Reserved.</p>
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
            function deleteStaff(staffID) {
                if (confirm("Are you sure you want to delete this staff member?")) {
                    // Send an AJAX request to processDeleteStaff.jsp with the staffID parameter
                    $.ajax({
                        type: "POST",
                        url: "processDeleteStaff.jsp",
                        data: {staffID: staffID},
                        success: function (response) {
                            // Reload the page after successful deletion
                            window.location.reload();
                        },
                        error: function (error) {
                            console.log("Error:", error);
                            alert("Error deleting staff member. Please try again.");
                        }
                    });
                }
            }
        </script>
    </body>

</html>