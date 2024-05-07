<%@page import="com.dao.FeedbackDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.model.Feedback"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.dao.ProfileDAO"%>
<%@page import="com.model.Profile"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="java.util.Base64"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-wEmeIV1mKuiNpC+IOBjI7aAzPcEZeedi5yW5f2yOq55WWLwNGmvvx4Um1vskeMj0" crossorigin="anonymous">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="CSS/homePage.css">
        <title>Home Page</title>
    </head>

    <body>

        <section id="header">
            <div class="container">
                <nav class="navbar navbar-expand-lg navbar-dark">
                    <div class="container-fluid">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#b5d524"
                             class="bi bi-car-front-fill" viewBox="0 0 16 16">
                        <path
                            d="M2.52 3.515A2.5 2.5 0 0 1 4.82 2h6.362c1 0 1.904.596 2.298 1.515l.792 1.848c.075.175.21.319.38.404.5.25.855.715.965 1.262l.335 1.679q.05.242.049.49v.413c0 .814-.39 1.543-1 1.997V13.5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1-.5-.5v-1.338c-1.292.048-2.745.088-4 .088s-2.708-.04-4-.088V13.5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1-.5-.5v-1.892c-.61-.454-1-1.183-1-1.997v-.413a2.5 2.5 0 0 1 .049-.49l.335-1.68c.11-.546.465-1.012.964-1.261a.8.8 0 0 0 .381-.404l.792-1.848ZM3 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2m10 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2M6 8a1 1 0 0 0 0 2h4a1 1 0 1 0 0-2zM2.906 5.189a.51.51 0 0 0 .497.731c.91-.073 3.35-.17 4.597-.17s3.688.097 4.597.17a.51.51 0 0 0 .497-.731l-.956-1.913A.5.5 0 0 0 11.691 3H4.309a.5.5 0 0 0-.447.276L2.906 5.19Z"/>
                        </svg> <a class="navbar-brand theme-text" href="#">
                            &nbsp;GuardWheels : Insurance Renewal System</a>
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                                data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                                aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarSupportedContent">
                            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                                <li class="nav-item">
                                    <a class="nav-link" href="#header">Home</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="#about" data-target="#about">About Us</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="#review" data-target="#review">Review</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="#contact" data-target="#contact">Contact Us</a>
                                </li>
                                <!-- ... -->
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                       data-bs-toggle="dropdown" aria-expanded="false">
                                        Login / Sign Up
                                    </a>
                                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                        <!-- Customer Section -->
                                        <li>
                                            <span class="dropdown-header">Customer</span>
                                            <a class="dropdown-item" href="login.jsp">Login</a>
                                            <a class="dropdown-item" href="register.jsp">Sign Up</a>
                                        </li>

                                        <!-- Separator -->
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>

                                        <!-- Staff Section -->
                                        <li>
                                            <span class="dropdown-header">Staff</span>
                                            <a class="dropdown-item" href="staffLogin.jsp">Login</a>
                                        </li>
                                    </ul>
                                </li>
                                <!-- ... -->

                            </ul>

                        </div>
                    </div>
                </nav>
                <!-- navbar code -->
                <div class="middle">
                    <h1 class="text-white display-3 fw-bold">Get Your Vehicle Quotation <span class="theme-text">For
                            FREE!</span>.</h1>
                </div>
            </div>
            <svg class="wave" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
            <path fill="#fff" fill-opacity="1"
                  d="M0,192L60,181.3C120,171,240,149,360,133.3C480,117,600,107,720,106.7C840,107,960,117,1080,122.7C1200,128,1320,128,1380,128L1440,128L1440,320L1380,320C1320,320,1200,320,1080,320C960,320,840,320,720,320C600,320,480,320,360,320C240,320,120,320,60,320L0,320Z">
            </path>
            </svg>
        </section>

        <!-- Add content for the "About Us" section -->
        <section id="about" class="bg-light py-5">
            <div class="container">
                <h2 class="text-center mb-4">About Us</h2>
                <div class="row">
                    <div class="col-md-6">
                        <img src="IMG/kedai.jpg" class="img-fluid rounded" alt="About Us Image">
                    </div>
                    <div class="col-md-6" style="background-color: #yourColorCode;">
                        <p class="lead">
                            Welcome to GuardWheels, your trusted partner for hassle-free insurance renewal.
                            Our mission is to provide efficient and reliable services to ensure your vehicle is
                            always protected. With a team of dedicated professionals, we strive to make the
                            insurance renewal process seamless and convenient for you.
                        </p>
                    </div>
                </div>
                <!-- Add more content as needed -->
            </div>
        </section>

        <!-- Add content for the "Review" section -->
        <section id="review" class="bg-light py-5">
            <div class="container">
                <h2 class="text-center mb-4">Customer Reviews</h2>

                <!-- Slideshow container -->
                <div class="slideshow-container">
                    <!-- Iterate over feedback data and display -->
                    <%
                        // Retrieve feedback data from the database
                        FeedbackDAO feedbackDAO = new FeedbackDAO();
                        List<Feedback> feedbackList = feedbackDAO.getAllFeedback(); // Assuming you have a method to fetch all feedback

                        // Determine the number of slides needed
                        int numSlides = (int) Math.ceil((double) feedbackList.size() / 3);

                        // Loop through each slide
                        for (int i = 0; i < numSlides; i++) {
                    %>
                    <div class="mySlides">
                        <div class="row">
                            <% for (int j = i * 3; j < Math.min((i + 1) * 3, feedbackList.size()); j++) {
                                    Feedback feedback = feedbackList.get(j);
                                    Profile profile = ProfileDAO.getCustomerByID(feedback.getUserID());
                                    if (profile != null) {
                                        InputStream profileImageStream = profile.getProfileImage();
                                        if (profileImageStream != null) {
                                            byte[] profileImageBytes = profileImageStream.readAllBytes();
                                            String encodedProfileImage = Base64.getEncoder().encodeToString(profileImageBytes);
                            %>
                            <div class="col-md-4">
                                <div class="review-box">
                                    <div class="review-header">
                                        <img src="data:image/jpeg;base64, <%= encodedProfileImage%>"
                                             alt="Profile Picture" class="review-profile-img">
                                        <h4 class="review-name"><%= profile.getFirstname() + " " + profile.getLastname()%></h4>
                                    </div>
                                    <p class="review-content">
                                        <%= feedback.getFeedback()%>
                                    </p>
                                    <div class="review-stars">
                                        <!-- Render star rating here if available -->
                                        <%-- Example: ★★★★☆ for rating 4 --%>
                                        <% for (int k = 0; k < feedback.getRating(); k++) { %>
                                        <span class="star">&#9733;</span>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                            <%
                                }
                            }
                        } %>
                        </div>
                    </div>
                    <%
                        }
                    %>

                    <!-- Next/prev buttons -->
                    <a class="prev" onclick="plusSlides(-1)">&#10094;</a>
                    <a class="next" onclick="plusSlides(1)">&#10095;</a>
                </div>

                <!-- Dots/bullets/indicators -->
                <div class="dot-container">
                    <% for (int i = 0; i < numSlides; i++) {%>
                    <span class="dot" onclick="currentSlide(<%= i + 1%>)"></span>
                    <% }%>
                </div>
            </div>
        </section>


        <!-- "Contact Us" section -->
        <section id="contact" class="bg-light py-5">
            <div class="container">
                <div class="row">
                    <div class="col-md-6">
                        <h2 class="mb-4">Get in Touch</h2>
                        <p>If you have any questions or inquiries, feel free to contact us. Our team is here to assist you.</p>
                        <form>
                            <div class="mb-3">
                                <input type="text" class="form-control" placeholder="Your Name">
                            </div>
                            <div class="mb-3">
                                <input type="email" class="form-control" placeholder="Your Email">
                            </div>
                            <div class="mb-3">
                                <textarea class="form-control" rows="5" placeholder="Your Message"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Send Message</button>
                        </form>
                    </div>
                    <div class="col-md-6">
                        <div class="contact-info">
                            <h2 class="mb-4">Contact Information</h2>
                            <p><i class="bi bi-geo-alt-fill"></i> 123 Street Name, City, Country</p>
                            <p><i class="bi bi-telephone-fill"></i> +0139816630</p>
                            <p><i class="bi bi-envelope-fill"></i> adliyong1974@yahoo.com</p>
                            <div class="social-links mt-4">
                                <a href="https://wa.me/1234567890" class="whatsapp btn btn-primary" target="_blank"><i class="bi bi-whatsapp"></i> Chat on Whatsapp</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Option 1: Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-p34f1UUtsS3wqzfto5wAAmdvj+osOnFyQFpp4Ua3gs/ZVWx6oOypYoCJhGGScy+8"
        crossorigin="anonymous"></script>

        <script>
                document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                    anchor.addEventListener('click', function (e) {
                        e.preventDefault();

                        document.querySelector(this.getAttribute('href')).scrollIntoView({
                            behavior: 'smooth'
                        });
                    });
                });
        </script>
        <script>
            var slideIndex = 1;
            showSlides(slideIndex);

            function plusSlides(n) {
                showSlides(slideIndex += n);
            }

            function currentSlide(n) {
                showSlides(slideIndex = n);
            }

            function showSlides(n) {
                var i;
                var slides = document.getElementsByClassName("mySlides");
                var dots = document.getElementsByClassName("dot");
                if (n > slides.length) {
                    slideIndex = 1
                }
                if (n < 1) {
                    slideIndex = slides.length
                }
                for (i = 0; i < slides.length; i++) {
                    slides[i].style.display = "none";
                }
                for (i = 0; i < dots.length; i++) {
                    dots[i].className = dots[i].className.replace(" active", "");
                }
                slides[slideIndex - 1].style.display = "block";
                dots[slideIndex - 1].className += " active";
            }

        </script>

        <!-- Footer Section -->
        <footer>
            <div class="footer-container">
                <p class="mb-0">&copy; 2024 RAZ WAWASAN SDN BHD (ADLI YONG)</p>
            </div>
        </footer>
    </body>
</html>
