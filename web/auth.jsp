<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIGA-KAMPUS &mdash; Authentication</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/componentsCSS/navbarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/globalStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/auth.css">
</head>
<body>

<div class="auth-wrapper">
<div class="auth-shell">

    <!-- Shared brand / hero panel -->
    <div class="auth-hero">
        <div class="auth-hero__brand">
            <span class="logo-mark">LK</span> Liga-Kampus
        </div>

        <div class="auth-hero__main">
            <div class="auth-hero__eyebrow">Inter-Faculty Tournament Manager</div>
            <h1 class="auth-hero__title">Every match,<br>tracked and<br><em>traceable.</em></h1>
            <p class="auth-hero__subtitle">One platform for the whole campus league.</p>
            <p class="auth-hero__desc">Register players, log match results, and follow live standings across every faculty competition &mdash; all in one place.</p>

            <div class="auth-ticket">
                <div class="auth-ticket__top">
                    <span class="auth-ticket__label">Match Center</span>
                    <span class="auth-ticket__id">#0412</span>
                </div>
                <div class="auth-ticket__match">
                    <span class="auth-ticket__team">FSKM</span>
                    <span class="auth-ticket__score">3&ndash;2</span>
                    <span class="auth-ticket__team auth-ticket__team--right">FSPU</span>
                </div>
                <hr class="auth-ticket__divider">
                <div class="auth-ticket__foot">
                    <span class="auth-ticket__venue">Main Stadium &middot; Football</span>
                    <span class="auth-ticket__status">Final</span>
                </div>
            </div>
        </div>

        <div class="auth-hero__stats">
            <div>
                <div class="auth-hero__stat-val">12+</div>
                <div class="auth-hero__stat-lbl">Sports</div>
            </div>
            <div>
                <div class="auth-hero__stat-val">80+</div>
                <div class="auth-hero__stat-lbl">Teams</div>
            </div>
            <div>
                <div class="auth-hero__stat-val">Live</div>
                <div class="auth-hero__stat-lbl">Standings</div>
            </div>
        </div>
    </div>

    <!-- Sign up form -->
    <section id="signup" class="auth-form-section">
        <div class="auth-card">
            <div class="auth-header">
                <h1>Create Account</h1>
                <p>Join LIGA-KAMPUS and manage your campus activities seamlessly.</p>
            </div>

            <% if ("email_taken".equals(request.getParameter("error"))) { %>
                <div class="alert-box alert-danger">This email address is already registered!</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/authServlet" method="POST">
                <input type="hidden" name="action" value="signup">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" placeholder="Enter your full name" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Create password" required>
                </div>
                <div class="form-group">
                    <label>Faculty</label>
                    <input type="text" name="faculty" placeholder="Enter your faculty" required>
                </div>

                <button type="submit" class="btn btn--primary btn--full">Sign Up</button>
            </form>

            <div class="auth-footer">Already have an account? <a id="showLogin">Log In</a></div>
        </div>
    </section>

    <!-- Login form -->
    <section id="login" class="auth-form-section hidden">
        <div class="auth-card">
            <div class="auth-header">
                <h1>Welcome Back</h1>
                <p>Login to access your LIGA-KAMPUS dashboard.</p>
            </div>

            <% if ("invalid_credentials".equals(request.getParameter("error"))) { %>
                <div class="alert-box alert-danger">Invalid email or password. Please try again.</div>
            <% } else if ("unauthorized".equals(request.getParameter("error"))) { %>
                <div class="alert-box alert-danger">You don't have permission to view that page.</div>
            <% } else if ("registered".equals(request.getParameter("success"))) { %>
                <div class="alert-box alert-success">Registration successful! Please sign in.</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/authServlet" method="POST">
                <input type="hidden" name="action" value="login">

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Enter your password" required>
                </div>

                <div class="forgot-link"><a href="#">Forgot Password?</a></div>

                <button type="submit" class="btn btn--primary btn--full">Log In</button>
            </form>

            <div class="auth-footer">Don't have an account? <a id="showSignup">Sign Up</a></div>
        </div>
    </section>

</div>
</div>

<script>
    const signup = document.getElementById("signup");
    const login = document.getElementById("login");

    const urlParams = new URLSearchParams(window.location.search);
    if ((urlParams.get('error') === 'invalid_credentials') || urlParams.get('error') === 'unauthorized' || urlParams.has('success')) {
        signup.classList.add("hidden");
        login.classList.remove("hidden");
    }

    document.getElementById("showLogin").addEventListener("click", e => {
        e.preventDefault();
        signup.classList.add("hidden");
        login.classList.remove("hidden");
    });
    document.getElementById("showSignup").addEventListener("click", e => {
        e.preventDefault();
        login.classList.add("hidden");
        signup.classList.remove("hidden");
    });
</script>

</body>
</html>
