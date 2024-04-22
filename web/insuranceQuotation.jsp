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
            String insuredValueStr = request.getParameter("insured-value");
            double insuredValue = 0.0; // Default value
            String selectedNCD = request.getParameter("ncd");

            // Convert the selected NCD value to a double for calculations
            double ncdPercentage = 0.0;
            if (selectedNCD != null && !selectedNCD.isEmpty()) {
                // Convert percentage to decimal
                ncdPercentage = Double.parseDouble(selectedNCD.replaceAll("[^0-9.]", "")) / 100;
            }

            if (insuredValueStr != null && !insuredValueStr.isEmpty()) {
                try {
                    insuredValue = Double.parseDouble(insuredValueStr);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

            String location = request.getParameter("location");
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

            // Add-ons (if any, let's assume no add-ons for now)
            double addOns = 0.0;

            // Calculate total premium after deducting NCD and adding add-ons
            double totalPremium = (grossPremium - ncd) + addOns;

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
            String formattedAddOns = df.format(addOns);
            String formattedTotalPremium = df.format(totalPremium);
            String formattedSST = df.format(sst);
            String formattedStampDuty = df.format(stampDuty);
            String formattedFinalTotalPremium = df.format(finalTotalPremium);
        %>

        <h1>Insurance Quotation</h1>

        <h2>Gross Premium Calculation</h2>
        <p>Insured Value: RM <%= formattedInsuredValue%></p>
        <p>Location: <%= location%></p>
        <p>Engine Capacity: <%= engineCapacity%> cc</p>
        <p>Gross Premium: RM <%= formattedGrossPremium%></p>

        <h2>Additional Calculations</h2>
        <p>NCD: RM <%= formattedNCD%></p>
        <p>Add-ons: RM <%= formattedAddOns%></p>
        <p>Total Premium after NCD and Add-ons: RM <%= formattedTotalPremium%></p>
        <p>SST (10%): RM <%= formattedSST%></p>
        <p>Stamp Duty (RM10): RM <%= formattedStampDuty%></p>

        <h2>Final Total Premium</h2>
        <p>Final Total Premium: RM <%= formattedFinalTotalPremium%></p>
    </body>
</html>
