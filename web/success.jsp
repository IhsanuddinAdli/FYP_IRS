<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Success Page</title>
    </head>
    <body>
        <h1>Payment Successful!</h1>
        <p>Your payment has been successfully processed. Thank you for your purchase!</p>
        <button onclick="redirectToServlet()">View the purchase list</button>

        <script>
            function redirectToServlet() {
                // Redirect to the servlet with the quotationId parameter
                window.location.href = "transferData?quotationId=<%= request.getAttribute("quotationId")%>";
            }
        </script>
        <p>Quotation ID: <%= request.getAttribute("quotationId")%></p>
    </body>
</html>
