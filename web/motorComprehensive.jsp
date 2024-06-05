<%@page import="com.dao.DBConnection"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Motorcycle Insurance Comprehensive Quotation</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="CSS/quotation.css">
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css">
        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!-- Google Material Icons -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>
    <body>
        <%
            String userID = (String) session.getAttribute("userID");
            String roles = (String) session.getAttribute("roles");
            boolean hasImage = false;
            if (userID != null) {
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");

                    // Check if user has uploaded an image
                    PreparedStatement psImage = con.prepareStatement("SELECT profileIMG FROM customer WHERE userID = ?");
                    psImage.setString(1, userID);
                    ResultSet rsImage = psImage.executeQuery();
                    if (rsImage.next()) {
                        hasImage = rsImage.getBlob("profileIMG") != null;
                    }
                } catch (SQLException e) {
                    // Handle SQLException (print or log the error)
                    e.printStackTrace();
                    out.println("An error occurred while fetching customer data. Please try again later.");
                }
            } else {
                // Handle the case where userID is not found in the session
                out.println("UserID not found in the session.");
            }

            List<String> notifications = new ArrayList<>();
            if (userID != null) {
                try (Connection conn = DBConnection.getConnection();
                        PreparedStatement ps = conn.prepareStatement(
                                "SELECT message FROM Notifications WHERE userID = ? AND isRead = FALSE ORDER BY created_at DESC")) {
                    ps.setString(1, userID);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            notifications.add(rs.getString("message"));
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
        <%
//            String userID = (String) session.getAttribute("userID");
            Integer quotationId = (Integer) request.getAttribute("quotationId");
            String ownerName = request.getParameter("owner-name");
            String ownerId = request.getParameter("owner-id");
            String dob = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String maritalStatus = request.getParameter("marital-status");
            String location = request.getParameter("location");
            String vehicleType = request.getParameter("vehicle-type");
            String localImport = request.getParameter("local-import");
            String registrationNumber = request.getParameter("registration-number");
            String engineNumber = request.getParameter("engine-number");
            String chassisNumber = request.getParameter("chassis-number");
            String coverage = request.getParameter("coverage");

            String insuredValueStr = request.getParameter("insured-value");
            double insuredValue = 0.0; // Default value
            if (insuredValueStr != null && !insuredValueStr.isEmpty()) {
                try {
                    insuredValue = Double.parseDouble(insuredValueStr);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

            String vehicleBody = request.getParameter("vehicle-body");
            String vehicleMake = request.getParameter("vehicle-make");
            String vehicleModel = request.getParameter("vehicle-model");
            String manufactureYear = request.getParameter("manufacture-year");
            String policyCommencementDate = request.getParameter("policy-commencement-date");
            String policyDuration = request.getParameter("policy-duration");
            String policyExpiryDate = request.getParameter("policy-expiry-date");

            String selectedNCD = request.getParameter("ncd");
            // Convert the selected NCD value to a double for calculations
            double ncdPercentage = 0.0;
            if (selectedNCD != null && !selectedNCD.isEmpty()) {
                // Convert percentage to decimal
                ncdPercentage = Double.parseDouble(selectedNCD.replaceAll("[^0-9.]", "")) / 100;
            }

            String engineCapacityStr = request.getParameter("engine-capacity");
            int engineCapacity = 0; // Default value
            if (engineCapacityStr != null && !engineCapacityStr.isEmpty()) {
                engineCapacity = Integer.parseInt(engineCapacityStr.replaceAll("[^0-9]", ""));
            }

            double[] peninsulaComprehensiveBaseValues = {
                100.00, 120.00, 140.00, 160.00, 180.00, 200.00, 220.00, 240.00
            };

            double[] eastMalaysiaComprehensiveBaseValues = {
                80.00, 100.00, 120.00, 140.00, 160.00, 180.00, 200.00, 220.00
            };

            double baseValue = 0.0;

            if ("peninsular".equals(location)) {
                if (engineCapacity <= 50) {
                    baseValue = peninsulaComprehensiveBaseValues[0];
                } else if (engineCapacity <= 100) {
                    baseValue = peninsulaComprehensiveBaseValues[1];
                } else if (engineCapacity <= 125) {
                    baseValue = peninsulaComprehensiveBaseValues[2];
                } else if (engineCapacity <= 225) {
                    baseValue = peninsulaComprehensiveBaseValues[3];
                } else if (engineCapacity <= 350) {
                    baseValue = peninsulaComprehensiveBaseValues[4];
                } else if (engineCapacity <= 500) {
                    baseValue = peninsulaComprehensiveBaseValues[5];
                } else {
                    baseValue = peninsulaComprehensiveBaseValues[6];
                }
            } else if ("east".equals(location)) {
                if (engineCapacity <= 50) {
                    baseValue = eastMalaysiaComprehensiveBaseValues[0];
                } else if (engineCapacity <= 100) {
                    baseValue = eastMalaysiaComprehensiveBaseValues[1];
                } else if (engineCapacity <= 125) {
                    baseValue = eastMalaysiaComprehensiveBaseValues[2];
                } else if (engineCapacity <= 225) {
                    baseValue = eastMalaysiaComprehensiveBaseValues[3];
                } else if (engineCapacity <= 350) {
                    baseValue = eastMalaysiaComprehensiveBaseValues[4];
                } else if (engineCapacity <= 500) {
                    baseValue = eastMalaysiaComprehensiveBaseValues[5];
                } else {
                    baseValue = eastMalaysiaComprehensiveBaseValues[6];
                }
            }

            double premiumRate = 0.026; // Default premium rate (2.6%)
            if ("peninsular".equals(location)) {
                premiumRate = 0.026; // 2.6% for Peninsular Malaysia
            } else if ("east".equals(location)) {
                premiumRate = 0.0203; // 2.03% for East Malaysia
            }

            // Calculate gross premium
            double grossPremium = baseValue + premiumRate * (insuredValue - 1000);

            // Calculate NCD
            double ncd = ncdPercentage * grossPremium;

            // Calculate total premium after deducting NCD and adding add-ons
            double totalPremium = grossPremium - ncd;

            // Format all decimal values to two decimal points
            DecimalFormat df = new DecimalFormat("#.##");
            String formattedInsuredValue = df.format(insuredValue);
            String formattedGrossPremium = df.format(grossPremium);
            String formattedNCD = df.format(ncd);
            String formattedTotalPremium = df.format(totalPremium);
        %>
        <div class="wrapper">
            <div class="body-overlay"></div>
            <!-- Sidebar Design -->
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
                            <li class=""><a href="customerQuo.jsp"><i class="material-icons">list</i> Quotation Form</a></li>
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
            <!-- Sidebar Design End -->
            <!-- Page Content Start -->
            <div id="content">
                <!-- Top Navbar Start -->
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
                                                <% if (notifications.size() > 0) {%>
                                                <a class="nav-link" href="#" data-toggle="dropdown">
                                                    <span class="material-icons">notifications</span>
                                                    <span class="notification"><%= notifications.size()%></span>
                                                </a>
                                                <ul class="dropdown-menu">
                                                    <% for (String notification : notifications) {%>
                                                    <li><a href="#"><%= notification%></a></li>
                                                        <% } %>
                                                    <li class="dropdown-divider"></li>
                                                    <li>
                                                        <form method="post" action="ClearNotificationsServlet">
                                                            <button type="submit" class="btn btn-link" style="text-decoration: none;">Clear Notifications</button>
                                                        </form>
                                                    </li>
                                                </ul>
                                                <% } else { %>
                                                <a class="nav-link" href="#">
                                                    <span class="material-icons">notifications</span>
                                                </a>
                                                <ul class="dropdown-menu">
                                                    <li><a href="#">No new notifications.</a></li>
                                                </ul>
                                                <% }%>
                                            </li>
                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="customerProfile.jsp">
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
                            <h4 class="page-title">Quotation</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Customer</a></li>
                            </ol>
                        </div>
                    </div>
                </div>
                <!-- Top Navbar End -->
                <!-- Main content start -->
                <div class="main-content">
                    <div class="container-fluid">
                        <div class="container mt-5">
                            <div class="card mb-4">
                                <div class="card-header text-center">
                                    <h1 class="mb-4">Insurance Quotation</h1>
                                </div>
                                <div class="card-body">
                                    <input type="hidden" name="userID" value="<%= userID%>">
                                    <input type="hidden" name="quotationId" value="<%= quotationId%>">

                                    <div class="mb-4">
                                        <h2 class="border-bottom pb-2">Personal Information</h2>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p><strong>Owner Name:</strong> <%= ownerName%></p>
                                                <p><strong>Owner ID:</strong> <%= ownerId%></p>
                                                <p><strong>Date of Birth:</strong> <%= dob%></p>
                                            </div>
                                            <div class="col-md-6">
                                                <p><strong>Gender:</strong> <%= gender%></p>
                                                <p><strong>Marital Status:</strong> <%= maritalStatus%></p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <h2 class="border-bottom pb-2">Vehicle Information</h2>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p><strong>Location:</strong> <%= location%></p>
                                                <p><strong>Vehicle Type:</strong> <%= vehicleType%></p>
                                                <p><strong>Local/Import:</strong> <%= localImport%></p>
                                                <p><strong>Registration Number:</strong> <%= registrationNumber%></p>
                                            </div>
                                            <div class="col-md-6">
                                                <p><strong>Engine Number:</strong> <%= engineNumber%></p>
                                                <p><strong>Chassis Number:</strong> <%= chassisNumber%></p>
                                                <p><strong>Coverage:</strong> <%= coverage%></p>
                                                <p><strong>Insured Value:</strong> RM <%= formattedInsuredValue%></p>
                                            </div>
                                        </div>
                                        <div class="row mt-2">
                                            <div class="col-md-6">
                                                <p><strong>Engine Capacity:</strong> <%= engineCapacity%> cc</p>
                                                <p><strong>Vehicle Body:</strong> <%= vehicleBody%></p>
                                            </div>
                                            <div class="col-md-6">
                                                <p><strong>Vehicle Make:</strong> <%= vehicleMake%></p>
                                                <p><strong>Vehicle Model:</strong> <%= vehicleModel%></p>
                                                <p><strong>Manufacture Year:</strong> <%= manufactureYear%></p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <h2 class="border-bottom pb-2">Policy Information</h2>
                                        <p><strong>Policy Commencement Date:</strong> <%= policyCommencementDate%></p>
                                        <p><strong>Policy Duration:</strong> <%= policyDuration%> years</p>
                                        <p><strong>Policy Expiry Date:</strong> <%= policyExpiryDate%></p>
                                    </div>

                                    <div class="mb-4">
                                        <h2 class="border-bottom pb-2">Gross Premium Calculation</h2>
                                        <p><strong>Gross Premium:</strong> RM <%= formattedGrossPremium%></p>
                                    </div>

                                    <div class="mb-4">
                                        <h2 class="border-bottom pb-2">Additional Calculations</h2>
                                        <p><strong>NCD:</strong> RM <%= formattedNCD%></p>
                                        <p><strong>Total Premium after NCD:</strong> RM <%= formattedTotalPremium%></p>
                                    </div>
                                </div>
                            </div>
                            <%
                                // Define percentages based on vehicle make for each company
                                Map<String, Map<String, Double>> companyVehicleMakePercentages = new HashMap<>();

                                Map<String, Double> takafulIkhlasPercentages = new HashMap<>();
                                takafulIkhlasPercentages.put("Yamaha", 0.025);
                                takafulIkhlasPercentages.put("Honda (Motor)", 0.023);
                                takafulIkhlasPercentages.put("Kawasaki", 0.027);
                                takafulIkhlasPercentages.put("Sym", 0.026);
                                takafulIkhlasPercentages.put("Harley-Davidson", 0.030);
                                takafulIkhlasPercentages.put("Suzuki (Motor)", 0.022);
                                takafulIkhlasPercentages.put("Benelli", 0.020);
                                takafulIkhlasPercentages.put("Ducati", 0.028);
                                takafulIkhlasPercentages.put("BMW (Motor)", 0.019);
                                takafulIkhlasPercentages.put("Vespa", 0.031);
                                takafulIkhlasPercentages.put("Aprilia", 0.032);
                                takafulIkhlasPercentages.put("Daiichi", 0.018);
                                takafulIkhlasPercentages.put("Modenas", 0.017);
                                takafulIkhlasPercentages.put("Piaggio", 0.019);
                                takafulIkhlasPercentages.put("Moto Guzzi", 0.033);
                                takafulIkhlasPercentages.put("GPX", 0.016);
                                takafulIkhlasPercentages.put("Royal Enfield", 0.015);
                                takafulIkhlasPercentages.put("Brixton", 0.034);
                                companyVehicleMakePercentages.put("Takaful Ikhlas", takafulIkhlasPercentages);

                                Map<String, Double> takafulMalaysiaPercentages = new HashMap<>();
                                takafulMalaysiaPercentages.put("Yamaha", 0.015);
                                takafulMalaysiaPercentages.put("Honda (Motor)", 0.014);
                                takafulMalaysiaPercentages.put("Kawasaki", 0.013);
                                takafulMalaysiaPercentages.put("Sym", 0.012);
                                takafulMalaysiaPercentages.put("Harley-Davidson", 0.011);
                                takafulMalaysiaPercentages.put("Suzuki (Motor)", 0.010);
                                takafulMalaysiaPercentages.put("Benelli", 0.015);
                                takafulMalaysiaPercentages.put("Ducati", 0.013);
                                takafulMalaysiaPercentages.put("BMW (Motor)", 0.012);
                                takafulMalaysiaPercentages.put("Vespa", 0.011);
                                takafulMalaysiaPercentages.put("Aprilia", 0.010);
                                takafulMalaysiaPercentages.put("Daiichi", 0.015);
                                takafulMalaysiaPercentages.put("Modenas", 0.014);
                                takafulMalaysiaPercentages.put("Piaggio", 0.013);
                                takafulMalaysiaPercentages.put("Moto Guzzi", 0.012);
                                takafulMalaysiaPercentages.put("GPX", 0.011);
                                takafulMalaysiaPercentages.put("Royal Enfield", 0.010);
                                takafulMalaysiaPercentages.put("Brixton", 0.009);
                                companyVehicleMakePercentages.put("Takaful Malaysia", takafulMalaysiaPercentages);

                                Map<String, Double> etiqaPercentages = new HashMap<>();
                                etiqaPercentages.put("Yamaha", 0.025);
                                etiqaPercentages.put("Honda (Motor)", 0.026);
                                etiqaPercentages.put("Kawasaki", 0.027);
                                etiqaPercentages.put("Sym", 0.018);
                                etiqaPercentages.put("Harley-Davidson", 0.019);
                                etiqaPercentages.put("Suzuki (Motor)", 0.020);
                                etiqaPercentages.put("Benelli", 0.021);
                                etiqaPercentages.put("Ducati", 0.022);
                                etiqaPercentages.put("BMW (Motor)", 0.023);
                                etiqaPercentages.put("Vespa", 0.024);
                                etiqaPercentages.put("Aprilia", 0.015);
                                etiqaPercentages.put("Daiichi", 0.016);
                                etiqaPercentages.put("Modenas", 0.017);
                                etiqaPercentages.put("Piaggio", 0.018);
                                etiqaPercentages.put("Moto Guzzi", 0.019);
                                etiqaPercentages.put("GPX", 0.020);
                                etiqaPercentages.put("Royal Enfield", 0.021);
                                etiqaPercentages.put("Brixton", 0.022);
                                companyVehicleMakePercentages.put("Etiqa", etiqaPercentages);

                                Map<String, Double> allianzPercentages = new HashMap<>();
                                allianzPercentages.put("Yamaha", 0.03);
                                allianzPercentages.put("Honda (Motor)", 0.031);
                                allianzPercentages.put("Kawasaki", 0.032);
                                allianzPercentages.put("Sym", 0.023);
                                allianzPercentages.put("Harley-Davidson", 0.024);
                                allianzPercentages.put("Suzuki (Motor)", 0.025);
                                allianzPercentages.put("Benelli", 0.026);
                                allianzPercentages.put("Ducati", 0.027);
                                allianzPercentages.put("BMW (Motor)", 0.028);
                                allianzPercentages.put("Vespa", 0.029);
                                allianzPercentages.put("Aprilia", 0.02);
                                allianzPercentages.put("Daiichi", 0.021);
                                allianzPercentages.put("Modenas", 0.022);
                                allianzPercentages.put("Piaggio", 0.023);
                                allianzPercentages.put("Moto Guzzi", 0.024);
                                allianzPercentages.put("GPX", 0.025);
                                allianzPercentages.put("Royal Enfield", 0.026);
                                allianzPercentages.put("Brixton", 0.027);
                                companyVehicleMakePercentages.put("Allianz", allianzPercentages);

                                Map<String, Double> pacificPercentages = new HashMap<>();
                                pacificPercentages.put("Yamaha", 0.015);
                                pacificPercentages.put("Honda (Motor)", 0.016);
                                pacificPercentages.put("Kawasaki", 0.017);
                                pacificPercentages.put("Sym", 0.018);
                                pacificPercentages.put("Harley-Davidson", 0.019);
                                pacificPercentages.put("Suzuki (Motor)", 0.020);
                                pacificPercentages.put("Benelli", 0.021);
                                pacificPercentages.put("Ducati", 0.022);
                                pacificPercentages.put("BMW (Motor)", 0.023);
                                pacificPercentages.put("Vespa", 0.024);
                                pacificPercentages.put("Aprilia", 0.025);
                                pacificPercentages.put("Daiichi", 0.026);
                                pacificPercentages.put("Modenas", 0.027);
                                pacificPercentages.put("Piaggio", 0.028);
                                pacificPercentages.put("Moto Guzzi", 0.029);
                                pacificPercentages.put("GPX", 0.030);
                                pacificPercentages.put("Royal Enfield", 0.031);
                                pacificPercentages.put("Brixton", 0.032);
                                companyVehicleMakePercentages.put("Pacific", pacificPercentages);

                                Map<String, Double> libertyPercentages = new HashMap<>();
                                libertyPercentages.put("Yamaha", 0.013);
                                libertyPercentages.put("Honda (Motor)", 0.014);
                                libertyPercentages.put("Kawasaki", 0.015);
                                libertyPercentages.put("Sym", 0.016);
                                libertyPercentages.put("Harley-Davidson", 0.017);
                                libertyPercentages.put("Suzuki (Motor)", 0.018);
                                libertyPercentages.put("Benelli", 0.019);
                                libertyPercentages.put("Ducati", 0.02);
                                libertyPercentages.put("BMW (Motor)", 0.021);
                                libertyPercentages.put("Vespa", 0.022);
                                libertyPercentages.put("Aprilia", 0.023);
                                libertyPercentages.put("Daiichi", 0.024);
                                libertyPercentages.put("Modenas", 0.025);
                                libertyPercentages.put("Piaggio", 0.026);
                                libertyPercentages.put("Moto Guzzi", 0.027);
                                libertyPercentages.put("GPX", 0.028);
                                libertyPercentages.put("Royal Enfield", 0.029);
                                libertyPercentages.put("Brixton", 0.03);
                                companyVehicleMakePercentages.put("Liberty", libertyPercentages);

                                Map<String, Double> zurichPercentages = new HashMap<>();
                                zurichPercentages.put("Yamaha", 0.019);
                                zurichPercentages.put("Honda (Motor)", 0.020);
                                zurichPercentages.put("Kawasaki", 0.021);
                                zurichPercentages.put("Sym", 0.022);
                                zurichPercentages.put("Harley-Davidson", 0.023);
                                zurichPercentages.put("Suzuki (Motor)", 0.024);
                                zurichPercentages.put("Benelli", 0.025);
                                zurichPercentages.put("Ducati", 0.026);
                                zurichPercentages.put("BMW (Motor)", 0.027);
                                zurichPercentages.put("Vespa", 0.028);
                                zurichPercentages.put("Aprilia", 0.029);
                                zurichPercentages.put("Daiichi", 0.030);
                                zurichPercentages.put("Modenas", 0.031);
                                zurichPercentages.put("Piaggio", 0.032);
                                zurichPercentages.put("Moto Guzzi", 0.033);
                                zurichPercentages.put("GPX", 0.034);
                                zurichPercentages.put("Royal Enfield", 0.035);
                                zurichPercentages.put("Brixton", 0.036);
                                companyVehicleMakePercentages.put("Zurich", zurichPercentages);

                                Map<String, Double> generalyPercentages = new HashMap<>();
                                generalyPercentages.put("Yamaha", 0.015);
                                generalyPercentages.put("Honda (Motor)", 0.016);
                                generalyPercentages.put("Kawasaki", 0.017);
                                generalyPercentages.put("Sym", 0.018);
                                generalyPercentages.put("Harley-Davidson", 0.019);
                                generalyPercentages.put("Suzuki (Motor)", 0.020);
                                generalyPercentages.put("Benelli", 0.021);
                                generalyPercentages.put("Ducati", 0.022);
                                generalyPercentages.put("BMW (Motor)", 0.023);
                                generalyPercentages.put("Vespa", 0.024);
                                generalyPercentages.put("Aprilia", 0.025);
                                generalyPercentages.put("Daiichi", 0.026);
                                generalyPercentages.put("Modenas", 0.027);
                                generalyPercentages.put("Piaggio", 0.028);
                                generalyPercentages.put("Moto Guzzi", 0.029);
                                generalyPercentages.put("GPX", 0.030);
                                generalyPercentages.put("Royal Enfield", 0.031);
                                generalyPercentages.put("Brixton", 0.032);
                                companyVehicleMakePercentages.put("Generaly", generalyPercentages);
                            %>
                            <div class="row">
                                <%
                                    // Iterate over each company in companyVehicleMakePercentages
                                    for (Map.Entry<String, Map<String, Double>> entry : companyVehicleMakePercentages.entrySet()) {
                                        String companyName = entry.getKey();
                                        Map<String, Double> percentagesForCompany = entry.getValue();

                                        // Find the percentage for the selected vehicle make for this company
                                        Double companyPercentage = percentagesForCompany.get(vehicleMake);

                                        // If the percentage is found for the selected make, calculate the insurance price for this company
                                        if (companyPercentage != null) {
                                            double companyTotalPremium = totalPremium * (1 + companyPercentage);

                                            // Apply SST (SST is 10%)
                                            double sst = 0.10 * companyTotalPremium;

                                            // Add stamp duty (stamp duty is RM10)
                                            double stampDuty = 10.0;

                                            // Calculate final total premium after applying SST and adding stamp duty
                                            double finalTotalPremium = companyTotalPremium + sst + stampDuty;

                                            // Format the insurance price
                                            String formattedCompanyTotalPremium = df.format(companyTotalPremium);
                                            String formattedSST = df.format(sst);
                                            String formattedStampDuty = df.format(stampDuty);
                                            String formattedFinalTotalPremium = df.format(finalTotalPremium);
                                %>
                                <div class="col-md-6 mb-4">
                                    <div class="card">
                                        <div class="card-header text-center">
                                            <%= companyName%>
                                        </div>
                                        <div class="card-body">
                                            <p>Insurance Price: RM <%= formattedCompanyTotalPremium%></p>
                                            <p>SST (10%): RM <%= formattedSST%></p>
                                            <p>Stamp Duty (RM10): RM <%= formattedStampDuty%></p>
                                            <p>Final Total Premium: RM <%= formattedFinalTotalPremium%></p>
                                        </div>
                                        <div class="card-footer">
                                            <form id="purchaseForm_<%= companyName%>" method="post" action="qrCode.jsp" class="d-inline">
                                                <input type="hidden" name="finalTotalPremium" value="<%= formattedFinalTotalPremium%>">
                                                <input type="hidden" name="userID" value="<%= userID%>">
                                                <input type="hidden" name="quotationId" value="<%= quotationId%>">
                                                <input type="hidden" name="registrationNumber" value="<%= registrationNumber%>">
                                                <input type="hidden" name="policyCommencementDate" value="<%= policyCommencementDate%>">
                                                <input type="hidden" name="policyDuration" value="<%= policyDuration%>">
                                                <input type="hidden" name="policyExpiryDate" value="<%= policyExpiryDate%>">
                                                <input type="hidden" name="engineCapacity" value="<%= engineCapacity%>">
                                                <input type="hidden" name="companyName" value="<%= companyName%>">
                                                <button type="submit" name="purchaseOption" value="QR" class="btn btn-primary">QR Code</button>
                                            </form>
                                            <form id="purchaseForm_<%= companyName%>" method="post" action="cod.jsp" class="d-inline">
                                                <input type="hidden" name="finalTotalPremium" value="<%= formattedFinalTotalPremium%>">
                                                <input type="hidden" name="userID" value="<%= userID%>">
                                                <input type="hidden" name="quotationId" value="<%= quotationId%>">
                                                <input type="hidden" name="registrationNumber" value="<%= registrationNumber%>">
                                                <input type="hidden" name="policyCommencementDate" value="<%= policyCommencementDate%>">
                                                <input type="hidden" name="policyDuration" value="<%= policyDuration%>">
                                                <input type="hidden" name="policyExpiryDate" value="<%= policyExpiryDate%>">
                                                <input type="hidden" name="engineCapacity" value="<%= engineCapacity%>">
                                                <input type="hidden" name="companyName" value="<%= companyName%>">
                                                <button type="submit" name="purchaseOption" value="COD" class="btn btn-secondary">Cash on Delivery (COD)</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <%
                                        } else {
                                            // If percentage not found for the selected make, display a message
                                            out.println("<div class='col-md-6 mb-4'><div class='card'><div class='card-header'>" + companyName + "</div><div class='card-body'><p>No insurance price available for selected vehicle make.</p></div></div></div>");
                                        }
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Main content end -->
                <!-- Footer Design -->
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
        <!-- DataTables JavaScript -->
        <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap4.min.js"></script>
        <script>
            $(document).ready(function () {
                $(".xp-menubar").on('click', function () {
                    $("#sidebar").toggleClass('active');
                    $("#content").toggleClass('active');
                });

                $('.xp-menubar,.body-overlay').on('click', function () {
                    $("#sidebar,.body-overlay").toggleClass('show-nav');
                });

            <% String message = request.getParameter("message");
                if (message != null && !message.isEmpty()) {%>
                alert('<%= message%>');
            <% }%>
            });
        </script>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>