<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lorry Insurance Comprehensive Quotation</title>
    </head>
    <body>
        <%
            double windscreenCost = 0.0;
            double specialPerilsCost = 0.0;
            double allDriverCost = 0.0;
            double legalLiabilityCost = 0.0;

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
                400.00, 440.00, 480.00, 520.00, 560.00, 600.00, 640.00, 680.00
            };

            double[] eastMalaysiaBaseValues = {
                320.00, 360.00, 400.00, 440.00, 480.00, 520.00, 560.00, 600.00
            };

            double baseValue = 0.0;

            if ("peninsular".equals(location)) {
                baseValue = peninsulaBaseValues[0]; // Default to the lowest base value for Peninsula
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
                baseValue = eastMalaysiaBaseValues[0]; // Default to the lowest base value for East Malaysia
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

            // Initialize totalAddOnsCost
            double totalAddOnsCost = 0.0;

            String windscreenPriceStr = request.getParameter("windscreen-price");
            double windscreenPrice = 0.0; // Default value
            if (windscreenPriceStr != null && !windscreenPriceStr.isEmpty()) {
                try {
                    windscreenPrice = Double.parseDouble(windscreenPriceStr);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

            // Check if windscreen addon is selected
            String windscreenAddon = request.getParameter("windscreen-addon");
            if ("true".equals(windscreenAddon)) {
                // Adjust the windscreen cost calculation based on the windscreen price
                windscreenCost = 0.15 * windscreenPrice;
            }

            // Check if all driver addon is selected
            String allDriverAddon = request.getParameter("all-driver-addon");
            if ("true".equals(allDriverAddon)) {
                // Assuming a fixed cost of RM20 for all driver addon
                allDriverCost = 20.0;
            }

            // Check if special perils addon is selected
            String specialPerilsAddon = request.getParameter("special-perils-addon");
            if ("true".equals(specialPerilsAddon)) {
                // Assuming special perils cost is calculated as 0.25% of insured value
                specialPerilsCost = 0.0025 * insuredValue;
            }

            // Check if legal liability addon is selected
            String legalLiabilityAddon = request.getParameter("legal-liability-addon");
            if ("true".equals(legalLiabilityAddon)) {
                // Assuming a fixed cost of RM7.50 for legal liability of passengers addon
                legalLiabilityCost = 7.50;
            }

            // Calculate total premium after deducting NCD and adding add-ons
            totalAddOnsCost = windscreenCost + specialPerilsCost + allDriverCost + legalLiabilityCost;
            double totalPremium = (grossPremium - ncd) + totalAddOnsCost;

            // Format all decimal values to two decimal points
            DecimalFormat df = new DecimalFormat("#.##");
            String formattedInsuredValue = df.format(insuredValue);
            String formattedGrossPremium = df.format(grossPremium);
            String formattedNCD = df.format(ncd);
            String formattedTotalAddOnsCost = df.format(totalAddOnsCost);
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

        <%-- Add-ons --%>
        <% if (totalAddOnsCost > 0) { %>
        <h2>Add-ons</h2>
        <% if ("true".equals(request.getParameter("windscreen-addon"))) {%>
        <p>Windscreen: RM <%= df.format(windscreenCost)%></p>
        <% } %>
        <% if ("true".equals(request.getParameter("all-driver-addon"))) {%>
        <p>All Driver: RM <%= df.format(allDriverCost)%></p>
        <% } %>
        <% if ("true".equals(request.getParameter("special-perils-addon"))) {%>
        <p>Special Perils (Flood): RM <%= df.format(specialPerilsCost)%></p>
        <% } %>
        <% if ("true".equals(request.getParameter("legal-liability-addon"))) {%>
        <p>Legal Liability of Passengers: RM <%= df.format(legalLiabilityCost)%></p>
        <% } %>
        <% }%>

        <h2>Additional Calculations</h2>
        <p>NCD: RM <%= formattedNCD%></p>
        <p>Total Add-ons Cost: RM <%= formattedTotalAddOnsCost%></p>
        <p>Total Premium after NCD and Add-ons: RM <%= formattedTotalPremium%></p>

        <%
            // Define percentages based on vehicle make for each company
            Map<String, Map<String, Double>> companyVehicleMakePercentages = new HashMap<>();

            Map<String, Double> takafulIkhlasPercentages = new HashMap<>();
            takafulIkhlasPercentages.put("Hino", 0.033);
            takafulIkhlasPercentages.put("Fuso", 0.035);
            takafulIkhlasPercentages.put("Isuzu (Lorry)", 0.037);
            takafulIkhlasPercentages.put("UD Truck", 0.039);
            takafulIkhlasPercentages.put("Volvo", 0.041);
            takafulIkhlasPercentages.put("CAMC", 0.043);
            takafulIkhlasPercentages.put("Foton (Lorry)", 0.045);
            takafulIkhlasPercentages.put("JMC", 0.047);
            companyVehicleMakePercentages.put("Takaful Ikhlas", takafulIkhlasPercentages);

            Map<String, Double> takafulMalaysiaPercentages = new HashMap<>();
            takafulMalaysiaPercentages.put("Hino", 0.037);
            takafulMalaysiaPercentages.put("Fuso", 0.038);
            takafulMalaysiaPercentages.put("Isuzu (Lorry)", 0.039);
            takafulMalaysiaPercentages.put("UD Truck", 0.040);
            takafulMalaysiaPercentages.put("Volvo", 0.041);
            takafulMalaysiaPercentages.put("CAMC", 0.042);
            takafulMalaysiaPercentages.put("Foton (Lorry)", 0.043);
            takafulMalaysiaPercentages.put("JMC", 0.044);
            companyVehicleMakePercentages.put("Takaful Malaysia", takafulMalaysiaPercentages);

            Map<String, Double> etiqaPercentages = new HashMap<>();
            etiqaPercentages.put("Hino", 0.025);
            etiqaPercentages.put("Fuso", 0.026);
            etiqaPercentages.put("Isuzu (Lorry)", 0.027);
            etiqaPercentages.put("UD Truck", 0.028);
            etiqaPercentages.put("Volvo", 0.029);
            etiqaPercentages.put("CAMC", 0.030);
            etiqaPercentages.put("Foton (Lorry)", 0.031);
            etiqaPercentages.put("JMC", 0.032);
            companyVehicleMakePercentages.put("Etiqa", etiqaPercentages);

            Map<String, Double> allianzPercentages = new HashMap<>();
            allianzPercentages.put("Hino", 0.032);
            allianzPercentages.put("Fuso", 0.033);
            allianzPercentages.put("Isuzu (Lorry)", 0.034);
            allianzPercentages.put("UD Truck", 0.035);
            allianzPercentages.put("Volvo", 0.036);
            allianzPercentages.put("CAMC", 0.037);
            allianzPercentages.put("Foton (Lorry)", 0.038);
            allianzPercentages.put("JMC", 0.039);
            companyVehicleMakePercentages.put("Allianz", allianzPercentages);

            Map<String, Double> pacificPercentages = new HashMap<>();
            pacificPercentages.put("Hino", 0.023);
            pacificPercentages.put("Fuso", 0.024);
            pacificPercentages.put("Isuzu (Lorry)", 0.025);
            pacificPercentages.put("UD Truck", 0.026);
            pacificPercentages.put("Volvo", 0.027);
            pacificPercentages.put("CAMC", 0.028);
            pacificPercentages.put("Foton (Lorry)", 0.029);
            pacificPercentages.put("JMC", 0.030);
            companyVehicleMakePercentages.put("Pacific", pacificPercentages);

            Map<String, Double> libertyPercentages = new HashMap<>();
            libertyPercentages.put("Hino", 0.028);
            libertyPercentages.put("Fuso", 0.029);
            libertyPercentages.put("Isuzu (Lorry)", 0.030);
            libertyPercentages.put("UD Truck", 0.031);
            libertyPercentages.put("Volvo", 0.032);
            libertyPercentages.put("CAMC", 0.033);
            libertyPercentages.put("Foton (Lorry)", 0.034);
            libertyPercentages.put("JMC", 0.035);
            companyVehicleMakePercentages.put("Liberty", libertyPercentages);

            Map<String, Double> zurichPercentages = new HashMap<>();
            zurichPercentages.put("Hino", 0.034);
            zurichPercentages.put("Fuso", 0.035);
            zurichPercentages.put("Isuzu (Lorry)", 0.036);
            zurichPercentages.put("UD Truck", 0.037);
            zurichPercentages.put("Volvo", 0.038);
            zurichPercentages.put("CAMC", 0.039);
            zurichPercentages.put("Foton (Lorry)", 0.040);
            zurichPercentages.put("JMC", 0.041);
            companyVehicleMakePercentages.put("Zurich", zurichPercentages);

            Map<String, Double> generalyPercentages = new HashMap<>();
            generalyPercentages.put("Hino", 0.038);
            generalyPercentages.put("Fuso", 0.039);
            generalyPercentages.put("Isuzu (Lorry)", 0.040);
            generalyPercentages.put("UD Truck", 0.041);
            generalyPercentages.put("Volvo", 0.042);
            generalyPercentages.put("CAMC", 0.043);
            generalyPercentages.put("Foton (Lorry)", 0.044);
            generalyPercentages.put("JMC", 0.045);
            companyVehicleMakePercentages.put("Generaly", generalyPercentages);

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

                    // Display insurance price for the current company including SST and stamp duty
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
