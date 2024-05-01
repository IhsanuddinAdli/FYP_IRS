<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Car Insurance Comprehensive Quotation</title>
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
                273.80, 305.50, 339.10, 372.60, 404.30, 436.00, 469.60, 501.30
            };

            double[] eastMalaysiaBaseValues = {
                196.20, 220.00, 243.90, 266.50, 290.40, 313.00, 336.40, 359.50
            };

            double baseValue = 0.0;

            if ("peninsular".equals(location)) {
                baseValue = peninsulaBaseValues[0];
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
                baseValue = eastMalaysiaBaseValues[0];
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
                    form.action = "cod.jsp"; // Replace "cod_page.jsp" with your actual COD page URL
                } else if (option === "QR") {
                    form.action = "qrCode.jsp"; // Replace "qr_page.jsp" with your actual QR Code page URL
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