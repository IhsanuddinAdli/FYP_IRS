<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Date"%>
<%@page import="com.dao.DBConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quotation Details</title>
    </head>
    <body>
        <%
            // Retrieve quotation ID from request parameter
            int quotationId = Integer.parseInt(request.getParameter("quotationId"));

            // Initialize variables for data retrieval
            String vehicleType = "";
            String coverage = "";
            String ownerName = "";
            String ownerId = "";
            String dob = "";
            String gender = "";
            String maritalStatus = "";
            String location = "";
            String localImport = "";
            String registrationNumber = "";
            String engineNumber = "";
            String chassisNumber = "";
            double insuredValue = 0.0;
            String vehicleBody = "";
            String vehicleMake = "";
            String vehicleModel = "";
            int manufactureYear = 0;
            int engineCapacity = 0;
            double windscreenCost = 0.0;
            double allDriverCost = 0.0;
            double specialPerilsCost = 0.0;
            double legalLiabilityCost = 0.0;
            Date policyCommencementDate = null;
            int policyDuration = 0;
            Date policyExpiryDate = null;
            String selectedNcd = ""; // Changed to String

            // Initialize connection and prepared statement
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                // Establish database connection
                conn = DBConnection.getConnection();

                // Prepare SQL statement to retrieve data based on quotation ID
                String sql = "SELECT q.quotation_id, q.userID, q.coverage, q.policy_commencement_date, q.policy_duration, q.policy_expiry_date, q.selected_ncd, "
                        + "v.owner_name, v.owner_id, v.dob, v.gender, v.marital_status, v.location, v.vehicle_type, v.local_import, "
                        + "v.registration_number, v.engine_number, v.chassis_number, v.insured_value, v.vehicle_body, v.vehicle_make, "
                        + "v.vehicle_model, v.manufacture_year, v.engine_capacity, "
                        + "a.windscreen_cost, a.all_driver_cost, a.special_perils_cost, a.legal_liability_cost "
                        + "FROM Quotation q "
                        + "INNER JOIN Vehicle v ON q.quotation_id = v.quotation_id "
                        + "LEFT JOIN Addons a ON q.quotation_id = a.quotation_id "
                        + "WHERE q.quotation_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, quotationId);

                // Execute the query
                ResultSet rs = pstmt.executeQuery();

                // Check if a row is found
                if (rs.next()) {
                    // Retrieve data
                    vehicleType = rs.getString("vehicle_type");
                    coverage = rs.getString("coverage");
                    ownerName = rs.getString("owner_name");
                    ownerId = rs.getString("owner_id");
                    dob = rs.getString("dob");
                    gender = rs.getString("gender");
                    maritalStatus = rs.getString("marital_status");
                    location = rs.getString("location");
                    localImport = rs.getString("local_import");
                    registrationNumber = rs.getString("registration_number");
                    engineNumber = rs.getString("engine_number");
                    chassisNumber = rs.getString("chassis_number");
                    insuredValue = rs.getDouble("insured_value");
                    vehicleBody = rs.getString("vehicle_body");
                    vehicleMake = rs.getString("vehicle_make");
                    vehicleModel = rs.getString("vehicle_model");
                    manufactureYear = rs.getInt("manufacture_year");
                    engineCapacity = rs.getInt("engine_capacity");
                    windscreenCost = rs.getDouble("windscreen_cost");
                    allDriverCost = rs.getDouble("all_driver_cost");
                    specialPerilsCost = rs.getDouble("special_perils_cost");
                    legalLiabilityCost = rs.getDouble("legal_liability_cost");
                    policyCommencementDate = rs.getDate("policy_commencement_date");
                    policyDuration = rs.getInt("policy_duration");
                    policyExpiryDate = rs.getDate("policy_expiry_date");
                    selectedNcd = rs.getString("selected_ncd"); // Changed to String
                } else {
                    // Handle case where no data is found for the given quotation ID
                    out.println("No data found for the given quotation ID.");
                }

                // Close the result set
                rs.close();
            } catch (SQLException e) {
                // Handle SQL exception
                e.printStackTrace();
            } finally {
                // Close prepared statement and connection
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }

            // Set attributes to pass to the redirected page
            // Quotation table attributes
            request.setAttribute("quotationId", quotationId);
            request.setAttribute("coverage", coverage);
            request.setAttribute("policyCommencementDate", policyCommencementDate);
            request.setAttribute("policyDuration", policyDuration);
            request.setAttribute("policyExpiryDate", policyExpiryDate);
            request.setAttribute("selectedNcd", selectedNcd);

            // Vehicle table attributes
            request.setAttribute("vehicleType", vehicleType);
            request.setAttribute("ownerName", ownerName);
            request.setAttribute("ownerId", ownerId);
            request.setAttribute("dob", dob);
            request.setAttribute("gender", gender);
            request.setAttribute("maritalStatus", maritalStatus);
            request.setAttribute("location", location);
            request.setAttribute("localImport", localImport);
            request.setAttribute("registrationNumber", registrationNumber);
            request.setAttribute("engineNumber", engineNumber);
            request.setAttribute("chassisNumber", chassisNumber);
            request.setAttribute("insuredValue", insuredValue);
            request.setAttribute("vehicleBody", vehicleBody);
            request.setAttribute("vehicleMake", vehicleMake);
            request.setAttribute("vehicleModel", vehicleModel);
            request.setAttribute("manufactureYear", manufactureYear);
            request.setAttribute("engineCapacity", engineCapacity);

            // Addons table attributes
            request.setAttribute("windscreenCost", windscreenCost);
            request.setAttribute("allDriverCost", allDriverCost);
            request.setAttribute("specialPerilsCost", specialPerilsCost);
            request.setAttribute("legalLiabilityCost", legalLiabilityCost);

            // Redirect to the customerFormQuo.jsp page
            String redirectUrl = "customerQuoForm.jsp";
            // Dispatch the request to the redirected page
            RequestDispatcher dispatcher = request.getRequestDispatcher(redirectUrl);
            dispatcher.forward(request, response);
        %>
    </body>
</html>
