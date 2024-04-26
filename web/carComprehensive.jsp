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

        <%
            // Define percentages based on vehicle make for each company
            Map<String, Map<String, Double>> companyVehicleMakePercentages = new HashMap<>();

            // Define the percentages for Takaful Ikhlas
            Map<String, Double> takafulIkhlasPercentages = new HashMap<>();
            takafulIkhlasPercentages.put("Alfa Romeo", 0.04);
            takafulIkhlasPercentages.put("Audi", 0.038);
            takafulIkhlasPercentages.put("BMW", 0.03);
            takafulIkhlasPercentages.put("Borgward", 0.015);
            takafulIkhlasPercentages.put("Chery", 0.018);
            takafulIkhlasPercentages.put("Chevrolet", 0.021);
            takafulIkhlasPercentages.put("Citroen", 0.022);
            takafulIkhlasPercentages.put("Ford", 0.023);
            takafulIkhlasPercentages.put("Honda", 0.024);
            takafulIkhlasPercentages.put("Hyundai", 0.025);
            takafulIkhlasPercentages.put("Infiniti", 0.026);
            takafulIkhlasPercentages.put("Isuzu", 0.027);
            takafulIkhlasPercentages.put("Jaguar", 0.044);
            takafulIkhlasPercentages.put("Jeep", 0.029);
            takafulIkhlasPercentages.put("Kia", 0.03);
            takafulIkhlasPercentages.put("Land Rover", 0.031);
            takafulIkhlasPercentages.put("Lexus", 0.032);
            takafulIkhlasPercentages.put("Mazda", 0.033);
            takafulIkhlasPercentages.put("Mercedes-Benz", 0.034);
            takafulIkhlasPercentages.put("MINI", 0.035);
            takafulIkhlasPercentages.put("Mitsubishi", 0.036);
            takafulIkhlasPercentages.put("Nissan", 0.037);
            takafulIkhlasPercentages.put("Perodua", 0.025);
            takafulIkhlasPercentages.put("Peugeot", 0.039);
            takafulIkhlasPercentages.put("Proton", 0.02);
            takafulIkhlasPercentages.put("Subaru", 0.041);
            takafulIkhlasPercentages.put("Suzuki", 0.042);
            takafulIkhlasPercentages.put("Toyota", 0.043);
            takafulIkhlasPercentages.put("Volkswagen", 0.028);
            takafulIkhlasPercentages.put("Volvo", 0.045);
            companyVehicleMakePercentages.put("Takaful Ikhlas", takafulIkhlasPercentages);

            // Define the percentages for Takaful Malaysia
            Map<String, Double> takafulMalaysiaPercentages = new HashMap<>();
            takafulMalaysiaPercentages.put("Alfa Romeo", 0.045);
            takafulMalaysiaPercentages.put("Audi", 0.044);
            takafulMalaysiaPercentages.put("BMW", 0.043);
            takafulMalaysiaPercentages.put("Borgward", 0.042);
            takafulMalaysiaPercentages.put("Chery", 0.041);
            takafulMalaysiaPercentages.put("Chevrolet", 0.04);
            takafulMalaysiaPercentages.put("Citroen", 0.039);
            takafulMalaysiaPercentages.put("Ford", 0.038);
            takafulMalaysiaPercentages.put("Honda", 0.037);
            takafulMalaysiaPercentages.put("Hyundai", 0.036);
            takafulMalaysiaPercentages.put("Infiniti", 0.035);
            takafulMalaysiaPercentages.put("Isuzu", 0.034);
            takafulMalaysiaPercentages.put("Jaguar", 0.033);
            takafulMalaysiaPercentages.put("Jeep", 0.032);
            takafulMalaysiaPercentages.put("Kia", 0.031);
            takafulMalaysiaPercentages.put("Land Rover", 0.03);
            takafulMalaysiaPercentages.put("Lexus", 0.029);
            takafulMalaysiaPercentages.put("Mazda", 0.028);
            takafulMalaysiaPercentages.put("Mercedes-Benz", 0.027);
            takafulMalaysiaPercentages.put("MINI", 0.026);
            takafulMalaysiaPercentages.put("Mitsubishi", 0.025);
            takafulMalaysiaPercentages.put("Nissan", 0.024);
            takafulMalaysiaPercentages.put("Perodua", 0.023);
            takafulMalaysiaPercentages.put("Peugeot", 0.022);
            takafulMalaysiaPercentages.put("Proton", 0.021);
            takafulMalaysiaPercentages.put("Subaru", 0.02);
            takafulMalaysiaPercentages.put("Suzuki", 0.019);
            takafulMalaysiaPercentages.put("Toyota", 0.018);
            takafulMalaysiaPercentages.put("Volkswagen", 0.017);
            takafulMalaysiaPercentages.put("Volvo", 0.016);
            companyVehicleMakePercentages.put("Takaful Malaysia", takafulMalaysiaPercentages);

            // Define the percentages for Etiqa
            Map<String, Double> etiqaPercentages = new HashMap<>();
            etiqaPercentages.put("Alfa Romeo", 0.042);
            etiqaPercentages.put("Audi", 0.043);
            etiqaPercentages.put("BMW", 0.044);
            etiqaPercentages.put("Borgward", 0.036);
            etiqaPercentages.put("Chery", 0.037);
            etiqaPercentages.put("Chevrolet", 0.038);
            etiqaPercentages.put("Citroen", 0.039);
            etiqaPercentages.put("Ford", 0.04);
            etiqaPercentages.put("Honda", 0.041);
            etiqaPercentages.put("Hyundai", 0.042);
            etiqaPercentages.put("Infiniti", 0.034);
            etiqaPercentages.put("Isuzu", 0.035);
            etiqaPercentages.put("Jaguar", 0.036);
            etiqaPercentages.put("Jeep", 0.037);
            etiqaPercentages.put("Kia", 0.038);
            etiqaPercentages.put("Land Rover", 0.039);
            etiqaPercentages.put("Lexus", 0.04);
            etiqaPercentages.put("Mazda", 0.041);
            etiqaPercentages.put("Mercedes-Benz", 0.042);
            etiqaPercentages.put("MINI", 0.043);
            etiqaPercentages.put("Mitsubishi", 0.044);
            etiqaPercentages.put("Nissan", 0.036);
            etiqaPercentages.put("Perodua", 0.037);
            etiqaPercentages.put("Peugeot", 0.038);
            etiqaPercentages.put("Proton", 0.039);
            etiqaPercentages.put("Subaru", 0.04);
            etiqaPercentages.put("Suzuki", 0.041);
            etiqaPercentages.put("Toyota", 0.042);
            etiqaPercentages.put("Volkswagen", 0.043);
            etiqaPercentages.put("Volvo", 0.044);
            companyVehicleMakePercentages.put("Etiqa", etiqaPercentages);

            // Define the percentages for Allianz
            Map<String, Double> allianzPercentages = new HashMap<>();
            allianzPercentages.put("Alfa Romeo", 0.045);
            allianzPercentages.put("Audi", 0.046);
            allianzPercentages.put("BMW", 0.047);
            allianzPercentages.put("Borgward", 0.039);
            allianzPercentages.put("Chery", 0.04);
            allianzPercentages.put("Chevrolet", 0.041);
            allianzPercentages.put("Citroen", 0.042);
            allianzPercentages.put("Ford", 0.043);
            allianzPercentages.put("Honda", 0.044);
            allianzPercentages.put("Hyundai", 0.045);
            allianzPercentages.put("Infiniti", 0.037);
            allianzPercentages.put("Isuzu", 0.038);
            allianzPercentages.put("Jaguar", 0.039);
            allianzPercentages.put("Jeep", 0.04);
            allianzPercentages.put("Kia", 0.041);
            allianzPercentages.put("Land Rover", 0.042);
            allianzPercentages.put("Lexus", 0.043);
            allianzPercentages.put("Mazda", 0.044);
            allianzPercentages.put("Mercedes-Benz", 0.045);
            allianzPercentages.put("MINI", 0.046);
            allianzPercentages.put("Mitsubishi", 0.047);
            allianzPercentages.put("Nissan", 0.039);
            allianzPercentages.put("Perodua", 0.04);
            allianzPercentages.put("Peugeot", 0.041);
            allianzPercentages.put("Proton", 0.042);
            allianzPercentages.put("Subaru", 0.043);
            allianzPercentages.put("Suzuki", 0.044);
            allianzPercentages.put("Toyota", 0.045);
            allianzPercentages.put("Volkswagen", 0.046);
            allianzPercentages.put("Volvo", 0.047);
            companyVehicleMakePercentages.put("Allianz", allianzPercentages);

            // Define the percentages for Pacific
            Map<String, Double> pacificPercentages = new HashMap<>();
            pacificPercentages.put("Alfa Romeo", 0.03);
            pacificPercentages.put("Audi", 0.031);
            pacificPercentages.put("BMW", 0.032);
            pacificPercentages.put("Borgward", 0.022);
            pacificPercentages.put("Chery", 0.023);
            pacificPercentages.put("Chevrolet", 0.024);
            pacificPercentages.put("Citroen", 0.025);
            pacificPercentages.put("Ford", 0.026);
            pacificPercentages.put("Honda", 0.027);
            pacificPercentages.put("Hyundai", 0.028);
            pacificPercentages.put("Infiniti", 0.018);
            pacificPercentages.put("Isuzu", 0.019);
            pacificPercentages.put("Jaguar", 0.02);
            pacificPercentages.put("Jeep", 0.021);
            pacificPercentages.put("Kia", 0.022);
            pacificPercentages.put("Land Rover", 0.023);
            pacificPercentages.put("Lexus", 0.024);
            pacificPercentages.put("Mazda", 0.025);
            pacificPercentages.put("Mercedes-Benz", 0.026);
            pacificPercentages.put("MINI", 0.027);
            pacificPercentages.put("Mitsubishi", 0.018);
            pacificPercentages.put("Nissan", 0.019);
            pacificPercentages.put("Perodua", 0.02);
            pacificPercentages.put("Peugeot", 0.021);
            pacificPercentages.put("Proton", 0.022);
            pacificPercentages.put("Subaru", 0.023);
            pacificPercentages.put("Suzuki", 0.024);
            pacificPercentages.put("Toyota", 0.025);
            pacificPercentages.put("Volkswagen", 0.026);
            pacificPercentages.put("Volvo", 0.027);
            companyVehicleMakePercentages.put("Pacific", pacificPercentages);

            // Define the percentages for Liberty
            Map<String, Double> libertyPercentages = new HashMap<>();
            libertyPercentages.put("Alfa Romeo", 0.021);
            libertyPercentages.put("Audi", 0.022);
            libertyPercentages.put("BMW", 0.023);
            libertyPercentages.put("Borgward", 0.018);
            libertyPercentages.put("Chery", 0.019);
            libertyPercentages.put("Chevrolet", 0.024);
            libertyPercentages.put("Citroen", 0.025);
            libertyPercentages.put("Ford", 0.026);
            libertyPercentages.put("Honda", 0.027);
            libertyPercentages.put("Hyundai", 0.028);
            libertyPercentages.put("Infiniti", 0.017);
            libertyPercentages.put("Isuzu", 0.018);
            libertyPercentages.put("Jaguar", 0.019);
            libertyPercentages.put("Jeep", 0.02);
            libertyPercentages.put("Kia", 0.021);
            libertyPercentages.put("Land Rover", 0.022);
            libertyPercentages.put("Lexus", 0.023);
            libertyPercentages.put("Mazda", 0.024);
            libertyPercentages.put("Mercedes-Benz", 0.025);
            libertyPercentages.put("MINI", 0.026);
            libertyPercentages.put("Mitsubishi", 0.028);
            libertyPercentages.put("Nissan", 0.029);
            libertyPercentages.put("Perodua", 0.031);
            libertyPercentages.put("Peugeot", 0.027);
            libertyPercentages.put("Proton", 0.033);
            libertyPercentages.put("Subaru", 0.022);
            libertyPercentages.put("Suzuki", 0.023);
            libertyPercentages.put("Toyota", 0.024);
            libertyPercentages.put("Volkswagen", 0.025);
            libertyPercentages.put("Volvo", 0.026);
            companyVehicleMakePercentages.put("Liberty", libertyPercentages);

            // Define the percentages for Zurich
            Map<String, Double> zurichPercentages = new HashMap<>();
            zurichPercentages.put("Alfa Romeo", 0.026);
            zurichPercentages.put("Audi", 0.027);
            zurichPercentages.put("BMW", 0.028);
            zurichPercentages.put("Borgward", 0.019);
            zurichPercentages.put("Chery", 0.020);
            zurichPercentages.put("Chevrolet", 0.029);
            zurichPercentages.put("Citroen", 0.030);
            zurichPercentages.put("Ford", 0.031);
            zurichPercentages.put("Honda", 0.032);
            zurichPercentages.put("Hyundai", 0.022);
            zurichPercentages.put("Infiniti", 0.021);
            zurichPercentages.put("Isuzu", 0.022);
            zurichPercentages.put("Jaguar", 0.023);
            zurichPercentages.put("Jeep", 0.024);
            zurichPercentages.put("Kia", 0.025);
            zurichPercentages.put("Land Rover", 0.026);
            zurichPercentages.put("Lexus", 0.027);
            zurichPercentages.put("Mazda", 0.028);
            zurichPercentages.put("Mercedes-Benz", 0.029);
            zurichPercentages.put("MINI", 0.030);
            zurichPercentages.put("Mitsubishi", 0.031);
            zurichPercentages.put("Nissan", 0.032);
            zurichPercentages.put("Perodua", 0.033);
            zurichPercentages.put("Peugeot", 0.034);
            zurichPercentages.put("Proton", 0.035);
            zurichPercentages.put("Subaru", 0.036);
            zurichPercentages.put("Suzuki", 0.037);
            zurichPercentages.put("Toyota", 0.038);
            zurichPercentages.put("Volkswagen", 0.039);
            zurichPercentages.put("Volvo", 0.040);
            companyVehicleMakePercentages.put("Zurich", zurichPercentages);

            // Define the percentages for Generaly
            Map<String, Double> generalyPercentages = new HashMap<>();
            generalyPercentages.put("Alfa Romeo", 0.025);
            generalyPercentages.put("Audi", 0.026);
            generalyPercentages.put("BMW", 0.027);
            generalyPercentages.put("Borgward", 0.018);
            generalyPercentages.put("Chery", 0.019);
            generalyPercentages.put("Chevrolet", 0.028);
            generalyPercentages.put("Citroen", 0.029);
            generalyPercentages.put("Ford", 0.030);
            generalyPercentages.put("Honda", 0.031);
            generalyPercentages.put("Hyundai", 0.021);
            generalyPercentages.put("Infiniti", 0.020);
            generalyPercentages.put("Isuzu", 0.021);
            generalyPercentages.put("Jaguar", 0.022);
            generalyPercentages.put("Jeep", 0.023);
            generalyPercentages.put("Kia", 0.024);
            generalyPercentages.put("Land Rover", 0.025);
            generalyPercentages.put("Lexus", 0.026);
            generalyPercentages.put("Mazda", 0.027);
            generalyPercentages.put("Mercedes-Benz", 0.028);
            generalyPercentages.put("MINI", 0.029);
            generalyPercentages.put("Mitsubishi", 0.030);
            generalyPercentages.put("Nissan", 0.031);
            generalyPercentages.put("Perodua", 0.032);
            generalyPercentages.put("Peugeot", 0.033);
            generalyPercentages.put("Proton", 0.034);
            generalyPercentages.put("Subaru", 0.035);
            generalyPercentages.put("Suzuki", 0.036);
            generalyPercentages.put("Toyota", 0.037);
            generalyPercentages.put("Volkswagen", 0.038);
            generalyPercentages.put("Volvo", 0.039);
            companyVehicleMakePercentages.put("Generaly", generalyPercentages);

            // Iterate over each company in companyVehicleMakePercentages
            for (Map.Entry<String, Map<String, Double>> entry : companyVehicleMakePercentages.entrySet()) {
                String companyName = entry.getKey();
                Map<String, Double> percentagesForCompany = entry.getValue();

                // Find the percentage for the selected vehicle make for this company
                Double companyPercentage = percentagesForCompany.get(vehicleMake);

                // If the percentage is found for the selected make, calculate the insurance price for this company
                if (companyPercentage != null) {
                    double companyTotalPremium = finalTotalPremium * (1 + companyPercentage);

                    // Format the insurance price
                    String formattedCompanyTotalPremium = df.format(companyTotalPremium);

                    // Display insurance price for the current company
                    out.println("<h3>" + companyName + "</h3>");
                    out.println("<p>Insurance Price: RM " + formattedCompanyTotalPremium + "</p>");
                } else {
                    // If percentage not found for the selected make, display a message
                    out.println("<h3>" + companyName + "</h3>");
                    out.println("<p>No insurance price available for selected vehicle make.</p>");
                }
            }
        %>

    </body>
</html>
