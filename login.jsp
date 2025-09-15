<%@ page import="java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // If user already logged in, redirect to index.jsp
    if (session.getAttribute("userEmail") != null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Glamify Makeup</title>
    <style>
    /* Reset */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    /* Background gradient with animation */
    body {
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(-45deg, #ffe6f0, #ffd6e8, #fce1f4, #fff0f6);
        background-size: 400% 400%;
        animation: gradientShift 12s ease infinite;
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #333;
    }

    @keyframes gradientShift {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    /* Login Card */
    .login-box {
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(20px);
        padding: 50px 40px;
        border-radius: 25px;
        box-shadow: 0 15px 40px rgba(214, 51, 132, 0.2);
        width: 360px;
        text-align: center;
        animation: fadeIn 1s ease-in-out;
        position: relative;
    }

    .login-box::before {
        content: "💄";
        font-size: 3em;
        position: absolute;
        top: -25px;
        left: 50%;
        transform: translateX(-50%);
        background: linear-gradient(45deg, #ff6bcb, #d63384);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    .login-box h2 {
        margin-bottom: 25px;
        font-size: 2em;
        font-weight: 700;
        background: linear-gradient(90deg, #ff6bcb, #d63384);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    /* Inputs */
    input {
        width: 100%;
        padding: 12px 15px;
        margin: 12px 0;
        border: 1px solid #ccc;
        border-radius: 12px;
        font-size: 1em;
        transition: all 0.3s ease;
    }

    input:focus {
        outline: none;
        border-color: #ff6bcb;
        box-shadow: 0 0 10px rgba(214, 51, 132, 0.3);
    }

    /* Button */
    button {
        width: 100%;
        padding: 14px;
        margin-top: 20px;
        background: linear-gradient(45deg, #ff6bcb, #d63384);
        color: white;
        font-weight: bold;
        border: none;
        border-radius: 12px;
        cursor: pointer;
        font-size: 1em;
        transition: all 0.3s ease;
        box-shadow: 0 10px 20px rgba(214, 51, 132, 0.25);
    }

    button:hover {
        transform: translateY(-3px) scale(1.03);
        box-shadow: 0 15px 25px rgba(214, 51, 132, 0.35);
    }

    /* Error message */
    .error {
        color: #e53e3e;
        margin-top: 15px;
        font-weight: 500;
    }

    /* Register link */
    .register-link {
        display: block;
        margin-top: 25px;
        font-size: 0.9em;
        color: #d63384;
        text-decoration: none;
        font-weight: 600;
        transition: color 0.3s ease;
    }

    .register-link:hover {
        color: #ff6bcb;
        text-decoration: underline;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media(max-width: 400px) {
        .login-box {
            width: 90%;
            padding: 35px 25px;
        }
    }
</style>
</head>
<body>
    <div class="login-box">
        <h2>Welcome Back, Gorgeous ✨</h2>
        <form method="post" action="login.jsp">
            <input type="text" name="email" placeholder="Enter your Email" required>
            <input type="password" name="password" placeholder="Enter your Password" required>
            <button type="submit">Login</button>
        </form>
        <a href="register.jsp" class="register-link">New to Glamify? Register here</a>

        <%
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email != null && password != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    conn = DBConnection.getConnection();
                    ps = conn.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
                    ps.setString(1, email);
                    ps.setString(2, password); // plain text for simplicity
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        session.setAttribute("userEmail", email); // store session
                        response.sendRedirect("index.jsp");
                    } else {
                        out.println("<p class='error'>Invalid email or password!</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception ex) {}
                    try { if (ps != null) ps.close(); } catch (Exception ex) {}
                    try { if (conn != null) conn.close(); } catch (Exception ex) {}
                }
            }
        %>
    </div>
</body>
</html>