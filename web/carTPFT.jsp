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
        <title>Car Insurance Third Party Fire And Theft Quotation</title>
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

            double[] peninsulaBaseValues = {
                120.60, 135.00, 151.20, 167.40, 181.80, 196.20, 212.40, 220.60
            };

            double[] eastMalaysiaBaseValues = {
                67.50, 75.60, 85.20, 93.60, 101.70, 110.10, 118.20, 120.30
            };

            double baseValue = 0.0;

            if ("peninsular".equals(location)) {
                if (engineCapacity <= 1400) {
                    baseValue = peninsulaBaseValues[0];
                } else if (engineCapacity <= 1650) {
                    baseValue = peninsulaBaseValues[1];
                } else if (engineCapacity <= 2200) {
                    baseValue = peninsulaBaseValues[2];
                } else if (engineCapacity <= 3050) {
                    baseValue = peninsulaBaseValues[3];
                } else if (engineCapacity <= 4100) {
                    baseValue = peninsulaBaseValues[4];
                } else if (engineCapacity <= 4250) {
                    baseValue = peninsulaBaseValues[5];
                } else if (engineCapacity <= 4400) {
                    baseValue = peninsulaBaseValues[6];
                } else {
                    baseValue = peninsulaBaseValues[7];
                }
            } else if ("east".equals(location)) {
                if (engineCapacity <= 1400) {
                    baseValue = eastMalaysiaBaseValues[0];
                } else if (engineCapacity <= 1650) {
                    baseValue = eastMalaysiaBaseValues[1];
                } else if (engineCapacity <= 2200) {
                    baseValue = eastMalaysiaBaseValues[2];
                } else if (engineCapacity <= 3050) {
                    baseValue = eastMalaysiaBaseValues[3];
                } else if (engineCapacity <= 4100) {
                    baseValue = eastMalaysiaBaseValues[4];
                } else if (engineCapacity <= 4250) {
                    baseValue = eastMalaysiaBaseValues[5];
                } else if (engineCapacity <= 4400) {
                    baseValue = eastMalaysiaBaseValues[6];
                } else {
                    baseValue = eastMalaysiaBaseValues[7];
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

            // Calculate total premium after deducting NCD
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
                                takafulIkhlasPercentages.put("Perodua", 0.04);
                                takafulIkhlasPercentages.put("Proton", 0.038);
                                takafulIkhlasPercentages.put("Honda (Car)", 0.03);
                                takafulIkhlasPercentages.put("Toyota (Car)", 0.015);
                                takafulIkhlasPercentages.put("Nissan (Car)", 0.018);
                                takafulIkhlasPercentages.put("Mini Cooper", 0.021);
                                takafulIkhlasPercentages.put("Mitsubishi", 0.022);
                                takafulIkhlasPercentages.put("Peugoet", 0.023);
                                takafulIkhlasPercentages.put("Volkswagen", 0.024);
                                takafulIkhlasPercentages.put("Subaru", 0.025);
                                takafulIkhlasPercentages.put("Ssangyong", 0.026);
                                takafulIkhlasPercentages.put("Kia", 0.027);
                                takafulIkhlasPercentages.put("Naza", 0.044);
                                takafulIkhlasPercentages.put("Isuzu (Car)", 0.029);
                                takafulIkhlasPercentages.put("Suzuki (Car)", 0.03);
                                takafulIkhlasPercentages.put("Mazda", 0.031);
                                takafulIkhlasPercentages.put("McLaren", 0.032);
                                takafulIkhlasPercentages.put("Chevrolet", 0.033);
                                takafulIkhlasPercentages.put("Hyundai", 0.034);
                                takafulIkhlasPercentages.put("BMW (Car)", 0.035);
                                takafulIkhlasPercentages.put("Chery", 0.036);
                                takafulIkhlasPercentages.put("Volvo", 0.037);
                                takafulIkhlasPercentages.put("Ford", 0.025);
                                takafulIkhlasPercentages.put("Mercedes Benz", 0.039);
                                takafulIkhlasPercentages.put("Lexus", 0.02);
                                takafulIkhlasPercentages.put("Rolls Royce", 0.041);
                                takafulIkhlasPercentages.put("Bentley", 0.042);
                                takafulIkhlasPercentages.put("Porsche", 0.043);
                                takafulIkhlasPercentages.put("Jaguar", 0.028);
                                takafulIkhlasPercentages.put("Landrover Range Rover", 0.045);
                                takafulIkhlasPercentages.put("Infiniti", 0.04);
                                takafulIkhlasPercentages.put("Audi", 0.038);
                                takafulIkhlasPercentages.put("Citroen", 0.03);
                                companyVehicleMakePercentages.put("Takaful Ikhlas", takafulIkhlasPercentages);

                                Map<String, Double> takafulMalaysiaPercentages = new HashMap<>();
                                takafulMalaysiaPercentages.put("Perodua", 0.042);
                                takafulMalaysiaPercentages.put("Proton", 0.043);
                                takafulMalaysiaPercentages.put("Honda (Car)", 0.044);
                                takafulMalaysiaPercentages.put("Toyota (Car)", 0.036);
                                takafulMalaysiaPercentages.put("Nissan (Car)", 0.037);
                                takafulMalaysiaPercentages.put("Mini Cooper", 0.038);
                                takafulMalaysiaPercentages.put("Mitsubishi", 0.039);
                                takafulMalaysiaPercentages.put("Peugoet", 0.04);
                                takafulMalaysiaPercentages.put("Volkswagen", 0.041);
                                takafulMalaysiaPercentages.put("Subaru", 0.042);
                                takafulMalaysiaPercentages.put("Ssangyong", 0.034);
                                takafulMalaysiaPercentages.put("Kia", 0.035);
                                takafulMalaysiaPercentages.put("Naza", 0.036);
                                takafulMalaysiaPercentages.put("Isuzu (Car)", 0.037);
                                takafulMalaysiaPercentages.put("Suzuki (Car)", 0.038);
                                takafulMalaysiaPercentages.put("Mazda", 0.039);
                                takafulMalaysiaPercentages.put("McLaren", 0.04);
                                takafulMalaysiaPercentages.put("Chevrolet", 0.041);
                                takafulMalaysiaPercentages.put("Hyundai", 0.042);
                                takafulMalaysiaPercentages.put("BMW (Car)", 0.043);
                                takafulMalaysiaPercentages.put("Chery", 0.044);
                                takafulMalaysiaPercentages.put("Volvo", 0.036);
                                takafulMalaysiaPercentages.put("Ford", 0.037);
                                takafulMalaysiaPercentages.put("Mercedes Benz", 0.038);
                                takafulMalaysiaPercentages.put("Lexus", 0.039);
                                takafulMalaysiaPercentages.put("Rolls Royce", 0.04);
                                takafulMalaysiaPercentages.put("Bentley", 0.041);
                                takafulMalaysiaPercentages.put("Porsche", 0.042);
                                takafulMalaysiaPercentages.put("Jaguar", 0.043);
                                takafulMalaysiaPercentages.put("Landrover Range Rover", 0.044);
                                takafulMalaysiaPercentages.put("Infiniti", 0.036);
                                takafulMalaysiaPercentages.put("Audi", 0.037);
                                takafulMalaysiaPercentages.put("Citroen", 0.038);
                                companyVehicleMakePercentages.put("Takaful Malaysia", takafulMalaysiaPercentages);

                                Map<String, Double> etiqaPercentages = new HashMap<>();
                                etiqaPercentages.put("Perodua", 0.042);
                                etiqaPercentages.put("Proton", 0.043);
                                etiqaPercentages.put("Honda (Car)", 0.044);
                                etiqaPercentages.put("Toyota (Car)", 0.036);
                                etiqaPercentages.put("Nissan (Car)", 0.037);
                                etiqaPercentages.put("Mini Cooper", 0.038);
                                etiqaPercentages.put("Mitsubishi", 0.039);
                                etiqaPercentages.put("Peugoet", 0.04);
                                etiqaPercentages.put("Volkswagen", 0.041);
                                etiqaPercentages.put("Subaru", 0.042);
                                etiqaPercentages.put("Ssangyong", 0.034);
                                etiqaPercentages.put("Kia", 0.035);
                                etiqaPercentages.put("Naza", 0.036);
                                etiqaPercentages.put("Isuzu (Car)", 0.037);
                                etiqaPercentages.put("Suzuki (Car)", 0.038);
                                etiqaPercentages.put("Mazda", 0.039);
                                etiqaPercentages.put("McLaren", 0.04);
                                etiqaPercentages.put("Chevrolet", 0.041);
                                etiqaPercentages.put("Hyundai", 0.042);
                                etiqaPercentages.put("BMW (Car)", 0.043);
                                etiqaPercentages.put("Chery", 0.044);
                                etiqaPercentages.put("Volvo", 0.036);
                                etiqaPercentages.put("Ford", 0.037);
                                etiqaPercentages.put("Mercedes Benz", 0.038);
                                etiqaPercentages.put("Lexus", 0.039);
                                etiqaPercentages.put("Rolls Royce", 0.04);
                                etiqaPercentages.put("Bentley", 0.041);
                                etiqaPercentages.put("Porsche", 0.042);
                                etiqaPercentages.put("Jaguar", 0.043);
                                etiqaPercentages.put("Landrover Range Rover", 0.044);
                                etiqaPercentages.put("Infiniti", 0.036);
                                etiqaPercentages.put("Audi", 0.037);
                                etiqaPercentages.put("Citroen", 0.038);
                                companyVehicleMakePercentages.put("Etiqa", etiqaPercentages);

                                Map<String, Double> allianzPercentages = new HashMap<>();
                                allianzPercentages.put("Perodua", 0.045);
                                allianzPercentages.put("Proton", 0.046);
                                allianzPercentages.put("Honda (Car)", 0.047);
                                allianzPercentages.put("Toyota (Car)", 0.039);
                                allianzPercentages.put("Nissan (Car)", 0.04);
                                allianzPercentages.put("Mini Cooper", 0.041);
                                allianzPercentages.put("Mitsubishi", 0.042);
                                allianzPercentages.put("Peugoet", 0.043);
                                allianzPercentages.put("Volkswagen", 0.044);
                                allianzPercentages.put("Subaru", 0.045);
                                allianzPercentages.put("Ssangyong", 0.037);
                                allianzPercentages.put("Kia", 0.038);
                                allianzPercentages.put("Naza", 0.039);
                                allianzPercentages.put("Isuzu (Car)", 0.04);
                                allianzPercentages.put("Suzuki (Car)", 0.041);
                                allianzPercentages.put("Mazda", 0.042);
                                allianzPercentages.put("McLaren", 0.043);
                                allianzPercentages.put("Chevrolet", 0.044);
                                allianzPercentages.put("Hyundai", 0.045);
                                allianzPercentages.put("BMW (Car)", 0.046);
                                allianzPercentages.put("Chery", 0.047);
                                allianzPercentages.put("Volvo", 0.039);
                                allianzPercentages.put("Ford", 0.04);
                                allianzPercentages.put("Mercedes Benz", 0.041);
                                allianzPercentages.put("Lexus", 0.042);
                                allianzPercentages.put("Rolls Royce", 0.043);
                                allianzPercentages.put("Bentley", 0.044);
                                allianzPercentages.put("Porsche", 0.045);
                                allianzPercentages.put("Jaguar", 0.046);
                                allianzPercentages.put("Landrover Range Rover", 0.047);
                                allianzPercentages.put("Infiniti", 0.039);
                                allianzPercentages.put("Audi", 0.04);
                                allianzPercentages.put("Citroen", 0.041);
                                companyVehicleMakePercentages.put("Allianz", allianzPercentages);

                                Map<String, Double> pacificPercentages = new HashMap<>();
                                pacificPercentages.put("Perodua", 0.03);
                                pacificPercentages.put("Proton", 0.031);
                                pacificPercentages.put("Honda (Car)", 0.032);
                                pacificPercentages.put("Toyota (Car)", 0.022);
                                pacificPercentages.put("Nissan (Car)", 0.023);
                                pacificPercentages.put("Mini Cooper", 0.024);
                                pacificPercentages.put("Mitsubishi", 0.025);
                                pacificPercentages.put("Peugoet", 0.026);
                                pacificPercentages.put("Volkswagen", 0.027);
                                pacificPercentages.put("Subaru", 0.028);
                                pacificPercentages.put("Ssangyong", 0.018);
                                pacificPercentages.put("Kia", 0.019);
                                pacificPercentages.put("Naza", 0.02);
                                pacificPercentages.put("Isuzu (Car)", 0.021);
                                pacificPercentages.put("Suzuki (Car)", 0.022);
                                pacificPercentages.put("Mazda", 0.023);
                                pacificPercentages.put("McLaren", 0.024);
                                pacificPercentages.put("Chevrolet", 0.025);
                                pacificPercentages.put("Hyundai", 0.026);
                                pacificPercentages.put("BMW (Car)", 0.027);
                                pacificPercentages.put("Chery", 0.028);
                                pacificPercentages.put("Volvo", 0.018);
                                pacificPercentages.put("Ford", 0.019);
                                pacificPercentages.put("Mercedes Benz", 0.02);
                                pacificPercentages.put("Lexus", 0.021);
                                pacificPercentages.put("Rolls Royce", 0.022);
                                pacificPercentages.put("Bentley", 0.023);
                                pacificPercentages.put("Porsche", 0.024);
                                pacificPercentages.put("Jaguar", 0.025);
                                pacificPercentages.put("Landrover Range Rover", 0.026);
                                pacificPercentages.put("Infiniti", 0.027);
                                pacificPercentages.put("Audi", 0.028);
                                pacificPercentages.put("Citroen", 0.018);
                                companyVehicleMakePercentages.put("Pacific", pacificPercentages);

                                Map<String, Double> libertyPercentages = new HashMap<>();
                                libertyPercentages.put("Perodua", 0.021);
                                libertyPercentages.put("Proton", 0.022);
                                libertyPercentages.put("Honda (Car)", 0.023);
                                libertyPercentages.put("Toyota (Car)", 0.018);
                                libertyPercentages.put("Nissan (Car)", 0.019);
                                libertyPercentages.put("Mini Cooper", 0.024);
                                libertyPercentages.put("Mitsubishi", 0.025);
                                libertyPercentages.put("Peugoet", 0.026);
                                libertyPercentages.put("Volkswagen", 0.027);
                                libertyPercentages.put("Subaru", 0.028);
                                libertyPercentages.put("Ssangyong", 0.017);
                                libertyPercentages.put("Kia", 0.018);
                                libertyPercentages.put("Naza", 0.019);
                                libertyPercentages.put("Isuzu (Car)", 0.02);
                                libertyPercentages.put("Suzuki (Car)", 0.021);
                                libertyPercentages.put("Mazda", 0.022);
                                libertyPercentages.put("McLaren", 0.023);
                                libertyPercentages.put("Chevrolet", 0.024);
                                libertyPercentages.put("Hyundai", 0.025);
                                libertyPercentages.put("BMW (Car)", 0.026);
                                libertyPercentages.put("Chery", 0.028);
                                libertyPercentages.put("Volvo", 0.029);
                                libertyPercentages.put("Ford", 0.031);
                                libertyPercentages.put("Mercedes Benz", 0.027);
                                libertyPercentages.put("Lexus", 0.033);
                                libertyPercentages.put("Rolls Royce", 0.022);
                                libertyPercentages.put("Bentley", 0.023);
                                libertyPercentages.put("Porsche", 0.024);
                                libertyPercentages.put("Jaguar", 0.025);
                                libertyPercentages.put("Landrover Range Rover", 0.026);
                                libertyPercentages.put("Infiniti", 0.027);
                                libertyPercentages.put("Audi", 0.028);
                                libertyPercentages.put("Citroen", 0.029);
                                companyVehicleMakePercentages.put("Liberty", libertyPercentages);

                                Map<String, Double> zurichPercentages = new HashMap<>();
                                zurichPercentages.put("Perodua", 0.026);
                                zurichPercentages.put("Proton", 0.027);
                                zurichPercentages.put("Honda (Car)", 0.028);
                                zurichPercentages.put("Toyota (Car)", 0.019);
                                zurichPercentages.put("Nissan (Car)", 0.020);
                                zurichPercentages.put("Mini Cooper", 0.029);
                                zurichPercentages.put("Mitsubishi", 0.030);
                                zurichPercentages.put("Peugoet", 0.031);
                                zurichPercentages.put("Volkswagen", 0.032);
                                zurichPercentages.put("Subaru", 0.022);
                                zurichPercentages.put("Ssangyong", 0.021);
                                zurichPercentages.put("Kia", 0.022);
                                zurichPercentages.put("Naza", 0.023);
                                zurichPercentages.put("Isuzu (Car)", 0.024);
                                zurichPercentages.put("Suzuki (Car)", 0.025);
                                zurichPercentages.put("Mazda", 0.026);
                                zurichPercentages.put("McLaren", 0.027);
                                zurichPercentages.put("Chevrolet", 0.028);
                                zurichPercentages.put("Hyundai", 0.029);
                                zurichPercentages.put("BMW (Car)", 0.030);
                                zurichPercentages.put("Chery", 0.031);
                                zurichPercentages.put("Volvo", 0.032);
                                zurichPercentages.put("Ford", 0.022);
                                zurichPercentages.put("Mercedes Benz", 0.021);
                                zurichPercentages.put("Lexus", 0.022);
                                zurichPercentages.put("Rolls Royce", 0.023);
                                zurichPercentages.put("Bentley", 0.024);
                                zurichPercentages.put("Porsche", 0.025);
                                zurichPercentages.put("Jaguar", 0.026);
                                zurichPercentages.put("Landrover Range Rover", 0.027);
                                zurichPercentages.put("Infiniti", 0.028);
                                zurichPercentages.put("Audi", 0.029);
                                zurichPercentages.put("Citroen", 0.030);
                                companyVehicleMakePercentages.put("Zurich", zurichPercentages);

                                Map<String, Double> generalyPercentages = new HashMap<>();
                                generalyPercentages.put("Perodua", 0.025);
                                generalyPercentages.put("Proton", 0.026);
                                generalyPercentages.put("Honda (Car)", 0.027);
                                generalyPercentages.put("Toyota (Car)", 0.018);
                                generalyPercentages.put("Nissan (Car)", 0.019);
                                generalyPercentages.put("Mini Cooper", 0.028);
                                generalyPercentages.put("Mitsubishi", 0.029);
                                generalyPercentages.put("Peugoet", 0.030);
                                generalyPercentages.put("Volkswagen", 0.031);
                                generalyPercentages.put("Subaru", 0.021);
                                generalyPercentages.put("Ssangyong", 0.020);
                                generalyPercentages.put("Kia", 0.021);
                                generalyPercentages.put("Naza", 0.022);
                                generalyPercentages.put("Isuzu (Car)", 0.023);
                                generalyPercentages.put("Suzuki (Car)", 0.024);
                                generalyPercentages.put("Mazda", 0.025);
                                generalyPercentages.put("McLaren", 0.026);
                                generalyPercentages.put("Chevrolet", 0.027);
                                generalyPercentages.put("Hyundai", 0.028);
                                generalyPercentages.put("BMW (Car)", 0.029);
                                generalyPercentages.put("Chery", 0.030);
                                generalyPercentages.put("Volvo", 0.031);
                                generalyPercentages.put("Ford", 0.021);
                                generalyPercentages.put("Mercedes Benz", 0.020);
                                generalyPercentages.put("Lexus", 0.021);
                                generalyPercentages.put("Rolls Royce", 0.022);
                                generalyPercentages.put("Bentley", 0.023);
                                generalyPercentages.put("Porsche", 0.024);
                                generalyPercentages.put("Jaguar", 0.025);
                                generalyPercentages.put("Landrover Range Rover", 0.026);
                                generalyPercentages.put("Infiniti", 0.027);
                                generalyPercentages.put("Audi", 0.028);
                                generalyPercentages.put("Citroen", 0.029);
                                companyVehicleMakePercentages.put("Generaly", generalyPercentages);
                            %>
                            <div class="row">
                                <%
                                    // Iterate over each company in companyVehicleMakePercentages
                                    for (Map.Entry<String, Map<String, Double>> entry : companyVehicleMakePercentages.entrySet()) {
                                        String companyName = entry.getKey();
                                        Map<String, Double> percentagesForCompany = entry.getValue();

                                        // Check if the year of manufacture meets the conditions for Takaful Ikhlas and other companies
                                        boolean vehicleEligible = false;
                                        if ("Takaful Ikhlas".equals(companyName)) {
                                            vehicleEligible = Integer.parseInt(manufactureYear) >= (Integer.parseInt(policyCommencementDate.substring(0, 4)) - 15);
                                        } else {
                                            vehicleEligible = Integer.parseInt(manufactureYear) >= (Integer.parseInt(policyCommencementDate.substring(0, 4)) - 10);
                                        }

                                        if (!vehicleEligible) {
                                            // Display a message if the vehicle is too old
                                            out.println("<div class='col-md-6 mb-4'><div class='card'><div class='card-header'>" + companyName + "</div><div class='card-body'><p>The vehicle cannot be covered by Third Party Fire And Theft. Please select Comprehensive coverage.</p></div></div></div>");
                                        } else {
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