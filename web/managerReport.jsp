<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.text.DateFormatSymbols"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.LinkedHashMap"%>
<%
    String roles = (String) session.getAttribute("roles");
    String userID = (String) session.getAttribute("userID");
    boolean hasImage = false;

    int notified = 0;
    int notNotified = 0;

    Map<String, Integer> monthlyRegistrations = new LinkedHashMap<>();

    int verySatisfied = 0;
    int satisfied = 0;
    int neutral = 0;
    int dissatisfied = 0;
    int veryDissatisfied = 0;

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

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            out.println("An error occurred while fetching data. Please try again later.");
        }
    } else {
        out.println("UserID not found in the session.");
    }

    // Convert the data for the chart
    StringBuilder months = new StringBuilder();
    StringBuilder counts = new StringBuilder();
    DateFormatSymbols dfs = new DateFormatSymbols();
    for (Map.Entry<String, Integer> entry : monthlyRegistrations.entrySet()) {
        String[] parts = entry.getKey().split("-");
        String monthName = dfs.getMonths()[Integer.parseInt(parts[1]) - 1];
        String formattedMonth = monthName + " " + parts[0];

        if (months.length() > 0) {
            months.append(",");
            counts.append(",");
        }
        months.append("'").append(formattedMonth).append("'");
        counts.append(entry.getValue());
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Manage Reports</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="CSS/bootstrap.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="CSS/managerDash.css">
        <link rel="stylesheet" href="CSS/report.css"> <!-- Add the CSS from above here -->
        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!-- Google Material Icons -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
    </head>
    <body>
        <div class="wrapper">
            <div class="body-overlay"></div>
            <!-- Sidebar design -->
            <div id="sidebar">
                <div class="sidebar-header">
                    <h3><img src="IMG/IRS.png" class="img-fluid" /><span>GuardWheels : IRS</span></h3>
                </div>
                <ul class="list-unstyled component m-0">
                    <li class=""><a href="managerDash.jsp" class="dashboard"><i class="material-icons">dashboard</i>Dashboard</a></li>
                    <li class=""><a href="managerProfile.jsp"><i class="material-icons">account_circle</i>Profile</a></li>
                    <li class=""><a href="customerNotify.jsp"><i class="material-icons">notifications_active</i>Customer Notify</a></li>
                    <li class=""><a href="manageContactUs.jsp"><i class="material-icons">mark_email_unread</i>Contact Us</a></li>
                    <li class="active"><a href="managerReport.jsp"><i class="material-icons">library_books</i>Report</a></li>
                    <li class=""><a href="homePage.jsp"><i class="material-icons">power_settings_new"></i>Sign Out</a></li>
                </ul>
            </div>
            <!-- Sidebar design end -->
            <!-- Page content start -->
            <div id="content">
                <!-- Top navbar start -->
                <div class="top-navbar">
                    <div class="xd-topbar">
                        <div class="row">
                            <div class="col-2 col-md-1 col-lg-1 order-2 order-md-1 align-self-center">
                                <div class="xp-menubar">
                                    <span class="material-icons text-white">signal_cellular_alt</span>
                                </div>
                            </div>
                            <div class="col-md-5 col-lg-3 order-3 order-md-2"></div>
                            <div class="col-10 col-md-6 col-lg-8 order-1 order-md-3">
                                <div class="xp-profilebar text-right">
                                    <nav class="navbar p-0">
                                        <ul class="nav navbar-nav flex-row ml-auto">
                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="#" data-toggle="dropdown">
                                                    <span class="material-icons">notifications</span>
                                                </a>
                                            </li>
                                            <li class="dropdown nav-item">
                                                <a class="nav-link" href="managerProfile.jsp">
                                                    <img src="<%= hasImage ? "getImage?userID=" + userID + "&roles=" + roles : "IMG/avatar.jpg"%>" style="width:40px; height:40px; border-radius:50%;" />
                                                    <span class="xp-user-live"></span>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                        <div class="xp-breadcrumbbar text-center">
                            <h4 class="page-title">Report</h4>
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Manager</a></li>
                            </ol>
                        </div>
                    </div>
                </div>
                <!-- Top navbar end -->
                <!-- Main content start -->
                <div class="main-content">
                    <div class="container mt-5">
                        <h1>Vehicle Insurance Renewal Report</h1>
                        <div class="report-content" id="report-content">
                            <h2>Insurance Renewal Summary</h2>
                            <p>Here is the vehicle insurance renewal report which provides an overview of all renewals processed, upcoming expiries, and other relevant details for efficient management.</p>

                            <h3>Customer Notifications</h3>
                            <ul>
                                <li>Notifications Sent: <%= notified%></li>
                                <li>Notifications Pending: <%= notNotified%></li>
                            </ul>

                            <h3>Customer Engagement</h3>
                            <ul>
                                <%
                                    for (Map.Entry<String, Integer> entry : monthlyRegistrations.entrySet()) {
                                        String[] parts = entry.getKey().split("-");
                                        String monthName = dfs.getMonths()[Integer.parseInt(parts[1]) - 1];
                                        String formattedMonth = monthName + " " + parts[0];
                                %>
                                <li><%= formattedMonth%>: <%= entry.getValue()%> registrations</li>
                                    <%
                                        }
                                    %>
                            </ul>

                            <h3>Customer Satisfaction</h3>
                            <ul>
                                <li>Very Satisfied: <%= verySatisfied%></li>
                                <li>Satisfied: <%= satisfied%></li>
                                <li>Neutral: <%= neutral%></li>
                                <li>Dissatisfied: <%= dissatisfied%></li>
                                <li>Very Dissatisfied: <%= veryDissatisfied%></li>
                            </ul>

                            <h3>Manager's Notes</h3>
                            <p>Ensure that all outstanding payments are followed up promptly and renewals for the next month are prioritized. Review expired policies to determine if any follow-up actions are required. Monitor the KPIs closely and implement the recommended actions to enhance overall performance.</p>

                            <h3>Admin Instructions</h3>
                            <ul>
                                <li>Verify all processed renewals for accuracy.</li>
                                <li>Update the payment status in the system.</li>
                                <li>Coordinate with the finance department for payment reconciliation.</li>
                                <li>Prepare renewal reminders for the next month.</li>
                            </ul>

                            <p>This report is intended for internal use and should not be distributed without appropriate authorization.</p>
                        </div>
                        <button class="btn btn-primary" onclick="generatePDF()">Generate PDF</button>
                    </div>
                </div>
                <!-- Main content end -->
                <!-- Footer design -->
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="footer-in">
                            <p class="mb-0">&copy; 2024 RAZ WAWASAN SDN BHD (ADLI YONG)</p>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <!-- Optional JavaScript -->
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
        </script>
        <script>
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
                            await addBackgroundImage(); // Ensure background image is added to new page
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

                    // Dimensions to center the image
                    const imgWidth = 150;
                    const imgHeight = 150;
                    const xOffset = (pageWidth - imgWidth) / 2; // Center horizontally
                    const yOffset = (pageHeight - imgHeight) / 2; // Center vertically

                    doc.addImage(img, 'PNG', xOffset, yOffset, imgWidth, imgHeight, '', 'NONE', 0.1); // Set opacity to 10%
                };

                await addBackgroundImage(); // Add background image to the first page

                // Continue with text addition, ensuring to await on addText which now could be asynchronous due to background image
                await addText("Vehicle Insurance Renewal Report", 22, true);
                await addText("Insurance Renewal Summary", 16, true);
                await addText("Here is the vehicle insurance renewal report which provides an overview of all renewals processed, upcoming expiries, and other relevant details for efficient management.", 12, false);
                await addText("Customer Notifications", 14, true);
                await addText(`Notifications Sent: <%= notified%>`, 12, false);
                await addText(`Notifications Pending: <%= notNotified%>`, 12, false);
                await addText("Customer Engagement", 14, true);
            <% for (Map.Entry<String, Integer> entry : monthlyRegistrations.entrySet()) {%>
                await addText(`<%= entry.getKey()%>: <%= entry.getValue()%> registrations`, 12, false);
            <% }%>
                await addText("Customer Satisfaction", 14, true);
                await addText(`Very Satisfied: <%= verySatisfied%>`, 12, false);
                await addText(`Satisfied: <%= satisfied%>`, 12, false);
                await addText(`Neutral: <%= neutral%>`, 12, false);
                await addText(`Dissatisfied: <%= dissatisfied%>`, 12, false);
                await addText(`Very Dissatisfied: <%= veryDissatisfied%>`, 12, false);
                await addText("Manager's Notes", 14, true);
                await addText("Ensure that all outstanding payments are followed up promptly and renewals for the next month are prioritized. Review expired policies to determine if any follow-up actions are required. Monitor the KPIs closely and implement the recommended actions to enhance overall performance.", 12, false);
                await addText("Admin Instructions", 14, true);
                await addText("Verify all processed renewals for accuracy.", 12, false);
                await addText("Update the payment status in the system.", 12, false);
                await addText("Coordinate with the finance department for payment reconciliation.", 12, false);
                await addText("Prepare renewal reminders for the next month.", 12, false);
                await addText("This report is intended for internal use and should not be distributed without appropriate authorization.", 12, false);

                doc.save('Vehicle_Insurance_Renewal_Report.pdf');
            }
        </script>
    </body>
</html>
