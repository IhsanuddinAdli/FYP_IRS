<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Van Insurance Comprehensive Quotation</title>
    </head>
    <body>
        <%
            double windscreenCost = 0.0;
            double specialPerilsCost = 0.0;
            double allDriverCost = 0.0;
            double legalLiabilityCost = 0.0;

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
                320.00, 360.00, 400.00, 440.00, 480.00, 520.00, 560.00, 600.00
            };

            double[] eastMalaysiaBaseValues = {
                240.00, 270.00, 300.00, 330.00, 360.00, 390.00, 420.00, 450.00
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
                } else {
                    // If percentage not found for the selected make, display a message
                    out.println("<h3>" + companyName + "</h3>");
                    out.println("<p>No insurance price available for selected vehicle make.</p>");
                }
            }
        %>

    </body>
</html>
