<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Van Insurance Third Party Fire And Theft Quotation</title>
        <style>
            /* The Modal (background) */
            .modal {
                display: none; /* Hidden by default */
                position: fixed; /* Stay in place */
                z-index: 1; /* Sit on top */
                left: 0;
                top: 0;
                width: 100%; /* Full width */
                height: 100%; /* Full height */
                overflow: auto; /* Enable scroll if needed */
                background-color: rgba(0,0,0,0.4); /* Black with opacity */
            }

            /* Modal Content/Box */
            .modal-content {
                background-color: #fefefe;
                margin: 15% auto; /* 15% from the top and centered */
                padding: 20px;
                border: 1px solid #888;
                width: 40%; /* Could be more or less, depending on screen size */
                text-align: center;
            }

            /* Close Button */
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
            }

            .close:hover,
            .close:focus {
                color: black;
                text-decoration: none;
                cursor: pointer;
            }
        </style>

    </head>
    <body>
        <%
            String userID = (String) session.getAttribute("userID");
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
                150.20, 168.45, 188.75, 208.90, 226.30, 244.50, 264.80, 276.10
            };

            double[] eastMalaysiaBaseValues = {
                84.30, 94.60, 106.25, 116.90, 126.50, 136.70, 146.80, 150.00
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

        <h1>Insurance Quotation</h1>
        <input type="hidden" name="userID" value="<%= userID%>">
        <input type="hidden" name="quotationId" value="<%= quotationId%>">

        <h2>Personal Information</h2>
        <p>Owner Name: <%= ownerName%></p>
        <p>Owner ID: <%= ownerId%></p>
        <p>Date of Birth: <%= dob%></p>
        <p>Gender: <%= gender%></p>
        <p>Marital Status: <%= maritalStatus%></p>

        <h2>Vehicle Information</h2>
        <p>Location: <%= location%></p>
        <p>Vehicle Type: <%= vehicleType%></p>
        <p>Local/Import: <%= localImport%></p>
        <p>Registration Number: <%= registrationNumber%></p>
        <p>Engine Number: <%= engineNumber%></p>
        <p>Chassis Number: <%= chassisNumber%></p>
        <p>Coverage: <%= coverage%></p>
        <p>Insured Value: RM <%= formattedInsuredValue%></p>
        <p>Engine Capacity: <%= engineCapacity%> cc</p>
        <p>Vehicle Body: <%= vehicleBody%></p>
        <p>Vehicle Make: <%= vehicleMake%></p>
        <p>Vehicle Model: <%= vehicleModel%></p>
        <p>Manufacture Year: <%= manufactureYear%></p>

        <h2>Policy Information</h2>
        <p>Policy Commencement Date: <%= policyCommencementDate%></p>
        <p>Policy Duration: <%= policyDuration%> years</p>
        <p>Policy Duration: <%= policyExpiryDate%></p>

        <h2>Gross Premium Calculation</h2>
        <p>Gross Premium: RM <%= formattedGrossPremium%></p>

        <h2>Additional Calculations</h2>
        <p>NCD: RM <%= formattedNCD%></p>
        <p>Total Premium after NCD: RM <%= formattedTotalPremium%></p>

        <%
            // Define percentages based on vehicle make for each company
            Map<String, Map<String, Double>> companyVehicleMakePercentages = new HashMap<>();

            Map<String, Double> takafulIkhlasPercentages = new HashMap<>();
            takafulIkhlasPercentages.put("Toyota (Van)", 0.035);
            takafulIkhlasPercentages.put("Nissan (Van)", 0.038);
            takafulIkhlasPercentages.put("Daihatsu", 0.039);
            takafulIkhlasPercentages.put("Foton (Van)", 0.042);
            companyVehicleMakePercentages.put("Takaful Ikhlas", takafulIkhlasPercentages);

            Map<String, Double> takafulMalaysiaPercentages = new HashMap<>();
            takafulMalaysiaPercentages.put("Toyota (Van)", 0.036);
            takafulMalaysiaPercentages.put("Nissan (Van)", 0.037);
            takafulMalaysiaPercentages.put("Daihatsu", 0.038);
            takafulMalaysiaPercentages.put("Foton (Van)", 0.039);
            companyVehicleMakePercentages.put("Takaful Malaysia", takafulMalaysiaPercentages);

            Map<String, Double> etiqaPercentages = new HashMap<>();
            etiqaPercentages.put("Toyota (Van)", 0.025);
            etiqaPercentages.put("Nissan (Van)", 0.035);
            etiqaPercentages.put("Daihatsu", 0.021);
            etiqaPercentages.put("Foton (Van)", 0.043);
            companyVehicleMakePercentages.put("Etiqa", etiqaPercentages);

            Map<String, Double> allianzPercentages = new HashMap<>();
            allianzPercentages.put("Toyota (Van)", 0.032);
            allianzPercentages.put("Nissan (Van)", 0.028);
            allianzPercentages.put("Daihatsu", 0.035);
            allianzPercentages.put("Foton (Van)", 0.039);
            companyVehicleMakePercentages.put("Allianz", allianzPercentages);

            Map<String, Double> pacificPercentages = new HashMap<>();
            pacificPercentages.put("Toyota (Van)", 0.023);
            pacificPercentages.put("Nissan (Van)", 0.029);
            pacificPercentages.put("Daihatsu", 0.025);
            pacificPercentages.put("Foton (Van)", 0.031);
            companyVehicleMakePercentages.put("Pacific", pacificPercentages);

            Map<String, Double> libertyPercentages = new HashMap<>();
            libertyPercentages.put("Toyota (Van)", 0.028);
            libertyPercentages.put("Nissan (Van)", 0.027);
            libertyPercentages.put("Daihatsu", 0.026);
            libertyPercentages.put("Foton (Van)", 0.025);
            companyVehicleMakePercentages.put("Liberty", libertyPercentages);

            Map<String, Double> zurichPercentages = new HashMap<>();
            zurichPercentages.put("Toyota (Van)", 0.034);
            zurichPercentages.put("Nissan (Van)", 0.033);
            zurichPercentages.put("Daihatsu", 0.032);
            zurichPercentages.put("Foton (Van)", 0.031);
            companyVehicleMakePercentages.put("Zurich", zurichPercentages);

            Map<String, Double> generalyPercentages = new HashMap<>();
            generalyPercentages.put("Toyota (Van)", 0.038);
            generalyPercentages.put("Nissan (Van)", 0.037);
            generalyPercentages.put("Daihatsu", 0.036);
            generalyPercentages.put("Foton (Van)", 0.035);
            companyVehicleMakePercentages.put("Generaly", generalyPercentages);

            // Iterate over each company in companyVehicleMakePercentages
            for (Map.Entry<String, Map<String, Double>> entry : companyVehicleMakePercentages.entrySet()) {
                String companyName = entry.getKey();
                Map<String, Double> percentagesForCompany = entry.getValue();

                // Check if the year of manufacture meets the conditions for Takaful Ikhlas and other companies
                if (("Takaful Ikhlas".equals(companyName) && Integer.parseInt(manufactureYear) < (Integer.parseInt(policyCommencementDate.substring(0, 4)) - 15))
                        || (!"Takaful Ikhlas".equals(companyName) && Integer.parseInt(manufactureYear) < (Integer.parseInt(policyCommencementDate.substring(0, 4)) - 10))) {

                    // Find the percentage for the selected vehicle make for this company
                    Double companyPercentage = percentagesForCompany.get(vehicleMake);

                    // If the percentage is found for the selected make, calculate the insurance price for this company
                    if (companyPercentage != null) {
                        double companyTotalPremium = totalPremium * (1 + companyPercentage);

                        // Apply SST (SST is 10%)
                        double sst = 0.10 * totalPremium;

                        // Add stamp duty (stamp duty is RM10)
                        double stampDuty = 10.0;

                        // Calculate final total premium after applying SST and adding stamp duty
                        double finalTotalPremium = companyTotalPremium + sst + stampDuty;

                        // Format the insurance price
                        String formattedCompanyTotalPremium = df.format(companyTotalPremium);
                        String formattedSST = df.format(sst);
                        String formattedStampDuty = df.format(stampDuty);
                        String formattedFinalTotalPremium = df.format(finalTotalPremium);

                        // Display insurance price for the current company
                        out.println("<h3>" + companyName + "</h3>");
                        out.println("<p>Insurance Price: RM " + formattedCompanyTotalPremium + "</p>");
                        out.println("<p>SST (10%): RM " + formattedSST + "</p>");
                        out.println("<p>Stamp Duty (RM10): RM " + formattedStampDuty + "</p>");
                        out.println("<p>Final Total Premium: RM " + formattedFinalTotalPremium + "</p>");
        %>
        <form id="purchaseForm" method="post" action="">
            <input type="hidden" id="purchaseOption" name="purchaseOption">
            <input type="hidden" id="companyName" name="companyName">
        </form>
        <button class="purchaseButton" data-company="<%= companyName%>" type="button">Purchase</button>
        <div id="<%= companyName%>Modal" class="modal">
            <div class="modal-content">
                <span class="close" data-modal="<%= companyName%>Modal">&times;</span>
                <p>Choose your purchase option:</p>
                <button onclick="selectPurchaseOption('<%= companyName%>', 'COD')">Cash on Delivery (COD)</button>
                <button onclick="selectPurchaseOption('<%= companyName%>', 'QR')">QR Code</button>
            </div>
        </div>
        <%
                    } else {
                        // If percentage not found for the selected make, display a message
                        out.println("<h3>" + companyName + "</h3>");
                        out.println("<p>No insurance price available for selected vehicle make.</p>");
                    }
                } else {
                    // If the vehicle does not meet the conditions, display a message
                    out.println("<h3>" + companyName + "</h3>");
                    out.println("<p>The vehicle cannot be covered by Third Party Fire And Theft. Please select Comprehensive coverage.</p>");
                }
            }
        %>
        <script>
// Function to display modal
            function purchaseOption(companyName) {
                var modal = document.getElementById(companyName + "Modal");
                modal.style.display = "block";
            }

            // Function to close modal
            function closeModal(modalId) {
                var modal = document.getElementById(modalId);
                modal.style.display = "none";
            }

            // Event listener for close buttons
            var closeButtons = document.querySelectorAll('.close');
            closeButtons.forEach(function (button) {
                button.addEventListener('click', function () {
                    var modalId = this.getAttribute('data-modal');
                    closeModal(modalId);
                });
            });

            // Function to select purchase option and set action URL
            function selectPurchaseOption(companyName, option) {
                // Set the action URL of the form based on the selected option
                var form = document.getElementById("purchaseForm");
                if (option === "COD") {
                    form.action = "cod_page.jsp"; // Replace "cod_page.jsp" with your actual COD page URL
                } else if (option === "QR") {
                    form.action = "qr_page.jsp"; // Replace "qr_page.jsp" with your actual QR Code page URL
                }
                // Submit the form
                form.submit();
            }

            // Trigger modal display when the "Purchase" button is clicked
            var purchaseButtons = document.querySelectorAll('.purchaseButton');
            purchaseButtons.forEach(function (button) {
                button.addEventListener('click', function () {
                    var companyName = this.getAttribute('data-company');
                    purchaseOption(companyName);
                });
            });
        </script>
    </body>
</html>
