<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>LIGA-KAMPUS Authentication</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        
        <link rel="stylesheet" href="CSS/auth.css">

    </head>
    <body>

    <div class="auth-wrapper">

        <!-- SIGN UP -->
        <section id="signup" class="auth-container" name="signupSection">

            <div class="auth-image">
                <img src="images/login" alt="Campus">
            </div>

            <div class="auth-form-section">

                <div class="auth-card">

                    <div class="auth-header">
                        <h1>Create Account</h1>
                        <p>Join LIGA-KAMPUS and manage your campus activities seamlessly.</p>
                    </div>

                    <form action="authServlet" method="POST">
                        <input type="hidden" name="action" value="signup">

                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text"
                                   name="fullName"
                                   placeholder="Enter your full name"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email"
                                   name="email"
                                   placeholder="Enter your email"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <input type="password"
                                   name="password"
                                   placeholder="Create password"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Faculty</label>
                            <input type="text"
                                   name="faculty"
                                   placeholder="Enter your faculty"
                                   required>
                        </div>

                        <button type="submit" class="btn-primary">
                            Sign Up
                        </button>

                    </form>

                    <div class="auth-footer">
                        Already have an account?
                        <a href="#" id="showLogin">Log In</a>
                    </div>

                </div>

            </div>

        </section>

        <!-- LOGIN -->
        <section id="login" class="auth-container hidden">

            <div class="auth-image">
                <img src="images/login" alt="Campus">
            </div>

            <div class="auth-form-section">

                <div class="auth-card">

                    <div class="auth-header">
                        <h1>Welcome Back</h1>
                        <p>Login to access your LIGA-KAMPUS dashboard.</p>
                    </div>

                    <form action="authServlet" method="POST">
                        <input type="hidden" name="action" value="login">

                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email"
                                   name="email"
                                   placeholder="Enter your email"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <input type="password"
                                   name="password"
                                   placeholder="Enter your password"
                                   required>
                        </div>

                        <div class="forgot-link">
                            <a href="#">Forgot Password?</a>
                        </div>

                        <button type="submit" class="btn-primary">
                            Log In
                        </button>

                    </form>

                    <div class="auth-footer">
                        Don't have an account?
                        <a href="#" id="showSignup">Sign Up</a>
                    </div>

                </div>

            </div>

        </section>

    </div>

        <script>

            const signup = document.getElementById("signup");
            const login = document.getElementById("login");

            document.getElementById("showLogin").addEventListener("click", function(e){
                e.preventDefault();
                signup.classList.add("hidden");
                login.classList.remove("hidden");
            });

            document.getElementById("showSignup").addEventListener("click", function(e){
                e.preventDefault();
                login.classList.add("hidden");
                signup.classList.remove("hidden");
            });

        </script>

    </body>
</html>