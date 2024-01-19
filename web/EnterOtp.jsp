<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="CSS/enterOtp.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
        <title>Enter OTP Page</title>
    </head>

    <body>
        <div class="form-gap"></div>
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <div class="text-center">
                                <div class="card-logo">
                                    <img src="IMG/IRS.png" alt="Logo">
                                </div>
                                <div class="card-title">GuardWheels</div>
                                <div class="card-subtitle">Insurance Renewal System</div>
                                <%
                                    if (request.getAttribute("message") != null) {
                                        out.print("<p class='text-danger'>" + request.getAttribute("message") + "</p>");
                                    }
                                %>
                                <div class="panel-body">
                                    <form id="register-form" action="ValidateOtp" role="form" autocomplete="off"
                                          class="form" method="post">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <span class="input-group-text" id="basic-addon1"><i class="glyphicon glyphicon-envelope color-blue"></i></span>
                                                <input id="otp" name="otp" placeholder="Enter OTP" class="form-control" type="text" required="required">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <button name="recover-submit" class="btn btn-reset" type="submit">Reset Password</button>
                                        </div>
                                        <input type="hidden" class="hide" name="token" id="token" value="">
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>
