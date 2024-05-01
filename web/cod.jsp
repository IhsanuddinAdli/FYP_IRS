<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cash on Delivery (COD) Page</title>
    </head>
    <body>
        <h1>Cash on Delivery (COD)</h1>
        <p>Thank you for choosing Cash on Delivery (COD) as your payment option.</p>
        <%
            String finalTotalPremium = request.getParameter("finalTotalPremium");
            double totalPremiumWithCOD = 0.0;
            if (finalTotalPremium != null) {
                // Add RM10 for Cash on Delivery
                totalPremiumWithCOD = Double.parseDouble(finalTotalPremium) + 10.0;
        %>
        <p>Your insurance price is: RM <%= finalTotalPremium%></p>
        <p>Additional RM10 for Cash on Delivery: RM 10.00</p>
        <p>Total amount payable: RM <%= String.format("%.2f", totalPremiumWithCOD)%></p>
        <% } else { %>
        <p>Unable to retrieve insurance price.</p>
        <% }%>
        <p>Please wait for our delivery agent to collect payment when your order is delivered.</p>
    </body>
</html>
