<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.text.DateFormatSymbols"%>
<%
    String roles = (String) session.getAttribute("roles");
    String userID = (String) session.getAttribute("userID");
    boolean hasImage = false;

    int approvedPayments = 0;
    int rejectedPayments = 0;
    int pendingPayments = 0;

    int solvedQuotations = 0;
    int pendingQuotations = 0;

    int notified = 0;
    int notNotified = 0;

    Map<String, Double> monthlyTotalPrices = new HashMap<>();
    Map<String, Double> monthlyTotalProfits = new HashMap<>();
    Map<String, Integer> monthlyRegistrations = new LinkedHashMap<>();

    int verySatisfied = 0;
    int satisfied = 0;
    int neutral = 0;
    int dissatisfied = 0;
    int veryDissatisfied = 0;

    double avgRenewalTime = 0;
    double customerSatisfactionRate = 0;
    double retentionRate = 0;
    Map<String, Integer> reasonsForNonRenewal = new HashMap<>();
    reasonsForNonRenewal.put("Price Increase", 0);
    reasonsForNonRenewal.put("Better Offer from Competitor", 0);
    reasonsForNonRenewal.put("Customer Relocation", 0);
    reasonsForNonRenewal.put("Service Issues", 0);
    reasonsForNonRenewal.put("Vehicle Sale", 0);

    Map<String, Integer> paymentMethods = new HashMap<>();
    paymentMethods.put("Credit Card", 0);
    paymentMethods.put("Bank Transfer", 0);
    paymentMethods.put("Cash", 0);

    if (userID != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/irs", "root", "admin");

            // Check if user has uploaded an image
            PreparedStatement psImage = con.prepareStatement("SELECT profileIMG FROM manager WHERE userID = ?");
            psImage.setString(1, userID);
            ResultSet rsImage = psImage.executeQuery();
            if (rsImage.next()) {
                hasImage = rsImage.getBlob("profileIMG") != null;
            }

            // Fetch payment status counts
            PreparedStatement psPayment = con.prepareStatement("SELECT paymentStatus, COUNT(*) AS count FROM PaymentHistory GROUP BY paymentStatus");
            ResultSet rsPayment = psPayment.executeQuery();
            while (rsPayment.next()) {
                String status = rsPayment.getString("paymentStatus");
                int count = rsPayment.getInt("count");
                if ("Approved".equalsIgnoreCase(status)) {
                    approvedPayments = count;
                } else if ("Rejected".equalsIgnoreCase(status)) {
                    rejectedPayments = count;
                } else if ("Pending".equalsIgnoreCase(status)) {
                    pendingPayments = count;
                }
            }

            // Fetch quotation status counts
            PreparedStatement psQuotation = con.prepareStatement("SELECT notification_sent, cover_note IS NOT NULL AS coverNoteUploaded, COUNT(*) AS count FROM QuotationHistory GROUP BY notification_sent, cover_note IS NOT NULL");
            ResultSet rsQuotation = psQuotation.executeQuery();
            while (rsQuotation.next()) {
                boolean notificationSent = rsQuotation.getBoolean("notification_sent");
                boolean coverNoteUploaded = rsQuotation.getBoolean("coverNoteUploaded");
                int count = rsQuotation.getInt("count");
                if (notificationSent || coverNoteUploaded) {
                    solvedQuotations += count;
                } else {
                    pendingQuotations += count;
                }
            }

            // Fetch total prices per month
            PreparedStatement psTotalPrice = con.prepareStatement("SELECT DATE_FORMAT(date_submitted, '%Y-%m') AS month, SUM(price) AS total FROM PaymentHistory GROUP BY month");
            ResultSet rsTotalPrice = psTotalPrice.executeQuery();
            while (rsTotalPrice.next()) {
                String month = rsTotalPrice.getString("month");
                double total = rsTotalPrice.getDouble("total");
                double profit = total * 0.1; // Calculate 10% profit
                monthlyTotalPrices.put(month, total);
                monthlyTotalProfits.put(month, profit);
            }

            // Fetch notification status counts
            PreparedStatement psNotification = con.prepareStatement("SELECT notification_sent, COUNT(*) AS count FROM QuotationHistory GROUP BY notification_sent");
            ResultSet rsNotification = psNotification.executeQuery();
            while (rsNotification.next()) {
                if (rsNotification.getBoolean("notification_sent")) {
                    notified = rsNotification.getInt("count");
                } else {
                    notNotified = rsNotification.getInt("count");
                }
            }

            // Fetch customer engagement data
            PreparedStatement psEngagement = con.prepareStatement("SELECT DATE_FORMAT(registration_date, '%Y-%m') AS month, COUNT(*) AS count FROM customer GROUP BY month ORDER BY month");
            ResultSet rsEngagement = psEngagement.executeQuery();
            while (rsEngagement.next()) {
                String month = rsEngagement.getString("month");
                int count = rsEngagement.getInt("count");
                monthlyRegistrations.put(month, count);
            }

            // Fetch customer satisfaction data
            PreparedStatement psSatisfaction = con.prepareStatement("SELECT rating, COUNT(*) AS count FROM feedback GROUP BY rating");
            ResultSet rsSatisfaction = psSatisfaction.executeQuery();
            while (rsSatisfaction.next()) {
                int rating = rsSatisfaction.getInt("rating");
                int count = rsSatisfaction.getInt("count");
                switch (rating) {
                    case 5:
                        verySatisfied = count;
                        break;
                    case 4:
                        satisfied = count;
                        break;
                    case 3:
                        neutral = count;
                        break;
                    case 2:
                        dissatisfied = count;
                        break;
                    case 1:
                        veryDissatisfied = count;
                        break;
                }
            }

            // Fetch average renewal time
            PreparedStatement psAvgRenewalTime = con.prepareStatement("SELECT AVG(DATEDIFF(renewal_date, start_date)) AS avgRenewalTime FROM renewals WHERE renewal_date IS NOT NULL");
            ResultSet rsAvgRenewalTime = psAvgRenewalTime.executeQuery();
            if (rsAvgRenewalTime.next()) {
                avgRenewalTime = rsAvgRenewalTime.getDouble("avgRenewalTime");
            }

            // Fetch customer satisfaction rate
            PreparedStatement psCustomerSatisfaction = con.prepareStatement("SELECT (COUNT(CASE WHEN rating >= 4 THEN 1 END) / COUNT(*)) * 100 AS satisfactionRate FROM feedback");
            ResultSet rsCustomerSatisfaction = psCustomerSatisfaction.executeQuery();
            if (rsCustomerSatisfaction.next()) {
                customerSatisfactionRate = rsCustomerSatisfaction.getDouble("satisfactionRate");
            }

            // Fetch retention rate
            PreparedStatement psRetentionRate = con.prepareStatement("SELECT (COUNT(DISTINCT customerID) / (SELECT COUNT(DISTINCT customerID) FROM customers)) * 100 AS retentionRate FROM renewals WHERE renewal_date IS NOT NULL");
            ResultSet rsRetentionRate = psRetentionRate.executeQuery();
            if (rsRetentionRate.next()) {
                retentionRate = rsRetentionRate.getDouble("retentionRate");
            }

            // Fetch top reasons for non-renewal
            PreparedStatement psNonRenewalReasons = con.prepareStatement("SELECT reason, COUNT(*) AS count FROM non_renewals GROUP BY reason");
            ResultSet rsNonRenewalReasons = psNonRenewalReasons.executeQuery();
            while (rsNonRenewalReasons.next()) {
                String reason = rsNonRenewalReasons.getString("reason");
                int count = rsNonRenewalReasons.getInt("count");
                reasonsForNonRenewal.put(reason, count);
            }

            // Fetch most common payment methods
            PreparedStatement psPaymentMethods = con.prepareStatement("SELECT method, COUNT(*) AS count FROM payments GROUP BY method");
            ResultSet rsPaymentMethods = psPaymentMethods.executeQuery();
            while (rsPaymentMethods.next()) {
                String method = rsPaymentMethods.getString("method");
                int count = rsPaymentMethods.getInt("count");
                paymentMethods.put(method, count);
            }

        } catch (SQLException e) {
            // Handle SQLException (print or log the error)
            e.printStackTrace();
        }
    } else {
        // Handle the case where userID is not found in the session
        out.println("UserID not found in the session.");
    }

    DateFormatSymbols dfs = new DateFormatSymbols();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
        <title>Manage Reports</title>
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <link rel="stylesheet" href="CSS/managerDash.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
    </head>
    <body>
        <div class="wrapper">
            <div class="body-overlay"></div>
            <div id="sidebar">
                <div class="sidebar-header">
                    <h3><img src="IMG/IRS.png" class="img-fluid" /><span>GuardWheels : IRS</span></h3>
                </div>
                <ul class="list-unstyled component m-0">
                    <li class=""><a href="adminDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard </a></li>
                    <li class=""><a href="adminProfile.jsp" class=""><i class="material-icons">account_circle</i>Profile</a></li>
                    <li class="dropdown">
                        <a href="#homeSubmenu1" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <i class="material-icons">border_color</i>Manage Account</a>
                        <ul class="collapse list-unstyled menu" id="homeSubmenu1">
                            <li><a href="customerList.jsp">Customer</a></li>
                            <li><a href="staffList.jsp">Staff</a></li>
                            <li><a href="managerList.jsp">Manager</a></li>
                        </ul>
                    </li>
                    <li class="active"><a href="adminReport.jsp" class=""><i class="material-icons">library_books</i>Report</a></li>
                    <li class=""><a href="homePage.jsp" class=""><i class="material-icons">power_settings_new</i>Sign Out</a></li>
                </ul>
            </div>

            <div id="content">
                <div class="top-navbar">
                    <div class="xd-topbar">
                        <div class="row">
                            <div class="col-2 col-md-1 col-lg-1 order-2 order-md-1 align-self-center">
                                <div class="xp-menubar"><span class="material-icons text-white">signal_cellular_alt</span></div>
                            </div>
                            <div class="col-md-5 col-lg-3 order-3 order-md-2"></div>
                            <div class="col-10 col-md-6 col-lg-8 order-1 order-md-3">
                                <div class="xp-profilebar text-right">
                                    <nav class="navbar p-0">
                                        <ul class="nav navbar-nav flex-row ml-auto">
                                            <li class="dropdown nav-item"><a class="nav-link" href="#" data-toggle="dropdown"><span class="material-icons">notifications</span></a></li>
                                            <li class="dropdown nav-item"><a class="nav-link" href="managerProfile.jsp">
                                                    <img src="<%= hasImage ? "getImage?userID=" + userID + "&roles=" + roles : "IMG/avatar.jpg"%>" style="width:40px; height:40px; border-radius:50%;" />
                                                    <span class="xp-user-live"></span></a></li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                        <div class="xp-breadcrumbbar text-center">
                            <h4 class="page-title">Report</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Admin</a></li>
                            </ol>
                        </div>
                    </div>
                </div>

                <div class="main-content">
                    <div class="container mt-5">
                        <h1>Vehicle Insurance Renewal Report</h1>

                        <button class="btn btn-primary" onclick="generatePDF()">Generate PDF</button>
                    </div>
                </div>
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="footer-in"><p class="mb-0">&copy; 2024 RAZ WAWASAN SDN BHD (ADLI YONG)</p></div>
                    </div>
                </footer>
            </div>
        </div>

        <script src="JS/jquery-3.3.1.slim.min.js"></script>
        <script src="JS/popper.min.js"></script>
        <script src="JS/bootstrap.min.js"></script>
        <script src="JS/jquery-3.3.1.min.js"></script>
        <script>
                            $(document).ready(function () {
                                $(".xp-menubar").on('click', function () {
                                    $("#sidebar").toggleClass('active');
                                    $("#content").toggleClass('active');
                                });

                                $('.xp-menubar,.body-overlay').on('click', function () {
                                    $("#sidebar,.body-overlay").toggleClass('show-nav');
                                });
                            });

                            async function generatePDF() {
                                const {jsPDF} = window.jspdf;
                                const doc = new jsPDF();

                                const pageWidth = doc.internal.pageSize.getWidth();
                                const pageHeight = doc.internal.pageSize.getHeight();
                                const margin = 10;
                                const maxLineWidth = pageWidth - 2 * margin;
                                const lineHeight = 10;
                                let yPosition = margin;

                                const addText = async (text, fontSize, isBold) => {
                                    if (isBold) {
                                        doc.setFont("helvetica", "bold");
                                    }
                                    doc.setFontSize(fontSize);
                                    const lines = doc.splitTextToSize(text, maxLineWidth);
                                    for (const line of lines) {
                                        if (yPosition + lineHeight > pageHeight - margin) {
                                            doc.addPage();
                                            await addBackgroundImage();
                                            yPosition = margin;
                                        }
                                        doc.text(line, margin, yPosition);
                                        yPosition += lineHeight;
                                    }
                                    doc.setFont("helvetica", "normal");
                                };

                                const addBackgroundImage = async () => {
                                    const img = new Image();
                                    img.src = 'IMG/IRS2.png'; // Path to your background image
                                    await new Promise(resolve => img.onload = resolve);

                                    const imgWidth = 150;
                                    const imgHeight = 150;
                                    const xOffset = (pageWidth - imgWidth) / 2; // Center horizontally
                                    const yOffset = (pageHeight - imgHeight) / 2; // Center vertically

                                    doc.addImage(img, 'PNG', xOffset, yOffset, imgWidth, imgHeight, '', 'NONE', 0.1); // Set opacity to 10%
                                };

                                await addBackgroundImage();

                                await addText("Vehicle Insurance Renewal Report", 22, true);
                                await addText("Insurance Renewal Summary", 16, true);
                                await addText("Here is the vehicle insurance renewal report which provides an overview of all renewals processed, upcoming expiries, and other relevant details for efficient management.", 12, false);

                                await addText("Payment Status", 14, true);
                                await addText(`Approved Payments: {<%= approvedPayments%>}`, 12, false);
                                await addText(`Rejected Payments: {<%= rejectedPayments%>}`, 12, false);
                                await addText(`Pending Payments: {<%= pendingPayments%>}`, 12, false);

                                await addText("Quotation Status", 14, true);
                                await addText(`Solved Quotations: {<%= solvedQuotations%>}`, 12, false);
                                await addText(`Pending Quotations: {<%= pendingQuotations%>}`, 12, false);

                                await addText("Total Price and Profit Per Month", 14, true);
            <% for (Map.Entry<String, Double> entry : monthlyTotalPrices.entrySet()) {
                    String[] parts = entry.getKey().split("-");
                    String monthName = dfs.getMonths()[Integer.parseInt(parts[1]) - 1];
                    String formattedMonth = monthName + " " + parts[0];
            %>
                                await addText(`<%= formattedMonth%>: Total Price - <%= entry.getValue()%>, Profit - <%= monthlyTotalProfits.get(entry.getKey())%>`, 12, false);
            <% }%>

                                        await addText("Customer Notifications", 14, true);
                                        await addText(`Notified: {<%= notified%>}`, 12, false);
                                        await addText(`Not Notified: {<%= notNotified%>}`, 12, false);

                                        await addText("Customer Engagement", 14, true);
            <% for (Map.Entry<String, Integer> entry : monthlyRegistrations.entrySet()) {
                    String[] parts = entry.getKey().split("-");
                    String monthName = dfs.getMonths()[Integer.parseInt(parts[1]) - 1];
                    String formattedMonth = monthName + " " + parts[0];
            %>
                                        await addText(`<%= formattedMonth%>: {<%= entry.getValue()%>} registrations`, 12, false);
            <% }%>

                                        await addText("Customer Satisfaction", 14, true);
                                        await addText(`Very Satisfied: {<%= verySatisfied%>}`, 12, false);
                                        await addText(`Satisfied: {<%= satisfied%>}`, 12, false);
                                        await addText(`Neutral: {<%= neutral%>}`, 12, false);
                                        await addText(`Dissatisfied: {<%= dissatisfied%>}`, 12, false);
                                        await addText(`Very Dissatisfied: {<%= veryDissatisfied%>}`, 12, false);

//                                        await addText("Advanced Data and Insights", 14, true);
//                                        await addText(`Average Renewal Time: {<%= avgRenewalTime%>} days`, 12, false);
//                                        await addText(`Customer Satisfaction Rate: {<%= customerSatisfactionRate%>} %`, 12, false);
//                                        await addText(`Retention Rate: {<%= retentionRate%>} %`, 12, false);
//                                        await addText("Top 5 Reasons for Non-Renewal:", 12, false);
//                                        await addText(`- Price Increase: ${reasonsForNonRenewal.get("Price Increase")}`, 12, false);
//                                        await addText(`- Better Offer from Competitor: ${reasonsForNonRenewal.get("Better Offer from Competitor")}`, 12, false);
//                                        await addText(`- Customer Relocation: ${reasonsForNonRenewal.get("Customer Relocation")}`, 12, false);
//                                        await addText(`- Service Issues: ${reasonsForNonRenewal.get("Service Issues")}`, 12, false);
//                                        await addText(`- Vehicle Sale: ${reasonsForNonRenewal.get("Vehicle Sale")}`, 12, false);
//                                        await addText("Most Common Payment Methods:", 12, false);
//                                        await addText(`- Credit Card: ${paymentMethods.get("Credit Card")} %`, 12, false);
//                                        await addText(`- Bank Transfer: ${paymentMethods.get("Bank Transfer")} %`, 12, false);
//                                        await addText(`- Cash: ${paymentMethods.get("Cash")} %`, 12, false);
//
//                                        await addText("Key Performance Indicators (KPIs)", 14, true);
//                                        await addText("Monthly Renewal Rate: 78%", 12, false);
//                                        await addText("Policy Lapse Rate: 6%", 12, false);
//                                        await addText("New Customer Acquisition: 25", 12, false);
//                                        await addText("Average Premium per Customer: $208", 12, false);

                                        await addText("Actionable Insights", 14, true);
                                        await addText("To improve the renewal rate and customer satisfaction, consider the following actions:", 12, false);
                                        await addText("- Implement a customer loyalty program to incentivize renewals.", 12, false);
                                        await addText("- Offer flexible payment plans to accommodate different customer needs.", 12, false);
                                        await addText("- Enhance customer service training to address service-related non-renewals.", 12, false);
                                        await addText("- Review and adjust pricing strategies based on competitive analysis.", 12, false);

                                        doc.save('Vehicle_Insurance_Renewal_Report.pdf');
                                    }
        </script>
    </body>
</html>
