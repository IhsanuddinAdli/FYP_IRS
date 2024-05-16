<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Reports</title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <h1>Vehicle Insurance Renewal Report</h1>
            <div id="report-content" style="display:none;">
                <h2>Insurance Renewal Summary</h2>
                <p>Here is the vehicle insurance renewal report which provides an overview of all renewals processed, upcoming expiries, and other relevant details for efficient management.</p>

                <h3>Renewal Details</h3>
                <ul>
                    <li>Total Renewals Processed: 120</li>
                    <li>Renewals Due Next Month: 45</li>
                    <li>Expired Policies: 15</li>
                </ul>

                <h3>Payment Details</h3>
                <ul>
                    <li>Total Collected: $25,000</li>
                    <li>Outstanding Payments: $5,750</li>
                </ul>

                <h3>Advanced Data and Insights</h3>
                <ul>
                    <li>Average Renewal Time: 5 days</li>
                    <li>Customer Satisfaction Rate: 85%</li>
                    <li>Retention Rate: 92%</li>
                    <li>Top 5 Reasons for Non-Renewal:
                        <ul>
                            <li>Price Increase</li>
                            <li>Better Offer from Competitor</li>
                            <li>Customer Relocation</li>
                            <li>Service Issues</li>
                            <li>Vehicle Sale</li>
                        </ul>
                    </li>
                    <li>Most Common Payment Methods:
                        <ul>
                            <li>Credit Card: 70%</li>
                            <li>Bank Transfer: 20%</li>
                            <li>Cash: 10%</li>
                        </ul>
                    </li>
                </ul>

                <h3>Key Performance Indicators (KPIs)</h3>
                <ul>
                    <li>Monthly Renewal Rate: 78%</li>
                    <li>Policy Lapse Rate: 6%</li>
                    <li>New Customer Acquisition: 25</li>
                    <li>Average Premium per Customer: $208</li>
                </ul>

                <h3>Actionable Insights</h3>
                <p>To improve the renewal rate and customer satisfaction, consider the following actions:</p>
                <ul>
                    <li>Implement a customer loyalty program to incentivize renewals.</li>
                    <li>Offer flexible payment plans to accommodate different customer needs.</li>
                    <li>Enhance customer service training to address service-related non-renewals.</li>
                    <li>Review and adjust pricing strategies based on competitive analysis.</li>
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
                await addText("Renewal Details", 14, true);
                await addText("Total Renewals Processed: 120", 12, false);
                await addText("Renewals Due Next Month: 45", 12, false);
                await addText("Expired Policies: 15", 12, false);
                await addText("Payment Details", 14, true);
                await addText("Total Collected: $25,000", 12, false);
                await addText("Outstanding Payments: $5,750", 12, false);
                await addText("Advanced Data and Insights", 14, true);
                await addText("Average Renewal Time: 5 days", 12, false);
                await addText("Customer Satisfaction Rate: 85%", 12, false);
                await addText("Retention Rate: 92%", 12, false);
                await addText("Top 5 Reasons for Non-Renewal:", 12, false);
                await addText("- Price Increase", 12, false);
                await addText("- Better Offer from Competitor", 12, false);
                await addText("- Customer Relocation", 12, false);
                await addText("- Service Issues", 12, false);
                await addText("- Vehicle Sale", 12, false);
                await addText("Most Common Payment Methods:", 12, false);
                await addText("- Credit Card: 70%", 12, false);
                await addText("- Bank Transfer: 20%", 12, false);
                await addText("- Cash: 10%", 12, false);
                await addText("Key Performance Indicators (KPIs)", 14, true);
                await addText("Monthly Renewal Rate: 78%", 12, false);
                await addText("Policy Lapse Rate: 6%", 12, false);
                await addText("New Customer Acquisition: 25", 12, false);
                await addText("Average Premium per Customer: $208", 12, false);
                await addText("Actionable Insights", 14, true);
                await addText("To improve the renewal rate and customer satisfaction, consider the following actions:", 12, false);
                await addText("- Implement a customer loyalty program to incentivize renewals.", 12, false);
                await addText("- Offer flexible payment plans to accommodate different customer needs.", 12, false);
                await addText("- Enhance customer service training to address service-related non-renewals.", 12, false);
                await addText("- Review and adjust pricing strategies based on competitive analysis.", 12, false);
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
