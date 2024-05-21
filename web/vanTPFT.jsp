<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Van Insurance Third Party Fire And Theft Quotation</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="CSS/quotation.css">
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
        <div class="container mt-5">
            <div class="card mb-4">
                <div class="card-header">
                    <h1 class="mb-4">Insurance Quotation</h1>
                </div>
                <div class="card-body">
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
                </div>
            </div>
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
            %>
            <div class="row">
                <%
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
                %>
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header">
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
                        } else {
                            // If the vehicle does not meet the conditions, display a message
                            out.println("<div class='col-md-6 mb-4'><div class='card'><div class='card-header'>" + companyName + "</div><div class='card-body'><p>The vehicle cannot be covered by Third Party Fire And Theft. Please select Comprehensive coverage.</p></div></div></div>");
                        }
                    }
                %>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>