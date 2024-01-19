<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="CSS/newPassword.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
        <title>New Password Page</title>
    </head>
    <body>
        <div class="pass-div">
            <div class="logo">
                <img src="IMG/IRS.png" alt="" width="150">
            </div>

            <div class="title">GuardWheels</div>
            <div class="sub-title">Insurance Renewal System</div>
            <%
                if (request.getAttribute("message") != null) {
                    out.print("<p class='text-danger'>" + request.getAttribute("message") + "</p>");
                }
            %>
            <form  id="register-form" action="newPassword" role="form" autocomplete="off"
                   class="form" method="post">
                <div class="newPass">
                    <svg class="svg-icon" viewBox="0 0 20 20">
                    <path
                        d="M17.388,4.751H2.613c-0.213,0-0.389,0.175-0.389,0.389v9.72c0,0.216,0.175,0.389,0.389,0.389h14.775c0.214,0,0.389-0.173,0.389-0.389v-9.72C17.776,4.926,17.602,4.751,17.388,4.751 M16.448,5.53L10,11.984L3.552,5.53H16.448zM3.002,6.081l3.921,3.925l-3.921,3.925V6.081z M3.56,14.471l3.914-3.916l2.253,2.253c0.153,0.153,0.395,0.153,0.548,0l2.253-2.253l3.913,3.916H3.56z M16.999,13.931l-3.921-3.925l3.921-3.925V13.931z">
                    </path>
                    </svg>
                    <input id="newPassword" name="newPassword" placeholder="New Password"
                           class="" type="password" required="required">
                </div>
                <div class="confNewPass">
                    <svg class="svg-icon" viewBox="0 0 20 20">
                    <path
                        d="M17.388,4.751H2.613c-0.213,0-0.389,0.175-0.389,0.389v9.72c0,0.216,0.175,0.389,0.389,0.389h14.775c0.214,0,0.389-0.173,0.389-0.389v-9.72C17.776,4.926,17.602,4.751,17.388,4.751 M16.448,5.53L10,11.984L3.552,5.53H16.448zM3.002,6.081l3.921,3.925l-3.921,3.925V6.081z M3.56,14.471l3.914-3.916l2.253,2.253c0.153,0.153,0.395,0.153,0.548,0l2.253-2.253l3.913,3.916H3.56z M16.999,13.931l-3.921-3.925l3.921-3.925V13.931z">
                    </path>
                    </svg>
                    <input  id="confirmPassword" name="confirmPassword"
                            placeholder="Confirm New Password" class=""
                            type="password" required="required">
                </div>
                <input type="submit" class="reset-btn" id="submit" value="RESET PASSWORD">
<!--                <div class="form-group">
                    <button name="reset-submit" class="btn btn-reset" type="submit">RESET PASSWORD</button>
                </div>-->
                <input type="hidden" class="hide" name="token" id="token" value="">
            </form>
        </div>
    </body>
</html>
