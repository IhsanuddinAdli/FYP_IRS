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
                                        <input type="text" class="form-control wide-input" id="owner-name" name="owner-name" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="owner-id">Owner's Identification Number</label>
                                        <input type="text" class="form-control wide-input" id="owner-id" name="owner-id"maxlength="12"required>
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
                                        <select class="form-control" id="marital-status" name="marital-status" required>
                                            <option>Select a status</option>
                                            <option value="single">Single</option>
                                            <option value="married">Married</option>
                                            <option value="divorced">Divorced</option>
                                            <option value="widowed">Widowed</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="location">Location</label>
                                        <select class="form-control" id="location" name="location" required>
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
                                    <select class="form-control wide-input" id="vehicle-type" name="vehicle-type" required>
                                        <option>Select vehicle type</option>
                                        <option value="Car">Car</option>
                                        <option value="Motorcycle">Motorcycle</option>
                                        <option value="Van">Van</option>
                                        <option value="Lorry">Lorry</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="local-import">Local / Import Vehicle</label>
                                    <select class="form-control" id="local-import" name="local-import" required>
                                        <option>Select local / import</option>
                                        <option value="local">Local</option>
                                        <option value="import">Import</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="registration-number">Vehicle Registration Number</label>
                                    <input type="text" class="form-control wide-input" id="registration-number" name="registration-number" placeholder="Example: ABC123" required>
                                </div>
                                <div class="form-group">
                                    <label for="engine-number">Engine Number</label>
                                    <input type="text" class="form-control wide-input" id="engine-number" name="engine-number" placeholder="Example: 1234567890" required>
                                </div>
                                <div class="form-group">
                                    <label for="chassis-number">Chassis Number</label>
                                    <input type="text" class="form-control wide-input" id="chassis-number" name="chassis-number" placeholder="Example: 123ABC456DEF" required>
                                </div>
                                <div class="form-group">
                                    <label for="coverage">Coverage</label>
                                    <select class="form-control" id="coverage" name="coverage" required>
                                        <option>Select a coverage</option>
                                        <option value="comprehensive">Comprehensive</option>
                                        <option value="third-party-motorcycle">Third Party</option>
                                        <option value="third-party-fire-theft">Third Party Fire and Theft</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="insured-value">Insured Value (in RM)</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">RM</span>
                                        </div>
                                        <input type="text" class="form-control wide-input" id="insured-value" name="insured-value" placeholder="Enter Insured Value" min="0" step="0.01" required>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="vehicle-body">Vehicle Body</label>
                                    <select class="form-control" id="vehicle-body" name="vehicle-body" onchange="updateVehicleMakes()" required>
                                        <option>Select a body first</option>
                                        <option value="Sedan">Sedan</option>
                                        <option value="Hatchback">Hatchback</option>
                                        <option value="SUV">SUV (Sports Utility Vehicle)</option>
                                        <option value="MPV">MPV (Multi-Purpose Vehicle)</option>
                                        <option value="Motorcycle">Motorcycle</option>
                                        <option value="Van">Van</option>
                                        <option value="Lorry">Lorry</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="vehicle-make">Vehicle Make</label>
                                    <select class="form-control wide-input" id="vehicle-make" name="vehicle-make" required>
                                        <option>Select a make first</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="vehicle-model">Vehicle Model</label>
                                    <select class="form-control wide-input" id="vehicle-model" name="vehicle-model" required>
                                        <option>Select a model first</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="engine-capacity">Engine Capacity (CC)</label>
                                    <input type="text" class="form-control wide-input" id="engine-capacity" name="engine-capacity" placeholder="Example: 2000" required>
                                </div>
                                <div class="form-group">
                                    <label for="manufacture-year">Year Of Manufactured</label>
                                    <input type="text" class="form-control wide-input" id="manufacture-year" name="manufacture-year" placeholder="Example: 2022" required>
                                </div>
                                <div class="form-group">
                                    <label for="ncd">
                                        Current NCD 
                                        <a href="https://www.mycarinfo.com.my/NCDCheck/Online" target="_blank">(Check NCD)</a>
                                    </label>
                                    <select class="form-control" id="ncd" name="ncd" required>
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
                                    <input type="date" class="form-control wide-input" id="policy-commencement-date" name="policy-commencement-date" required>
                                </div>
                                <div class="form-group">
                                    <label for="policy-duration">Policy Duration</label>
                                    <select class="form-control" id="policy-duration" name="policy-duration" required>
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
                        <div class="row" id="add-ons-section">
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
                                <button type="button" class="btn btn-primary" onclick="submitForm()">Calculate Insurance</button>
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
    function submitForm() {
        var vehicleType = document.getElementById("vehicle-type").value;
        var coverageType = document.getElementById("coverage").value;
        var form = document.getElementById("quotation-form");

        if (vehicleType === "Car") {
            if (coverageType === "comprehensive") {
                form.action = "carComprehensive.jsp";
            } else if (coverageType === "third-party-fire-theft") {
                form.action = "carTPFT.jsp";
            }
        } else if (vehicleType === "Motorcycle") {
            if (coverageType === "comprehensive") {
                form.action = "motoComprehensive.jsp";
            } else if (coverageType === "third-party-motorcycle") {
                form.action = "motoTP.jsp";
            }
        } else if (vehicleType === "Van") {
            if (coverageType === "comprehensive") {
                form.action = "vanComprehensive.jsp";
            } else if (coverageType === "third-party-fire-theft") {
                form.action = "vanTPFT.jsp";
            }
        } else if (vehicleType === "Lorry") {
            if (coverageType === "comprehensive") {
                form.action = "lorryComprehensive.jsp";
            } else if (coverageType === "third-party-fire-theft") {
                form.action = "lorryTPFT.jsp";
            }
        }

        form.submit();
    }
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
<script src="JS/vehicleList.js"></script>
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
    $(document).ready(function () {
        // Set the minimum date for policy commencement date input field
        var currentDate = new Date();
        var nextDay = new Date(currentDate);
        nextDay.setDate(currentDate.getDate() + 1); // Get the next day

        var minDate = currentDate.toISOString().split('T')[0]; // Format date as YYYY-MM-DD

        $("#policy-commencement-date").attr('min', minDate);
    });

    //for disable add-ons
    // Function to disable add-ons based on selected coverage
    function toggleAddonsState() {
        var coverage = document.getElementById("coverage").value;
        var addonsCheckboxes = document.querySelectorAll("#add-ons-section input[type='checkbox']");
        var addonsSelects = document.querySelectorAll("#add-ons-section select");

        // Check if the selected coverage is "Comprehensive"
        if (coverage === "comprehensive") {
            // Enable all checkboxes and select elements
            addonsCheckboxes.forEach(function (checkbox) {
                checkbox.disabled = false;
            });
            addonsSelects.forEach(function (select) {
                select.disabled = false;
            });
        } else {
            // Disable all checkboxes and select elements
            addonsCheckboxes.forEach(function (checkbox) {
                checkbox.disabled = true;
            });
            addonsSelects.forEach(function (select) {
                select.disabled = true;
            });
        }
    }

// Add event listener to the coverage select element
    document.getElementById("coverage").addEventListener("change", toggleAddonsState);

// Call the function initially to set the initial state based on the selected coverage
    toggleAddonsState();

    // Function to hide Third Party and Third Party Fire and Theft options based on selected vehicle type
    function toggleCoverageOptions() {
        var vehicleType = document.getElementById("vehicle-type").value;
        var coverageSelect = document.getElementById("coverage");
        var thirdPartyOption = coverageSelect.querySelector("option[value='third-party-motorcycle']");
        var tpftOption = coverageSelect.querySelector("option[value='third-party-fire-theft']");

        // Check if the selected vehicle type is Car, Van, or Lorry
        if (vehicleType === "Car" || vehicleType === "Van" || vehicleType === "Lorry") {
            // Hide the Third Party option
            thirdPartyOption.style.display = "none";
            // Show the Third Party Fire and Theft option
            tpftOption.style.display = "block";
        } else if (vehicleType === "Motorcycle") {
            // Hide the Third Party Fire and Theft option
            tpftOption.style.display = "none";
            // Show the Third Party option
            thirdPartyOption.style.display = "block";
        } else {
            // Show both options if none of the vehicle types are selected
            thirdPartyOption.style.display = "block";
            tpftOption.style.display = "block";
        }
    }

    // Add event listener to the vehicle type select element
    document.getElementById("vehicle-type").addEventListener("change", toggleCoverageOptions);

    // Call the function initially to set the initial state based on the selected vehicle type
    toggleCoverageOptions();
</script>
<script>
    var originalVehicleMakes = [
        "Alfa Romeo", "Audi", "BMW", "Borgward", "Chery", "Chevrolet", "Citroen", "Ford", "Honda",
        "Hyundai", "Infiniti", "Isuzu", "Jaguar", "Jeep", "Kia", "Land Rover", "Lexus", "Mazda",
        "Mercedes-Benz", "MINI", "Mitsubishi", "Nissan", "Perodua", "Peugeot", "Proton", "Subaru",
        "Suzuki", "Toyota", "Volkswagen", "Volvo"
    ];

    function updateVehicleMakes() {
        var vehicleBody = document.getElementById("vehicle-body").value;
        var vehicleMakeSelect = document.getElementById("vehicle-make");
        vehicleMakeSelect.innerHTML = ""; // Clear existing options

        if (vehicleBody === "Motorcycle") {
            addOptions(vehicleMakeSelect, [
                "Yamaha", "Honda", "Kawasaki", "Sym", "Harley-Davidson",
                "Suzuki", "Benelli", "Ducati", "BMW", "Vespa", "Aprilia", "Daiichi", "Modenas", "Piaggio",
                "Moto Guzzi", "GPX", "Royal Enfield", "Brixton"
            ]);
        } else if (vehicleBody === "Van") {
            addOptions(vehicleMakeSelect, ["Toyota", "Nissan", "Daihatsu", "Foton"]);
        } else if (vehicleBody === "Lorry") {
            addOptions(vehicleMakeSelect, ["Hino", "Fuso", "Isuzu", "UD Truck", "Volvo", "CAMC", "Foton", "JMC"]);
        } else {
            addOptions(vehicleMakeSelect, originalVehicleMakes);
        }
    }

    function addOptions(selectElement, options) {
        options.forEach(function (option) {
            var optionElement = document.createElement("option");
            optionElement.text = option;
            optionElement.value = option;
            selectElement.add(optionElement);
        });
    }
</script>
</body>
</html>
