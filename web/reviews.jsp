<%@page import="com.dao.FeedbackDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.model.Feedback"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.dao.ProfileDAO"%>
<%@page import="com.model.Profile"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="java.util.Base64"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Reviews</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-wEmeIV1mKuiNpC+IOBjI7aAzPcEZeedi5yW5f2yOq55WWLwNGmvvx4Um1vskeMj0" crossorigin="anonymous">
        <link rel="stylesheet" href="CSS/homePage.css">
    </head>
    <body>
        <div class="container py-5">
            <h2 class="text-center mb-4 " style="color: black">All Customer Reviews</h2>
            <div class="row mb-4">
                <div class="col-md-4 offset-md-4">
                    <form method="get" action="reviews.jsp">
                        <div class="input-group">
                            <select name="star" class="form-select">
                                <option value="all">All Stars</option>
                                <option value="5">5 Stars</option>
                                <option value="4">4 Stars</option>
                                <option value="3">3 Stars</option>
                                <option value="2">2 Stars</option>
                                <option value="1">1 Star</option>
                            </select>
                            <button type="submit" class="btn btn-primary">Filter</button>
                            <a href="homePage.jsp" class="btn btn-secondary ms-2">Back to Home</a>
                        </div>
                    </form>
                </div>
            </div>
            <div class="row">
                <%
                    String starFilter = request.getParameter("star");
                    if (starFilter == null || starFilter.isEmpty()) {
                        starFilter = "all";
                    }

                    FeedbackDAO feedbackDAO = new FeedbackDAO();
                    List<Feedback> feedbackList = feedbackDAO.getAllFeedback();

                    if (!"all".equals(starFilter)) {
                        int starRating = Integer.parseInt(starFilter);
                        Iterator<Feedback> iterator = feedbackList.iterator();
                        while (iterator.hasNext()) {
                            Feedback feedback = iterator.next();
                            if (feedback.getRating() != starRating) {
                                iterator.remove();
                            }
                        }
                    }

                    for (Feedback feedback : feedbackList) {
                        Profile profile = ProfileDAO.getCustomerByID(feedback.getUserID());
                        String encodedProfileImage = "IMG/avatar.jpg"; // Default image
                        if (profile != null) {
                            InputStream profileImageStream = profile.getProfileImage();
                            if (profileImageStream != null) {
                                byte[] profileImageBytes = profileImageStream.readAllBytes();
                                encodedProfileImage = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(profileImageBytes);
                            }
                %>
                <div class="col-md-4 mb-4">
                    <div class="review-box shadow-sm p-4 mb-4 bg-white rounded">
                        <div class="review-header d-flex align-items-center">
                            <img src="<%= encodedProfileImage%>" alt="Profile Picture" class="review-profile-img">
                            <div>
                                <h4 class="review-name mb-0"><%= profile.getFirstname() + " " + profile.getLastname()%></h4>
                                <small class="text-muted">Customer</small>
                            </div>
                        </div>
                        <p class="review-content mt-3">
                            <%= feedback.getFeedback()%>
                        </p>
                        <div class="review-stars">
                            <% for (int k = 0; k < feedback.getRating(); k++) { %>
                            <span class="star">&#9733;</span>
                            <% } %>
                        </div>
                    </div>
                </div>
                <%
                } else {
                %>
                <div class="col-md-4 mb-4">
                    <div class="review-box shadow-sm p-4 mb-4 bg-white rounded">
                        <div class="review-header d-flex align-items-center">
                            <img src="IMG/avatar.jpg" alt="Profile Picture" class="review-profile-img">
                            <div>
                                <h4 class="review-name mb-0">Anonymous</h4>
                                <small class="text-muted">Customer</small>
                            </div>
                        </div>
                        <p class="review-content mt-3">
                            <%= feedback.getFeedback()%>
                        </p>
                        <div class="review-stars">
                            <% for (int k = 0; k < feedback.getRating(); k++) { %>
                            <span class="star">&#9733;</span>
                            <% } %>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-p34f1UUtsS3wqzfto5wAAmdvj+osOnFyQFpp4Ua3gs/ZVWx6oOypYoCJhGGScy+8"
        crossorigin="anonymous"></script>
    </body>
</html>
