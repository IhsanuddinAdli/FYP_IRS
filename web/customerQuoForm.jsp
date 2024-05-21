<%@page import="com.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%
    String userID = (String) session.getAttribute("userID");
    String roles = (String) session.getAttribute("roles");
    String vehicleType = request.getParameter("vehicle");
    if (userID != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM customer WHERE userID = ? ");
            ps.setString(1, userID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                roles = rs.getString("roles");
            }
        } catch (SQLException e) {
            // Handle SQLException (print or log the error)
            e.printStackTrace();
            out.println("An error occurred while fetching customer data. Please try again later.");
        }
    } else {
        // Handle the case where customerID is not found in the session
        out.println("CustomerID not found in the session.");
    }
%>
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
                        <a href="customerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard </a>
                    </li>
                    <li class="">
                        <a href="customerProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a>
                    </li>
                    <li class="dropdown">
                        <a href="#quotationMenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <i class="material-icons">border_color</i>Quotation <b class="caret"></b>
                        </a>
                        <ul class="collapse list-unstyled menu" id="quotationMenu">
                            <li class="active"><a href="customerQuo.jsp"><i class="material-icons">list</i> Quotation Form</a></li>
                            <li class=""><a href="customerQuoList.jsp"><i class="material-icons">list_alt</i> Quotations List</a></li>
                        </ul>
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
                                                <%
                                                    String userId = (String) session.getAttribute("userID");
                                                    if (userId != null) {
                                                        try {
                                                            Connection conn = DBConnection.getConnection();
                                                            PreparedStatement ps = conn.prepareStatement(
                                                                    "SELECT COUNT(*) AS count FROM QuotationHistory WHERE userID = ? AND notification_sent = TRUE");
                                                            ps.setString(1, userId);
                                                            ResultSet rs = ps.executeQuery();
                                                            if (rs.next() && rs.getInt("count") > 0) {
                                                                int notifications = rs.getInt("count");
                                                                out.println("<a class='nav-link' href='#' data-toggle='dropdown'><span class='material-icons'>notifications</span><span class='notification'>" + notifications + "</span></a>");
                                                                out.println("<ul class='dropdown-menu'><li><a href='#'>You have " + notifications + " new notifications.</a></li></ul>");
                                                            } else {
                                                                out.println("<a class='nav-link' href='#'><span class='material-icons'>notifications</span></a>");
                                                                out.println("<ul class='dropdown-menu'><li><a href='#'>No new notifications.</a></li></ul>");
                                                            }
                                                            rs.close();
                                                            ps.close();
                                                            conn.close();
                                                        } catch (SQLException e) {
                                                            e.printStackTrace();
                                                        }
                                                    }
                                                %>
                                            </li>
                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="customerProfile.jsp">
                                                    <img src="getImage?userID=<%= userID%>&roles=<%= roles%>" alt="Avatar" class="img-fluid rounded-circle" style="width:40px; height:40px; border-radius:50%;" />
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
                    <form id="quotation-form" action="saveQuotation.jsp" method="post">
                        <div class="container">
                            <h2 style="text-align: center;">Insured Particulars</h2>
                            <div class="row">
                                <!-- Insured Particulars -->
                                <input type="hidden" id="userID" name="userID" value="<%= request.getAttribute("userID") != null ? request.getAttribute("userID") : ""%>">
                                <input type="hidden" id="quotationId" name="quotationId" value="<%= request.getAttribute("quotationId") != null ? request.getAttribute("quotationId") : ""%>">
                                <div class="col-md-6"> <!-- Use col-md-6 to make two columns in one row -->
                                    <div class="form-group">
                                        <label for="owner-name">Owner's Name</label>
                                        <input type="text" class="form-control wide-input" id="owner-name" name="owner-name" value="<%= request.getAttribute("ownerName") != null ? request.getAttribute("ownerName") : ""%>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="owner-id">Owner's Identification Number</label>
                                        <input type="text" class="form-control wide-input" id="owner-id" name="owner-id" value="<%= request.getAttribute("ownerId") != null ? request.getAttribute("ownerId") : ""%>" maxlength="12" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="dob">Date of Birth</label>
                                        <input type="text" class="form-control wide-input" id="dob" name="dob" value="<%= request.getAttribute("dob") != null ? request.getAttribute("dob") : ""%>" readonly>
                                    </div>
                                    <div class="form-group">
                                        <label for="gender">Gender</label>
                                        <input type="text" class="form-control wide-input" id="gender" name="gender" value="<%= request.getAttribute("gender") != null ? request.getAttribute("gender") : ""%>" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="marital-status">Marital Status</label>
                                        <select class="form-control" id="marital-status" name="marital-status" required>
                                            <option>Select a status</option>
                                            <option value="single" <%= (request.getAttribute("maritalStatus") != null && request.getAttribute("maritalStatus").equals("single")) ? "selected" : ""%>>Single</option>
                                            <option value="married" <%= (request.getAttribute("maritalStatus") != null && request.getAttribute("maritalStatus").equals("married")) ? "selected" : ""%>>Married</option>
                                            <option value="divorced" <%= (request.getAttribute("maritalStatus") != null && request.getAttribute("maritalStatus").equals("divorced")) ? "selected" : ""%>>Divorced</option>
                                            <option value="widowed" <%= (request.getAttribute("maritalStatus") != null && request.getAttribute("maritalStatus").equals("widowed")) ? "selected" : ""%>>Widowed</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="location">Location</label>
                                        <select class="form-control" id="location" name="location" required>
                                            <option>Select a location</option>
                                            <option value="peninsular" <%= (request.getAttribute("location") != null && request.getAttribute("location").equals("peninsular")) ? "selected" : ""%>>Peninsular Malaysia</option>
                                            <option value="east" <%= (request.getAttribute("location") != null && request.getAttribute("location").equals("east")) ? "selected" : ""%>>East Malaysia</option>
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
                                    <input type="text" class="form-control wide-input" id="vehicle-type" name="vehicle-type" value="<%= vehicleType != null ? vehicleType : (request.getAttribute("vehicleType") != null ? request.getAttribute("vehicleType") : "") %>" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="local-import">Local / Import Vehicle</label>
                                    <select class="form-control" id="local-import" name="local-import" required>
                                        <option>Select local / import</option>
                                        <option value="local" <%= (request.getAttribute("localImport") != null && request.getAttribute("localImport").equals("local")) ? "selected" : ""%>>Local</option>
                                        <option value="import" <%= (request.getAttribute("localImport") != null && request.getAttribute("localImport").equals("import")) ? "selected" : ""%>>Import</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="registration-number">Vehicle Registration Number</label>
                                    <input type="text" class="form-control wide-input" id="registration-number" name="registration-number" value="<%= request.getAttribute("registrationNumber") != null ? request.getAttribute("registrationNumber") : ""%>" placeholder="Example: ABC123" required>
                                </div>
                                <div class="form-group">
                                    <label for="engine-number">Engine Number</label>
                                    <input type="text" class="form-control wide-input" id="engine-number" name="engine-number" value="<%= request.getAttribute("engineNumber") != null ? request.getAttribute("engineNumber") : ""%>" placeholder="Example: 1234567890" required>
                                </div>
                                <div class="form-group">
                                    <label for="chassis-number">Chassis Number</label>
                                    <input type="text" class="form-control wide-input" id="chassis-number" name="chassis-number" value="<%= request.getAttribute("chassisNumber") != null ? request.getAttribute("chassisNumber") : ""%>" placeholder="Example: 123ABC456DEF" required>
                                </div>
                                <div class="form-group">
                                    <label for="coverage">Coverage</label>
                                    <select class="form-control" id="coverage" name="coverage" required>
                                        <option>Select a coverage</option>
                                        <option value="comprehensive" <%= (request.getAttribute("coverage") != null && request.getAttribute("coverage").equals("comprehensive")) ? "selected" : ""%>>Comprehensive</option>
                                        <option value="third-party-motorcycle" <%= (request.getAttribute("coverage") != null && request.getAttribute("coverage").equals("third-party-motorcycle")) ? "selected" : ""%>>Third Party</option>
                                        <option value="third-party-fire-theft" <%= (request.getAttribute("coverage") != null && request.getAttribute("coverage").equals("third-party-fire-theft")) ? "selected" : ""%>>Third Party Fire and Theft</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="insured-value">Insured Value (in RM)</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">RM</span>
                                        </div>
                                        <input type="text" class="form-control wide-input" id="insured-value" name="insured-value" value="<%= request.getAttribute("insuredValue") != null ? request.getAttribute("insuredValue") : ""%>" placeholder="Enter Insured Value" min="0" step="0.01" required>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="vehicle-body">Vehicle Body</label>
                                    <select class="form-control" id="vehicle-body" name="vehicle-body" onchange="updateVehicleMakes()" required>
                                        <option>Select a body first</option>
                                        <option value="Sedan" <%= (request.getAttribute("vehicleBody") != null && request.getAttribute("vehicleBody").equals("Sedan")) ? "selected" : ""%>>Sedan</option>
                                        <option value="Hatchback" <%= (request.getAttribute("vehicleBody") != null && request.getAttribute("vehicleBody").equals("Hatchback")) ? "selected" : ""%>>Hatchback</option>
                                        <option value="SUV" <%= (request.getAttribute("vehicleBody") != null && request.getAttribute("vehicleBody").equals("SUV")) ? "selected" : ""%>>SUV (Sports Utility Vehicle)</option>
                                        <option value="MPV" <%= (request.getAttribute("vehicleBody") != null && request.getAttribute("vehicleBody").equals("MPV")) ? "selected" : ""%>>MPV (Multi-Purpose Vehicle)</option>
                                        <option value="Motorcycle" <%= (request.getAttribute("vehicleBody") != null && request.getAttribute("vehicleBody").equals("Motorcycle")) ? "selected" : ""%>>Motorcycle</option>
                                        <option value="Van" <%= (request.getAttribute("vehicleBody") != null && request.getAttribute("vehicleBody").equals("Van")) ? "selected" : ""%>>Van</option>
                                        <option value="Lorry" <%= (request.getAttribute("vehicleBody") != null && request.getAttribute("vehicleBody").equals("Lorry")) ? "selected" : ""%>>Lorry</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="vehicle-make">Vehicle Make</label>
                                    <select class="form-control wide-input" id="vehicle-make" name="vehicle-make" required>
                                        <option>Select a make first</option>
                                        <option value="<%= request.getAttribute("vehicleMake") != null ? request.getAttribute("vehicleMake") : ""%>" selected><%= request.getAttribute("vehicleMake") != null ? request.getAttribute("vehicleMake") : ""%></option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="vehicle-model">Vehicle Model</label>
                                    <select class="form-control wide-input" id="vehicle-model" name="vehicle-model" required>
                                        <option>Select a model first</option>
                                        <option value="<%= request.getAttribute("vehicleModel") != null ? request.getAttribute("vehicleModel") : ""%>" selected><%= request.getAttribute("vehicleModel") != null ? request.getAttribute("vehicleModel") : ""%></option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="engine-capacity">Engine Capacity (CC)</label>
                                    <input type="text" class="form-control wide-input" id="engine-capacity" name="engine-capacity" value="<%= request.getAttribute("engineCapacity") != null ? request.getAttribute("engineCapacity") : ""%>" placeholder="Example: 2000" maxlength="4" required>
                                </div>
                                <div class="form-group">
                                    <label for="manufacture-year">Year Of Manufactured</label>
                                    <input type="text" class="form-control wide-input" id="manufacture-year" name="manufacture-year" value="<%= request.getAttribute("manufactureYear") != null ? request.getAttribute("manufactureYear") : ""%>" placeholder="Example: 2022" required>
                                </div>
                                <div class="form-group">
                                    <label for="ncd">
                                        Current NCD
                                        <a href="https://www.mycarinfo.com.my/NCDCheck/Online" target="_blank">(Check NCD)</a>
                                    </label>
                                    <select class="form-control" id="ncd" name="ncd" required>
                                        <option>Select a NCD</option>
                                        <option value="0%" <%= (request.getAttribute("selectedNcd") != null && request.getAttribute("selectedNcd").equals("0%")) ? "selected" : ""%>>0%</option>
                                        <option value="30%" <%= (request.getAttribute("selectedNcd") != null && request.getAttribute("selectedNcd").equals("30%")) ? "selected" : ""%>>30%</option>
                                        <option value="38.33%" <%= (request.getAttribute("selectedNcd") != null && request.getAttribute("selectedNcd").equals("38.33%")) ? "selected" : ""%>>38.33%</option>
                                        <option value="45%" <%= (request.getAttribute("selectedNcd") != null && request.getAttribute("selectedNcd").equals("45%")) ? "selected" : ""%>>45%</option>
                                        <option value="55%" <%= (request.getAttribute("selectedNcd") != null && request.getAttribute("selectedNcd").equals("55%")) ? "selected" : ""%>>55%</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="policy-commencement-date">Policy Commencement Date</label>
                                    <input type="date" class="form-control wide-input" id="policy-commencement-date" name="policy-commencement-date" value="<%= request.getAttribute("policyCommencementDate") != null ? request.getAttribute("policyCommencementDate") : ""%>" required>
                                </div>
                                <div class="form-group">
                                    <label for="policy-duration">Policy Duration</label>
                                    <select class="form-control" id="policy-duration" name="policy-duration" required>
                                        <option>Select a policy duration</option>
                                        <option value="6" <%= (request.getAttribute("policyDuration") != null && Integer.parseInt(request.getAttribute("policyDuration").toString()) == 6) ? "selected" : ""%>>6 months</option>
                                        <option value="12" <%= (request.getAttribute("policyDuration") != null && Integer.parseInt(request.getAttribute("policyDuration").toString()) == 12) ? "selected" : ""%>>12 months</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="policy-expiry-date">Policy Expiry Date</label>
                                    <input type="text" class="form-control wide-input" id="policy-expiry-date" name="policy-expiry-date" value="<%= request.getAttribute("policyExpiryDate") != null ? request.getAttribute("policyExpiryDate") : ""%>" readonly>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <!-- Add-ons -->
                        <h2 style="text-align: center;">Add-ons</h2>
                        <div class="row" id="add-ons-section">
                            <div class="col-md-6">
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" id="windscreen-addon" name="windscreen-addon" value="true" <%= (request.getAttribute("windscreenCost") != null && Double.parseDouble(request.getAttribute("windscreenCost").toString()) > 0.0) ? "checked" : ""%>>
                                    <label class="form-check-label" for="windscreen-addon">
                                        Windscreen
                                        <a href="https://www.autoglass.com.my/insurance-pricelist.html" target="_blank">(Price List)</a>
                                    </label>
                                    <!-- Windscreen price input field initially hidden -->
                                    <input type="number" class="form-control wide-input" id="windscreen-price" name="windscreen-price" placeholder="Enter windscreen price (RM)" style="<%= (request.getAttribute("windscreenCost") != null && Double.parseDouble(request.getAttribute("windscreenCost").toString()) > 0.0) ? "" : "display: none;"%>" value="<%= request.getAttribute("windscreenCost") != null ? request.getAttribute("windscreenCost") : ""%>">
                                </div>
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" id="all-driver-addon" name="all-driver-addon" value="true" <%= (request.getAttribute("allDriverCost") != null && Double.parseDouble(request.getAttribute("allDriverCost").toString()) > 0.0) ? "checked" : ""%>>
                                    <label class="form-check-label" for="all-driver-addon">All Driver</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" id="special-perils-addon" name="special-perils-addon" value="true" <%= (request.getAttribute("specialPerilsCost") != null && Double.parseDouble(request.getAttribute("specialPerilsCost").toString()) > 0.0) ? "checked" : ""%>>
                                    <label class="form-check-label" for="special-perils-addon">Special Perils (Flood)</label>
                                </div>
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" id="legal-liability-addon" name="legal-liability-addon" value="true" <%= (request.getAttribute("legalLiabilityCost") != null && Double.parseDouble(request.getAttribute("legalLiabilityCost").toString()) > 0.0) ? "checked" : ""%>>
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
    // Function to update NCD options based on vehicle type
    function updateNcdOptions() {
        const vehicleType = document.getElementById('vehicle-type').value;
        const ncdSelect = document.getElementById('ncd');

        // Clear existing options
        ncdSelect.innerHTML = '';

        // Define NCD options based on vehicle type
        let ncdOptions = [];
        switch (vehicleType) {
            case 'Motorcycle':
                ncdOptions = ['0%', '15%', '20%', '25%'];
                break;
            case 'Lorry':
                ncdOptions = ['0%', '15%', '20%', '25%'];
                break;
            default:
                ncdOptions = ['0%', '30%', '38.33%', '45%', '55%'];
                break;
        }

        // Populate NCD options
        ncdOptions.forEach(option => {
            const optionElement = document.createElement('option');
            optionElement.value = option;
            optionElement.textContent = option;
            ncdSelect.appendChild(optionElement);
        });

        // Set the selected NCD value if it exists
        const selectedNcd = '<%= request.getAttribute("selectedNcd") != null ? request.getAttribute("selectedNcd") : ""%>';
        if (selectedNcd) {
            ncdSelect.value = selectedNcd;
        }
    }

    function updateCoverageOptions() {
        const vehicleType = document.getElementById('vehicle-type').value;
        const coverageSelect = document.getElementById('coverage');

        // Clear existing options
        coverageSelect.innerHTML = '';

        // Define coverage options based on vehicle type
        let coverageOptions = [];
        if (vehicleType === 'Motorcycle') {
            coverageOptions = [
                {value: 'comprehensive', text: 'Comprehensive'},
                {value: 'third-party-motorcycle', text: 'Third Party'}
            ];
        } else {
            coverageOptions = [
                {value: 'comprehensive', text: 'Comprehensive'},
                {value: 'third-party-fire-theft', text: 'Third Party Fire and Theft'}
            ];
        }

        // Populate coverage options
        coverageOptions.forEach(option => {
            const optionElement = document.createElement('option');
            optionElement.value = option.value;
            optionElement.textContent = option.text;
            coverageSelect.appendChild(optionElement);
        });

        // Set the selected coverage value if it exists
        const selectedCoverage = '<%= request.getAttribute("coverage") != null ? request.getAttribute("coverage") : ""%>';
        if (selectedCoverage) {
            coverageSelect.value = selectedCoverage;
        }
    }

    window.onload = function () {
        updateNcdOptions();
        updateCoverageOptions();
    };

    document.getElementById('vehicle-type').addEventListener('change', function () {
        updateNcdOptions();
        updateCoverageOptions();
    });
</script>
<script>
    function submitForm() {
        var form = document.getElementById("quotation-form");

        // Set the action to saveQuotation.jsp
        form.action = "saveQuotation.jsp";

        // Submit the form
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

    // Function to toggle add-ons state based on selected coverage and vehicle type
    function toggleAddonsState() {
        var coverage = document.getElementById("coverage").value;
        var urlParams = new URLSearchParams(window.location.search);
        var vehicleType = urlParams.get('vehicle');
        var addonsCheckboxes = document.querySelectorAll("#add-ons-section input[type='checkbox']");
        var addonsSelects = document.querySelectorAll("#add-ons-section select");

        // Check if the selected vehicle type is Motorcycle
        if (vehicleType === "Motorcycle") {
            // Disable all add-ons checkboxes and select elements
            addonsCheckboxes.forEach(function (checkbox) {
                checkbox.disabled = true;
            });
            addonsSelects.forEach(function (select) {
                select.disabled = true;
            });
        } else {
            // Check if the selected coverage is "Comprehensive"
            if (coverage === "comprehensive") {
                // Enable all add-ons checkboxes and select elements
                addonsCheckboxes.forEach(function (checkbox) {
                    checkbox.disabled = false;
                });
                addonsSelects.forEach(function (select) {
                    select.disabled = false;
                });
            } else {
                // Disable all add-ons checkboxes and select elements
                addonsCheckboxes.forEach(function (checkbox) {
                    checkbox.disabled = true;
                });
                addonsSelects.forEach(function (select) {
                    select.disabled = true;
                });
            }
        }
    }

// Add event listener to the coverage select element
    document.getElementById("coverage").addEventListener("change", toggleAddonsState);

// Call the function initially to set the initial state based on the selected coverage and vehicle type
    toggleAddonsState();

    function toggleCoverageOptions() {
        var urlParams = new URLSearchParams(window.location.search);
        var vehicleType = urlParams.get('vehicle');
        var coverageSelect = document.getElementById("coverage");
        var thirdPartyOption = coverageSelect.querySelector("option[value='third-party-motorcycle']");
        var tpftOption = coverageSelect.querySelector("option[value='third-party-fire-theft']");

        // Check if the selected vehicle type is Motorcycle
        if (vehicleType === "Motorcycle") {
            // Hide the Third Party Fire and Theft option
            tpftOption.style.display = "none";
            // Show the Third Party option
            thirdPartyOption.style.display = "block";
        } else {
            // Show the Third Party Fire and Theft option
            tpftOption.style.display = "block";
            // Hide the Third Party option
            thirdPartyOption.style.display = "none";
        }
    }

// Call the function initially to set the initial state based on the selected vehicle type
    toggleCoverageOptions();

</script>
<script>
    var originalVehicleMakes = [
        "Perodua", "Proton", "Honda (Car)", "Toyota (Car)", "Nissan (Car)", "Mini Cooper", "Mitsubishi",
        "Peugeot", "Volkswagen", "Subaru", "Ssangyong", "Kia", "Isuzu (Car)", "Suzuki (Car)",
        "Mazda", "McLaren", "Chevrolet", "Hyundai", "BMW (Car)", "Chery", "Volvo", "Ford",
        "Mercedes-Benz", "Lexus", "Rolls Royce", "Bentley", "Porsche",
        "Jaguar", "Landrover Range Rover", "Infiniti", "Audi", "Citroen"
    ];

    function updateVehicleMakes() {
        var vehicleBody = document.getElementById("vehicle-body").value;
        var vehicleMakeSelect = document.getElementById("vehicle-make");
        vehicleMakeSelect.innerHTML = ""; // Clear existing options

        if (vehicleBody === "Motorcycle") {
            addOptions(vehicleMakeSelect, [
                "Yamaha", "Honda (Motor)", "Kawasaki", "Sym", "Harley-Davidson",
                "Suzuki (Motor)", "Benelli", "Ducati", "BMW (Motor)", "Vespa", "Aprilia", "Daiichi", "Modenas", "Piaggio",
                "Moto Guzzi", "GPX", "Royal Enfield", "Brixton"
            ]);
        } else if (vehicleBody === "Van") {
            addOptions(vehicleMakeSelect, ["Toyota (Van)", "Nissan (Van)", "Daihatsu", "Foton (Van)"]);
        } else if (vehicleBody === "Lorry") {
            addOptions(vehicleMakeSelect, ["Hino", "Fuso", "Isuzu (Lorry)", "UD Trucks", "Volvo", "CAMC", "Foton (Lorry)", "JMC"]);
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
