<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Van Insurance Third Party Fire And Theft Quotation</title>
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
                180.50, 198.75, 218.95, 239.10, 256.50, 274.70, 295.00, 308.20
            };

            double[] eastMalaysiaBaseValues = {
                104.60, 114.90, 126.55, 137.20, 146.80, 157.00, 167.10, 173.50
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
                        // Add buttons for Details and Purchase
                        out.println("<form action='purchase.jsp' method='post'>");
                        out.println("<input type='hidden' name='companyName' value='" + companyName + "'>");
                        out.println("<input type='hidden' name='premium' value='" + formattedFinalTotalPremium + "'>");
                        out.println("<button type='submit' name='action' value='details'>Details</button>");
                        out.println("<button type='submit' name='action' value='purchase'>Purchase</button>");
                        out.println("</form>");
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

    </body>
</html>
