<%-- 
    Document   : quotation
    Created on : 25 Dec 2023, 10:15:44 AM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Insurance Renewal Quotation</title>
        <link rel="stylesheet" href="styles.css">
    </head>
    <body>

        <div class="quotation-container">
            <h1>Insurance Renewal Quotation</h1>

            <form action="process_quotation.php" method="post">
                <label for="vehicleMake">Vehicle Make:</label>
                <input type="text" id="vehicleMake" name="vehicleMake" required>

                <label for="vehicleModel">Vehicle Model:</label>
                <input type="text" id="vehicleModel" name="vehicleModel" required>

                <label for="manufactureYear">Manufacture Year:</label>
                <input type="number" id="manufactureYear" name="manufactureYear" min="1900" max="2023" required>

                <label for="currentInsurance">Current Insurance Provider:</label>
                <input type="text" id="currentInsurance" name="currentInsurance" required>

                <label for="coverageType">Coverage Type:</label>
                <select id="coverageType" name="coverageType" required>
                    <option value="basic">Basic Coverage</option>
                    <option value="standard">Standard Coverage</option>
                    <option value="premium">Premium Coverage</option>
                </select>

                <button type="submit">Get Quotation</button>
            </form>
        </div>

    </body>
</html>
