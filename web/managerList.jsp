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
        <title>Manager List</title>
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
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css">
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
                            <li class=""><a href="customerList.jsp">Customer</a></li>
                            <li class=""><a href="staffList.jsp">Staff</a></li>
                            <li class="active"><a href="managerList.jsp">Manager</a></li>
                        </ul>
                    </li>
                    <li class="">
                        <a href="adminReport.jsp" class=""><i class="material-icons">library_books</i>Report</a></li>
                    <li class="">
                        <a href="homePage.jsp" class=""><i class="material-icons">power_settings_new</i>Sign Out</a></li>
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
                            <h4 class="page-title">Manage Manager</h4>
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
                        <!-- Add Manager Button (Moved to the top right corner) -->
                        <div class="text-right mb-4">
                            <button class="btn btn-primary" data-toggle="modal" data-target="#addManagerModal">Add Manager</button>
                        </div>
                        <!-- Manager Table -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="card-title">List of Managers</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped" id="managerTable" width="100%" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th>No.</th>
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
                                                String searchManagerID = request.getParameter("userID");
                                                String query = "SELECT * FROM manager";

                                                if (searchManagerID != null && !searchManagerID.isEmpty()) {
                                                    query = "SELECT * FROM manager WHERE userID = " + searchManagerID;
                                                }

                                                try {
                                                    Class.forName("com.mysql.jdbc.Driver");
                                                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");
                                                    Statement st = con.createStatement();
                                                    ResultSet rs = st.executeQuery(query);

                                                    int rowNum = 1;
                                                    while (rs.next()) {
                                                        // Retrieve manager details from the result set
                                                        String userIDs = rs.getString("userID") != null ? rs.getString("userID") : "";
                                                        String firstname = rs.getString("firstname") != null ? rs.getString("firstname") : "";
                                                        String lastname = rs.getString("lastname") != null ? rs.getString("lastname") : "";
                                                        String email = rs.getString("email") != null ? rs.getString("email") : "";
                                                        String phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                                                        String ICNumber = rs.getString("ICNumber") != null ? rs.getString("ICNumber") : "";
                                                        String residence = rs.getString("residence") != null ? rs.getString("residence") : "";
                                                        String city = rs.getString("city") != null ? rs.getString("city") : "";
                                                        String zipcode = rs.getString("zipcode") != null ? rs.getString("zipcode") : "";
                                                        String state = rs.getString("state") != null ? rs.getString("state") : "";
                                                        Blob profileIMG = rs.getBlob("profileIMG");
                                                        String profileIMGBase64 = "";
                                                        if (profileIMG != null) {
                                                            byte[] imgData = profileIMG.getBytes(1, (int) profileIMG.length());
                                                            profileIMGBase64 = Base64.getEncoder().encodeToString(imgData);
                                                        }
                                            %>
                                            <tr>
                                                <td><%= rowNum++%></td>
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
                                                            data-profileimg="<%= profileIMGBase64%>"
                                                            data-toggle="modal" data-target="#managerModal">View</button>
                                                    <button class="btn btn-danger btn-sm" onclick="deleteManager('<%= userIDs%>')">Delete</button>
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

                    <!-- Add Manager Modal -->
                    <div class="modal fade" id="addManagerModal" tabindex="-1" role="dialog" aria-labelledby="addManagerModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="addManagerModalLabel">Add Manager</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <!-- Add a form to input manager information -->
                                    <form action="processRegisterManager.jsp" method="post">
                                        <div class="form-group">
                                            <label for="firstname">Firstname:</label>
                                            <input type="text" class="form-control" name="firstname" id="firstname" placeholder="Enter Manager Firstname" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="lastname">Lastname</label>
                                            <input type="text" class="form-control" name="lastname" id="lastname" placeholder="Enter Manager Lastname" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="email">Email:</label>
                                            <input type="email" class="form-control" name="email" id="email" placeholder="Enter Manager Email" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="phone">Phone:</label>
                                            <input type="text" class="form-control" name="phone" id="phone" placeholder="Enter Manager Phone" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="password">Password:</label>
                                            <input type="password" class="form-control" name="password" id="password" placeholder="Enter Manager Password" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="confirmPassword">Confirm Password:</label>
                                            <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" placeholder="Re-Enter Manager Password" required oninput="checkPasswordMatch()">
                                        </div>

                                        <input type="hidden" name="roles" id="roles" value="manager">
                                        <!-- Add more input fields based on your manager information -->
                                        <button type="submit" class="btn btn-primary">ADD</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- View Manager Modal -->
                    <div class="modal fade" id="managerModal" tabindex="-1" role="dialog" aria-labelledby="managerModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="managerModalLabel">Manager Details</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <img id="modalManagerProfileIMG" src="" alt="Profile Image" style="width:100px; height:100px; border-radius:50%;">
                                    <p><strong>ID:</strong> <span id="modalManagerUserID"></span></p>
                                    <p><strong>Name:</strong> <span id="modalManagerFirstname"></span> <span id="modalManagerLastname"></span></p>
                                    <p><strong>Email:</strong> <span id="modalManagerEmail"></span></p>
                                    <p><strong>Phone:</strong> <span id="modalManagerPhone"></span></p>
                                    <p><strong>IC:</strong> <span id="modalManagerICNumber"></span></p>
                                    <p><strong>Residence:</strong> <span id="modalManagerResidence"></span></p>
                                    <p><strong>City:</strong> <span id="modalManagerCity"></span></p>
                                    <p><strong>Zipcode:</strong> <span id="modalManagerZipcode"></span></p>
                                    <p><strong>State:</strong> <span id="modalManagerState"></span></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                </div>
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
    </div>
    <!-------complete html----------->

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="JS/jquery-3.3.1.slim.min.js"></script>
    <script src="JS/popper.min.js"></script>
    <script src="JS/bootstrap.min.js"></script>
    <script src="JS/jquery-3.3.1.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
    <script>
                                                        $(document).ready(function () {
                                                            $("#managerTable").DataTable();

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
                                                                var profileIMG = $(this).data("profileimg");

                                                                // Set the data to the modal
                                                                $("#modalManagerUserID").text(userID);
                                                                $("#modalManagerFirstname").text(firstname);
                                                                $("#modalManagerLastname").text(lastname);
                                                                $("#modalManagerEmail").text(email);
                                                                $("#modalManagerPhone").text(phone);
                                                                $("#modalManagerICNumber").text(icnumber);
                                                                $("#modalManagerResidence").text(residence);
                                                                $("#modalManagerCity").text(city);
                                                                $("#modalManagerZipcode").text(zipcode);
                                                                $("#modalManagerState").text(state);
                                                                if (profileIMG) {
                                                                    $("#modalManagerProfileIMG").attr("src", "data:image/jpeg;base64," + profileIMG);
                                                                } else {
                                                                    $("#modalManagerProfileIMG").attr("src", "IMG/avatar.jpg");
                                                                }
                                                            });
                                                        });

                                                        function deleteManager(managerID) {
                                                            if (confirm("Are you sure you want to delete this manager?")) {
                                                                // Send an AJAX request to processDeleteManager.jsp with the managerID parameter
                                                                $.ajax({
                                                                    type: "POST",
                                                                    url: "processDeleteManager.jsp",
                                                                    data: {managerID: managerID},
                                                                    success: function (response) {
                                                                        // Reload the page after successful deletion
                                                                        window.location.reload();
                                                                    },
                                                                    error: function (error) {
                                                                        console.log("Error:", error);
                                                                        alert("Error deleting manager. Please try again.");
                                                                    }
                                                                });
                                                            }
                                                        }

                                                        function checkPasswordMatch() {
                                                            var password = document.getElementById("password").value;
                                                            var confirmPassword = document.getElementById("confirmPassword").value;
                                                            var passwordError = document.getElementById("passwordError");

                                                            if (password !== confirmPassword) {
                                                                passwordError.innerHTML = "Passwords do not match!";
                                                            } else {
                                                                passwordError.innerHTML = "";
                                                            }
                                                        }
    </script>
</body>
</html>
