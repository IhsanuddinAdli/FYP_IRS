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
        <link rel="stylesheet" href="CSS/customerQuoForm.css">
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
                    <form id="quotation-form" action="carInsuranceQuotation.jsp" method="post">
                        <div class="container">
                            <h2 style="text-align: center;">Insured Particulars</h2>
                            <div class="row">
                                <!-- Insured Particulars -->
                                <div class="col-md-6"> <!-- Use col-md-6 to make two columns in one row -->
                                    <div class="form-group">
                                        <label for="owner-name">Owner's Name</label>
                                        <input type="text" class="form-control wide-input" id="owner-name" name="owner-name" placeholder="Example: Ihsanuddin">
                                    </div>
                                    <div class="form-group">
                                        <label for="owner-id">Owner's Identification Number</label>
                                        <input type="text" class="form-control wide-input" id="owner-id" name="owner-id" placeholder="Example: 123456789" maxlength="12">
                                    </div>
                                    <div class="form-group">
                                        <label for="dob">Date of Birth</label>
                                        <input type="text" class="form-control wide-input" id="dob" name="dob" readonly>
                                    </div>
                                    <div class="form-group">
                                        <label for="gender">Gender</label>
                                        <input type="text" class="form-control wide-input" id="gender" name="gender" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="marital-status">Marital Status</label>
                                        <select class="form-control" id="marital-status" name="marital-status">
                                            <option>Select a status</option>
                                            <option value="single">Single</option>
                                            <option value="married">Married</option>
                                            <option value="divorced">Divorced</option>
                                            <option value="widowed">Widowed</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="location">Location</label>
                                        <select class="form-control" id="location" name="location">
                                            <option>Select a location</option>
                                            <option value="peninsular">Peninsular Malaysia</option>
                                            <option value="east">East Malaysia</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <!-- Vehicle Particulars -->
                        <h2 style="text-align: center;">Vehicle Particulars</h2>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="vehicle-type">Vehicle Type</label>
                                    <input type="text" class="form-control wide-input" id="vehicle-type" name="vehicle-type" value="Car" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="local-import">Local / Import Vehicle</label>
                                    <select class="form-control" id="local-import" name="local-import">
                                        <option>Select local / import</option>
                                        <option value="local">Local</option>
                                        <option value="import">Import</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="registration-number">Vehicle Registration Number</label>
                                    <input type="text" class="form-control wide-input" id="registration-number" name="registration-number" placeholder="Example: ABC123">
                                </div>
                                <div class="form-group">
                                    <label for="engine-number">Engine Number</label>
                                    <input type="text" class="form-control wide-input" id="engine-number" name="engine-number" placeholder="Example: 1234567890">
                                </div>
                                <div class="form-group">
                                    <label for="chassis-number">Chassis Number</label>
                                    <input type="text" class="form-control wide-input" id="chassis-number" name="chassis-number" placeholder="Example: 123ABC456DEF">
                                </div>
                                <div class="form-group">
                                    <label for="coverage">Coverage</label>
                                    <select class="form-control" id="coverage" name="coverage">
                                        <option>Select a coverage</option>
                                        <option value="comprehensive">Comprehensive</option>
                                        <option value="third-party-motorcycle">Third Party (Motorcycle only)</option>
                                        <option value="third-party-fire-theft">Third Party Fire and Theft</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="insured-value">Insured Value (in MYR)</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">MYR</span>
                                        </div>
                                        <input type="text" class="form-control wide-input" id="insured-value" name="insured-value" placeholder="Enter Insured Value" min="0" step="0.01">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="vehicle-body">Vehicle Body</label>
                                    <select class="form-control" id="vehicle-body" name="vehicle-body">
                                        <option>Select a body first</option>
                                        <option value="Sedan">Sedan</option>
                                        <option value="Hatchback">Hatchback</option>
                                        <option value="SUV">SUV (Sports Utility Vehicle)</option>
                                        <option value="MPV">MPV (Multi-Purpose Vehicle)</option>
                                        <option value="Coupe">Coupe</option>
                                        <option value="Convertible">Convertible</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="vehicle-make">Vehicle Make</label>
                                    <select class="form-control wide-input" id="vehicle-make" name="vehicle-make">
                                        <option>Select a make first</option>
                                        <option value="Alfa Romeo">Alfa Romeo</option>
                                        <option value="Audi">Audi</option>
                                        <option value="BMW">BMW</option>
                                        <option value="Borgward">Borgward</option>
                                        <option value="Chery">Chery</option>
                                        <option value="Chevrolet">Chevrolet</option>
                                        <option value="Citroen">Citroen</option>
                                        <option value="Ford">Ford</option>
                                        <option value="Honda">Honda</option>
                                        <option value="Hyundai">Hyundai</option>
                                        <option value="Infiniti">Infiniti</option>
                                        <option value="Isuzu">Isuzu</option>
                                        <option value="Jaguar">Jaguar</option>
                                        <option value="Jeep">Jeep</option>
                                        <option value="Kia">Kia</option>
                                        <option value="Land Rover">Land Rover</option>
                                        <option value="Lexus">Lexus</option>
                                        <option value="Mazda">Mazda</option>
                                        <option value="Mercedes-Benz">Mercedes-Benz</option>
                                        <option value="MINI">MINI</option>
                                        <option value="Mitsubishi">Mitsubishi</option>
                                        <option value="Nissan">Nissan</option>
                                        <option value="Perodua">Perodua</option>
                                        <option value="Peugeot">Peugeot</option>
                                        <option value="Proton">Proton</option>
                                        <option value="Subaru">Subaru</option>
                                        <option value="Suzuki">Suzuki</option>
                                        <option value="Toyota">Toyota</option>
                                        <option value="Volkswagen">Volkswagen</option>
                                        <option value="Volvo">Volvo</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="vehicle-model">Vehicle Model</label>
                                    <select class="form-control wide-input" id="vehicle-model" name="vehicle-model">
                                        <option>Select a model first</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="engine-capacity">Engine Capacity</label>
                                    <input type="text" class="form-control wide-input" id="engine-capacity" name="engine-capacity" placeholder="Example: 2000 cc">
                                </div>
                                <div class="form-group">
                                    <label for="manufacture-year">Year Of Manufactured</label>
                                    <input type="text" class="form-control wide-input" id="manufacture-year" name="manufacture-year" placeholder="Example: 2022">
                                </div>
                                <div class="form-group">
                                    <label for="ncd">Current NCD</label>
                                    <select class="form-control" id="ncd" name="ncd">
                                        <option>Select a NCD</option>
                                        <option value="0%">0%</option>
                                        <option value="30%">30%</option>
                                        <option value="38.33%">38.33%</option>
                                        <option value="45%">45%</option>
                                        <option value="55%">55%</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="policy-commencement-date">Policy Commencement Date</label>
                                    <input type="date" class="form-control wide-input" id="policy-commencement-date" name="policy-commencement-date">
                                </div>
                                <div class="form-group">
                                    <label for="policy-duration">Policy Duration</label>
                                    <select class="form-control" id="policy-duration" name="policy-duration">
                                        <option>Select a policy duration</option>
                                        <option value="6">6 months</option>
                                        <option value="12">12 months</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="policy-expiry-date">Policy Expiry Date</label>
                                    <input type="text" class="form-control wide-input" id="policy-expiry-date" name="policy-expiry-date" readonly>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <!-- add-ons -->
                        <h2 style="text-align: center;">Add-ons</h2>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" id="windscreen-addon" name="windscreen-addon" value="true">
                                    <label class="form-check-label" for="windscreen-addon">
                                        Windscreen
                                        <a href="https://www.autoglass.com.my/insurance-pricelist.html" target="_blank">(Price List)</a>
                                    </label>
                                    <!-- Windscreen price input field initially hidden -->
                                    <input type="number" class="form-control wide-input" id="windscreen-price" name="windscreen-price" placeholder="Enter windscreen price (RM)" style="display: none;">
                                </div>
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" id="all-driver-addon" name="all-driver-addon" value="true">
                                    <label class="form-check-label" for="all-driver-addon">All Driver</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" id="special-perils-addon" name="special-perils-addon" value="true">
                                    <label class="form-check-label" for="special-perils-addon">Special Perils (Flood)</label>
                                </div>
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" id="legal-liability-addon" name="legal-liability-addon" value="true">
                                    <label class="form-check-label" for="legal-liability-addon">Legal Liability of Passengers</label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <button type="submit" class="btn btn-primary">Calculate Insurance</button>
                            </div>
                        </div>
                    </form>
                </div>
                <!----main-content-end--->
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
    document.getElementById('owner-id').addEventListener('input', function () {
        var icNumber = this.value.trim();

        if (icNumber.length == 12) {
            var yearPrefix = parseInt(icNumber.substring(0, 2));
            var year = (yearPrefix < 55) ? 2000 + yearPrefix : 1900 + yearPrefix;
            var month = parseInt(icNumber.substring(2, 4));
            var day = parseInt(icNumber.substring(4, 6));
            var genderCode = parseInt(icNumber.substring(11, 12));

            var gender = (genderCode % 2 == 0) ? 'Female' : 'Male';

            document.getElementById('dob').value = year + '-' + (month < 10 ? '0' + month : month) + '-' + (day < 10 ? '0' + day : day);
            document.getElementById('gender').value = gender;
        } else {
            document.getElementById('dob').value = '';
            document.getElementById('gender').value = '';
        }
    });

    document.getElementById('policy-commencement-date').addEventListener('input', function () {
        generatePolicyExpiryDate();
    });

    document.getElementById('policy-duration').addEventListener('change', function () {
        generatePolicyExpiryDate();
    });

    function generatePolicyExpiryDate() {
        var commencementDate = document.getElementById('policy-commencement-date').value;
        var duration = parseInt(document.getElementById('policy-duration').value);
        var expiryDate = new Date(commencementDate);

        expiryDate.setMonth(expiryDate.getMonth() + duration);

        document.getElementById('policy-expiry-date').value = expiryDate.toISOString().split('T')[0];
    }
</script>
<script src="JS/carList.js"></script>
<script>
    // Function to show/hide windscreen price input field based on checkbox state
    document.getElementById("windscreen-addon").addEventListener("change", function () {
        var windscreenPriceInput = document.getElementById("windscreen-price");
        if (this.checked) {
            windscreenPriceInput.style.display = "block"; // Show the input field
        } else {
            windscreenPriceInput.style.display = "none"; // Hide the input field
        }
    });
</script>
</body>
</html>
