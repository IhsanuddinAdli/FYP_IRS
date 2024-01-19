<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Forgot Password Page</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="CSS/forgotPassword.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    </head>

    <body oncontextmenu="return false" class="snippet-body">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <div class="forgot-div">
                        <div class="logo">
                            <img src="IMG/IRS.png" alt="" width="150">
                        </div>
                        <div class="title">GuardWheels</div>
                        <div class="sub-title">Insurance Renewal System</div>
                        <form class="form" action="forgotPassword" method="POST">
                            <div class="email">
                                <svg class="svg-icon" viewBox="0 0 20 20">
                                <path
                                    d="M17.388,4.751H2.613c-0.213,0-0.389,0.175-0.389,0.389v9.72c0,0.216,0.175,0.389,0.389,0.389h14.775c0.214,0,0.389-0.173,0.389-0.389v-9.72C17.776,4.926,17.602,4.751,17.388,4.751 M16.448,5.53L10,11.984L3.552,5.53H16.448zM3.002,6.081l3.921,3.925l-3.921,3.925V6.081z M3.56,14.471l3.914-3.916l2.253,2.253c0.153,0.153,0.395,0.153,0.548,0l2.253-2.253l3.913,3.916H3.56z M16.999,13.931l-3.921-3.925l3.921-3.925V13.931z">
                                </path>
                                </svg>
                                <input class="" type="text" name="email" id="email" id="email-for-pass" placeholder="Email" required>
                            </div>
                            <div id="emailHelp" class="form-text">Enter the registered email address. We'll email an OTP to this address.</div>
                            <div class="card-footer">
                                <button class="btn btn-success newPass-btn" type="submit">Get New Password</button>
                                <button class="btn btn-danger" type="button" onclick="redirectToLogin()">Back to Login</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                    function redirectToLogin() {
                                        window.location.href = 'login.jsp';
                                    }
        </script>
        <script type='text/javascript' src=''></script>
        <script type='text/javascript' src=''></script>
        <script type='text/Javascript'></script>
    </body>

</html>
