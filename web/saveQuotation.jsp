<%@ page import="java.sql.*, com.dao.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="javax.servlet.*,javax.servlet.http.*" %>

<%
// Retrieve userID from session
    String userID = (String) session.getAttribute("userID");

// Retrieve form data
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
    String vehicleBody = request.getParameter("vehicle-body");
    String vehicleMake = request.getParameter("vehicle-make");
    String vehicleModel = request.getParameter("vehicle-model");
    String manufactureYear = request.getParameter("manufacture-year");
    String policyCommencementDate = request.getParameter("policy-commencement-date");
    String policyDuration = request.getParameter("policy-duration");
    String policyExpiryDate = request.getParameter("policy-expiry-date");
    String selectedNCD = request.getParameter("ncd");
    String engineCapacityStr = request.getParameter("engine-capacity");

// Add-ons
    String windscreenAddon = request.getParameter("windscreen-addon");
    String windscreenPriceStr = request.getParameter("windscreen-price");
    String allDriverAddon = request.getParameter("all-driver-addon");
    String specialPerilsAddon = request.getParameter("special-perils-addon");
    String legalLiabilityAddon = request.getParameter("legal-liability-addon");

// Initialize variables for success and error messages
    String successMessage = "Quotation saved successfully!";
    String errorMessage = "Error occurred while saving quotation.";

    Connection conn = null; // Declaration

    try {
        // Convert string values to appropriate data types
        double insuredValue = 0.0;
        if (insuredValueStr != null && !insuredValueStr.isEmpty()) {
            insuredValue = Double.parseDouble(insuredValueStr);
        }

        int engineCapacity = 0;
        if (engineCapacityStr != null && !engineCapacityStr.isEmpty()) {
            engineCapacity = Integer.parseInt(engineCapacityStr);
        }

        // Establish a connection to the database
        conn = DBConnection.getConnection();

        // Prepare SQL statement for Quotation Table
        String quotationSql = "INSERT INTO quotation (userID, coverage, policy_commencement_date, policy_duration, policy_expiry_date, selected_ncd) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement quotationPstmt = conn.prepareStatement(quotationSql, Statement.RETURN_GENERATED_KEYS);
        quotationPstmt.setString(1, userID);
        quotationPstmt.setString(2, coverage);
        quotationPstmt.setString(3, policyCommencementDate);
        quotationPstmt.setString(4, policyDuration);
        quotationPstmt.setString(5, policyExpiryDate);
        quotationPstmt.setString(6, selectedNCD);
        int quotationRowsAffected = quotationPstmt.executeUpdate();

        // Check if quotation insertion was successful
        if (quotationRowsAffected > 0) {
            // Retrieve the generated quotation ID
            ResultSet generatedKeys = quotationPstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int quotationId = generatedKeys.getInt(1);

                // Prepare SQL statement for Vehicle Table
                String vehicleSql = "INSERT INTO vehicle (quotation_id, owner_name, owner_id, dob, gender, marital_status, location, vehicle_type, local_import, registration_number, engine_number, chassis_number, insured_value, vehicle_body, vehicle_make, vehicle_model, manufacture_year, engine_capacity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement vehiclePstmt = conn.prepareStatement(vehicleSql);
                vehiclePstmt.setInt(1, quotationId);
                vehiclePstmt.setString(2, ownerName);
                vehiclePstmt.setString(3, ownerId);
                vehiclePstmt.setString(4, dob);
                vehiclePstmt.setString(5, gender);
                vehiclePstmt.setString(6, maritalStatus);
                vehiclePstmt.setString(7, location);
                vehiclePstmt.setString(8, vehicleType);
                vehiclePstmt.setString(9, localImport);
                vehiclePstmt.setString(10, registrationNumber);
                vehiclePstmt.setString(11, engineNumber);
                vehiclePstmt.setString(12, chassisNumber);
                vehiclePstmt.setDouble(13, insuredValue);
                vehiclePstmt.setString(14, vehicleBody);
                vehiclePstmt.setString(15, vehicleMake);
                vehiclePstmt.setString(16, vehicleModel);
                vehiclePstmt.setString(17, manufactureYear);
                vehiclePstmt.setInt(18, engineCapacity);
                vehiclePstmt.executeUpdate();

                // Prepare SQL statement for Addons Table
                String addonsSql = "INSERT INTO addons (quotation_id, windscreen_cost, all_driver_cost, special_perils_cost, legal_liability_cost) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement addonsPstmt = conn.prepareStatement(addonsSql);
                addonsPstmt.setInt(1, quotationId);
                addonsPstmt.setDouble(2, windscreenAddon != null ? Double.parseDouble(windscreenPriceStr) : 0.0);
                addonsPstmt.setDouble(3, allDriverAddon != null ? 20.0 : 0.0);
                addonsPstmt.setDouble(4, specialPerilsAddon != null ? 0.0025 * insuredValue : 0.0);
                addonsPstmt.setDouble(5, legalLiabilityAddon != null ? 7.50 : 0.0);
                addonsPstmt.executeUpdate();

                // Set attributes to pass to the redirected page
                request.setAttribute("quotationId", quotationId);
                request.setAttribute("vehicleType", vehicleType);
                request.setAttribute("coverage", coverage);

                // Redirect to the appropriate page based on vehicleType and coverage
                String redirectUrl = "";
                switch (vehicleType) {
                    case "Car":
                        redirectUrl = coverage.equals("comprehensive") ? "carComprehensive.jsp"
                                : coverage.equals("third-party-fire-theft") ? "carTPFT.jsp" : "";
                        break;
                    case "Motorcycle":
                        redirectUrl = coverage.equals("comprehensive") ? "motoComprehensive.jsp"
                                : coverage.equals("third-party-motorcycle") ? "motoTP.jsp" : "";
                        break;
                    case "Van":
                        redirectUrl = coverage.equals("comprehensive") ? "vanComprehensive.jsp"
                                : coverage.equals("third-party-fire-theft") ? "vanTPFT.jsp" : "";
                        break;
                    case "Lorry":
                        redirectUrl = coverage.equals("comprehensive") ? "lorryComprehensive.jsp"
                                : coverage.equals("third-party-fire-theft") ? "lorryTPFT.jsp" : "";
                        break;
                    default:
                        break;
                }
                if (!redirectUrl.isEmpty()) {
                    RequestDispatcher dispatcher = request.getRequestDispatcher(redirectUrl);
                    dispatcher.forward(request, response);
                } else {
                    // Set error message
                    session.setAttribute("message", errorMessage);
                    response.sendRedirect("error.jsp");
                }
            } else {
                // Set error message
                session.setAttribute("message", errorMessage);
                response.sendRedirect("error.jsp");
            }
        } else {
            // Set error message
            session.setAttribute("message", errorMessage);
            response.sendRedirect("error.jsp");
        }

        // Close resources
        quotationPstmt.close();
    } catch (Exception e) {
        // Handle any errors
        e.printStackTrace();
        // Set error message
        session.setAttribute("message", errorMessage);
        response.sendRedirect("error.jsp");
    } finally {
        // Close the connection in the 'finally' block if necessary
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace(); // Handle exceptions
            }
        }
    }
%>
