<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Quotation Form Page</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!----css3---->
        <link rel="stylesheet" href="CSS/quoteCar.css">
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
                        <a href="customerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>dashboard </a>
                    </li>
                    <li class="">
                        <a href="customerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="active">
                        <a href="customerQuo.jsp" class=""><i class="material-icons">border_color</i>Quotation</a>
                    </li>
                    <li class="">
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
                            <h4 class="page-title">Quotation Form</h4>
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
                        <form id="quotation-form">
                            <div class="row"> <!-- Add a row wrapper -->
                                <!-- Insured Particulars -->
                                <div class="col-md-6"> <!-- Use col-md-6 to make two columns in one row -->
                                    <div class="form-group">
                                        <label for="owner-name">Owner's Name</label>
                                        <input type="text" class="form-control wide-input" id="owner-name" placeholder="Example: Ihsanuddin">
                                    </div>
                                    <div class="form-group">
                                        <label for="owner-id">Owner's Identification Number</label>
                                        <input type="text" class="form-control wide-input" id="owner-id" placeholder="Example: 123456789" maxlength="9">
                                    </div>
                                    <div class="form-group">
                                        <label for="dob">Date of Birth (Auto-generated from ID number above)</label>
                                        <input type="text" class="form-control wide-input" id="dob" placeholder="Auto-generated">
                                    </div>
                                    <div class="form-group">
                                        <label for="gender">Gender (Auto-generated from ID number above)</label>
                                        <input type="text" class="form-control wide-input" id="gender" placeholder="Auto-generated">
                                    </div>
                                    <div class="form-group">
                                        <label for="marital-status">Marital Status</label>
                                        <select class="form-control" id="marital-status">
                                            <option value="single">Single</option>
                                            <option value="married">Married</option>
                                            <option value="divorced">Divorced</option>
                                            <option value="widowed">Widowed</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="owner-address">Owner's Address</label>
                                        <input type="text" class="form-control wide-input" id="owner-address" placeholder="Example: 123 Main St, City, Country">
                                    </div>
                                </div>
                                <hr>
                                <!-- Vehicle Particulars -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="vehicle-type">Vehicle Type</label>
                                        <input type="text" class="form-control wide-input" id="vehicle-type" placeholder="Example: Sedan">
                                    </div>
                                    <div class="form-group">
                                        <label for="local-import">Local / Import Vehicle</label>
                                        <select class="form-control" id="local-import">
                                            <option value="local">Local</option>
                                            <option value="import">Import</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="registration-number">Vehicle Registration Number</label>
                                        <input type="text" class="form-control wide-input" id="registration-number" placeholder="Example: ABC123">
                                    </div>
                                    <div class="form-group">
                                        <label for="engine-number">Engine Number</label>
                                        <input type="text" class="form-control wide-input" id="engine-number" placeholder="Example: 1234567890">
                                    </div>
                                    <div class="form-group">
                                        <label for="chassis-number">Chassis Number</label>
                                        <input type="text" class="form-control wide-input" id="chassis-number" placeholder="Example: 123ABC456DEF">
                                    </div>
                                    <div class="form-group">
                                        <label for="coverage">Coverage</label>
                                        <select class="form-control" id="coverage">
                                            <option value="comprehensive">Comprehensive</option>
                                            <option value="third-party-motorcycle">Third Party (Motorcycle only)</option>
                                            <option value="third-party-fire-theft">Third Party Fire and Theft</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="vehicle-body">Vehicle Body</label>
                                        <input type="text" class="form-control wide-input" id="vehicle-body" placeholder="Example: Sedan">
                                    </div>
                                    <div class="form-group">
                                        <label for="vehicle-make">Vehicle Make</label>
                                        <input type="text" class="form-control wide-input" id="vehicle-make" placeholder="Example: Toyota">
                                    </div>
                                    <div class="form-group">
                                        <label for="vehicle-model">Vehicle Model</label>
                                        <input type="text" class="form-control wide-input" id="vehicle-model" placeholder="Example: Camry">
                                    </div>
                                    <div class="form-group">
                                        <label for="engine-capacity">Engine Capacity</label>
                                        <input type="text" class="form-control wide-input" id="engine-capacity" placeholder="Example: 2000 cc">
                                    </div>
                                    <div class="form-group">
                                        <label for="manufacture-year">Year Of Manufactured</label>
                                        <input type="text" class="form-control wide-input" id="manufacture-year" placeholder="Example: 2022">
                                    </div>
                                    <div class="form-group">
                                        <label for="ncd">Current NCD</label>
                                        <input type="text" class="form-control wide-input" id="ncd" placeholder="Example: 20%">
                                    </div>
                                    <div class="form-group">
                                        <label for="policy-commencement-date">Policy Commencement Date</label>
                                        <input type="date" class="form-control wide-input" id="policy-commencement-date">
                                    </div>
                                    <div class="form-group">
                                        <label for="policy-expiry-date">Policy Expiry Date (auto generate one year from policy commencement date)</label>
                                        <input type="text" class="form-control wide-input" id="policy-expiry-date" readonly>
                                    </div>
                                </div>
                            </div> <!-- End of row -->
                        </form>
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
    </body>
</html>
