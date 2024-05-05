<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String userID = (String) session.getAttribute("userID");
    String quotationIdStr = request.getParameter("quotationId");
    int quotationId = quotationIdStr != null ? Integer.parseInt(quotationIdStr) : -1;

    if (userID != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM customer WHERE userID = ?");
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Customer data retrieved successfully...
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("An error occurred while fetching customer data. Please try again later.");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("An error occurred while loading the database driver.");
        }
    } else {
        out.println("User not logged in.");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Feedback Page</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/customerFeedback.css">
        <!--google fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!--google material icon-->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <!--star-->
        <link href='https://unpkg.com/boxicons@2.1.1/css/boxicons.min.css' rel='stylesheet'>
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
                        <a href="customerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>dashboard </a>
                    </li>
                    <li class="">
                        <a href="customerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="">
                        <a href="customerQuo.jsp" class=""><i class="material-icons">border_color</i>Quotation</a>
                    </li>
                    <li class="active">
                        <a href="customerFeedback.jsp" class=""><i class="material-icons">library_books</i>Feedback</a>
                    </li>
                    <li class="">
                        <a href="customerHistory.jsp" class=""><i class="material-icons">date_range</i>History</a>
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

                                            <li class="nav-item">
                                                <a class="nav-link" href="#">
                                                    <span class="material-icons">question_answer</span>
                                                </a>
                                            </li>

                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="customerProfile.jsp">
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
                            <h4 class="page-title">Feedback</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Customer</a></li>
                                <!-- <li class="breadcrumb-item active" aria-curent="page">Dashboard</li> -->
                            </ol>
                        </div>


                    </div>
                </div>
                <!------top-navbar-end----------->

                <!----main-content--->
                <div id="main-content-image">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-8 offset-md-2">
                                <div class="card mt-5">
                                    <div class="card-body">
                                        <h5 class="card-title">Feedback Box</h5>
                                        <form action="submitFeedback" method="post"> 
                                            <div class="form-group">
                                                <label for="feedback">Your Feedback:</label>
                                                <textarea class="form-control" id="feedback" name="feedback" rows="3"></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label for="rating">Rate your experience:</label><br>
                                                <div class="rating">
                                                    <input type="hidden" name="rating" id="rating" value="0"> <!-- Hidden input for rating -->
                                                    <i class='bx bx-star star' style="--i: 0;"></i>
                                                    <i class='bx bx-star star' style="--i: 1;"></i>
                                                    <i class='bx bx-star star' style="--i: 2;"></i>
                                                    <i class='bx bx-star star' style="--i: 3;"></i>
                                                    <i class='bx bx-star star' style="--i: 4;"></i>
                                                </div>
                                            </div>
                                            <input type="hidden" class="form-control" id="userID" name="userID" value="<%= userID%>">
                                            <input type="hidden" class="form-control" id="quotationId" name="quotationId" value="<%= quotationId %>">
                                            <p>Quotation : <%=quotationId%></p>
                                            <button type="submit" class="btn btn-primary">Submit Feedback</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!----main-content-end--->

                <!----footer-design------------->

                <footer class="footer">
                    <div class="container-fluid">
                        <div class="footer-in">
                            <p>&copy; 2024 RAZ WAWASAN SDN BHD (ADLI YONG)</p>
                        </div>
                    </div>
                </footer>
            </div>
        </div>

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
            const allStar = document.querySelectorAll('.rating .star')
            const ratingValue = document.querySelector('.rating input')

            allStar.forEach((item, idx) => {
                item.addEventListener('click', function () {
                    let click = 0
                    ratingValue.value = idx + 1

                    allStar.forEach(i => {
                        i.classList.replace('bxs-star', 'bx-star')
                        i.classList.remove('active')
                    })
                    for (let i = 0; i < allStar.length; i++) {
                        if (i <= idx) {
                            allStar[i].classList.replace('bx-star', 'bxs-star')
                            allStar[i].classList.add('active')
                        } else {
                            allStar[i].style.setProperty('--i', click)
                            click++
                        }
                    }
                })
            })
        </script>
    </body>




</html>