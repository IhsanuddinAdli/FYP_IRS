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
        <p>Quotation ID: <%= request.getAttribute("quotationId")%></p>
        <button onclick="redirectToDataTransferServlet()">View the purchase list</button>
        <script>
            function redirectToDataTransferServlet() {
                var quotationId = <%= request.getAttribute("quotationId")%>;
                window.location.href = "transferData?quotationId=" + quotationId;
            }
        </script>
    </body>
</html>
