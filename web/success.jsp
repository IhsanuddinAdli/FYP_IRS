<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Success Page</title>
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <div class="alert alert-success" role="alert">
                <h4 class="alert-heading">Payment Successful!</h4>
                <p>Your payment has been successfully processed. Thank you for your purchase!</p>
                <!--<p>Quotation ID: <%= request.getAttribute("quotationId")%></p>-->
                <button onclick="redirectToDataTransferServlet()" class="btn btn-primary">View the purchase list</button>
            </div>
        </div>
        <script>
            function redirectToDataTransferServlet() {
                var quotationId = <%= request.getAttribute("quotationId")%>;
                window.location.href = "transferData?quotationId=" + quotationId;
            }
        </script>
    </body>
</html>
