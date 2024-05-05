<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Motorcycle Insurance Comprehensive Quotation</title>
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
        <h3><%= companyName%></h3>
        <p>Insurance Price: RM <%= formattedCompanyTotalPremium%></p>
        <p>SST (10%): RM <%= formattedSST%></p>
        <p>Stamp Duty (RM10): RM <%= formattedStampDuty%></p>
        <p>Final Total Premium: RM <%= formattedFinalTotalPremium%></p>
        <!-- Add COD and QR buttons for each company -->
        <form id="purchaseForm_<%= companyName%>" method="post" action="qrCode.jsp">
            <input type="hidden" name="finalTotalPremium" value="<%= formattedFinalTotalPremium%>">
            <input type="hidden" name="userID" value="<%= userID%>">
            <input type="hidden" name="quotationId" value="<%= quotationId%>">
            <input type="hidden" name="registrationNumber" value="<%= registrationNumber%>">
            <input type="hidden" name="policyCommencementDate" value="<%= policyCommencementDate%>">
            <input type="hidden" name="policyDuration" value="<%= policyDuration%>">
            <input type="hidden" name="policyExpiryDate" value="<%= policyExpiryDate%>">
            <input type="hidden" name="engineCapacity" value="<%= engineCapacity%>">
            <button type="submit" name="purchaseOption" value="QR">QR Code</button>
        </form>
        <form id="purchaseForm_<%= companyName%>" method="post" action="cod.jsp">
            <input type="hidden" name="finalTotalPremium" value="<%= formattedFinalTotalPremium%>">
            <input type="hidden" name="userID" value="<%= userID%>">
            <input type="hidden" name="quotationId" value="<%= quotationId%>">
            <input type="hidden" name="registrationNumber" value="<%= registrationNumber%>">
            <input type="hidden" name="policyCommencementDate" value="<%= policyCommencementDate%>">
            <input type="hidden" name="policyDuration" value="<%= policyDuration%>">
            <input type="hidden" name="policyExpiryDate" value="<%= policyExpiryDate%>">
            <input type="hidden" name="engineCapacity" value="<%= engineCapacity%>">
            <button type="submit" name="purchaseOption" value="COD">Cash on Delivery (COD)</button>
        </form>
        <div id="modal_<%= companyName%>" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close" data-modal="modal_<%= companyName%>">&times;</span>
                <p>Choose your purchase option for <%= companyName%>:</p>
                <button onclick="submitForm('<%= companyName%>', 'COD')">Cash on Delivery (COD)</button>
                <button onclick="submitForm('<%= companyName%>', 'QR')">QR Code</button>
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
            // Function to submit the form for COD or QR
            function submitForm(companyName, option) {
                var form = document.getElementById('purchaseForm_' + companyName);
                form.querySelector('input[name="purchaseOption"]').value = option; // Set the purchase option
                form.submit(); // Submit the form
            }

            // Event listeners for COD and QR buttons
            var codButtons = document.querySelectorAll('.codButton');
            var qrButtons = document.querySelectorAll('.qrButton');

            codButtons.forEach(function (button) {
                button.addEventListener('click', function () {
                    var companyName = this.getAttribute('data-company');
                    submitForm(companyName, 'COD');
                });
            });

            qrButtons.forEach(function (button) {
                button.addEventListener('click', function () {
                    var companyName = this.getAttribute('data-company');
                    submitForm(companyName, 'QR');
                });
            });
        </script>
    </body>
</html>
