<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Insurance Quotation</title>
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

            double[] baseValues = {273.80, 305.50, 339.10, 372.60, 404.30, 436.00, 469.60, 501.30};

            double baseValue = 0.0;
            if (engineCapacity <= 1400) {
                baseValue = baseValues[0];
            } else if (engineCapacity <= 1650) {
                baseValue = baseValues[1];
            } else if (engineCapacity <= 2200) {
                baseValue = baseValues[2];
            } else if (engineCapacity <= 3050) {
                baseValue = baseValues[3];
            } else if (engineCapacity <= 4100) {
                baseValue = baseValues[4];
            } else if (engineCapacity <= 4250) {
                baseValue = baseValues[5];
            } else if (engineCapacity <= 4400) {
                baseValue = baseValues[6];
            } else {
                baseValue = baseValues[7];
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

            // Apply SST (SST is 10%)
            double sst = 0.10 * totalPremium;

            // Add stamp duty (stamp duty is RM10)
            double stampDuty = 10.0;

            // Calculate final total premium after applying SST and adding stamp duty
            double finalTotalPremium = totalPremium + sst + stampDuty;

            // Format all decimal values to two decimal points
            DecimalFormat df = new DecimalFormat("#.##");
            String formattedInsuredValue = df.format(insuredValue);
            String formattedGrossPremium = df.format(grossPremium);
            String formattedNCD = df.format(ncd);
            String formattedTotalAddOnsCost = df.format(totalAddOnsCost);
            String formattedTotalPremium = df.format(totalPremium);
            String formattedSST = df.format(sst);
            String formattedStampDuty = df.format(stampDuty);
            String formattedFinalTotalPremium = df.format(finalTotalPremium);
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
        <p>SST (10%): RM <%= formattedSST%></p>
        <p>Stamp Duty (RM10): RM <%= formattedStampDuty%></p>

        <h2>Final Total Premium</h2>
        <p>Final Total Premium: RM <%= formattedFinalTotalPremium%></p>
    </body>
</html>
