<!DOCTYPE html>
<html lang=" en">

    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Customer dashboard</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/customerDash.css">


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
                    <li class="active">
                        <a href="customerDash.html" class="dashboard"><i class="material-icons">dashboard</i>dashboard </a>
                    </li>

                    <li class="">
                        <a href="customerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>

                    <li class="dropdown">
                        <a href="#homeSubmenu1" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <i class="material-icons">border_color</i>Quotation
                        </a>
                        <ul class="collapse list-unstyled menu" id="homeSubmenu1">
                            <li><a href="#">layout 1</a></li>
                            <li><a href="#">layout 2</a></li>
                            <li><a href="#">layout 3</a></li>
                        </ul>
                    </li>


                    <li class="dropdown">
                        <a href="#homeSubmenu2" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <i class="material-icons">library_books</i>Feedback
                        </a>
                        <ul class="collapse list-unstyled menu" id="homeSubmenu2">
                            <li><a href="#">Feedback for company</a></li>
                            <li><a href="#">Feedback for show</a></li>
                        </ul>
                    </li>

                    <li class="">
                        <a href="#" class=""><i class="material-icons">date_range</i>History</a>
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
                            <h4 class="page-title">Dashboard</h4>
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
                    <img src="IMG/takaful_ikhlas.jpg" alt="Main Content Image">
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

                // Image changing functionality
                var images = ["IMG/takaful_malaysia.jpg", "IMG/zurich.jpg", "IMG/allianz.jpg"]; // Add your image URLs here
                var currentIndex = 0;

                function changeMainContentImage() {
                    $("#main-content-image img").fadeOut(500, function () {
                        $(this).attr("src", images[currentIndex]);
                    }).fadeIn(500);
                    currentIndex = (currentIndex + 1) % images.length;
                }

                // Call the function to start changing images
                setInterval(changeMainContentImage, 5000); // Change image every 5 seconds (adjust as needed)
            });
        </script>

    </body>

</html>