<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session to log out
    session.invalidate();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Logged Out - Glamour Beauty</title>
    <style>
        /* Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            height: 100vh;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fce4ec, #f8bbd0, #f48fb1);
            display: flex;
            justify-content: center;
            align-items: center;
            color: #4a154b;
            overflow: hidden;
        }

        .logout-container {
            background: #fff0f5;
            padding: 50px 40px;
            border-radius: 25px;
            text-align: center;
            width: 420px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            animation: fadeInUp 1s ease-out;
            position: relative;
        }

        .logout-container h2 {
            font-size: 2.2em;
            font-weight: 700;
            color: #d81b60;
            margin-bottom: 20px;
        }

        .logout-container p {
            font-size: 1.1em;
            margin-bottom: 30px;
            color: #6a1b9a;
        }

        .logout-container a {
            display: inline-block;
            padding: 12px 25px;
            background: linear-gradient(135deg, #ec407a, #ad1457);
            color: white;
            border-radius: 12px;
            text-decoration: none;
            font-weight: bold;
            font-size: 1em;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(236,64,122,0.4);
        }

        .logout-container a:hover {
            background: linear-gradient(135deg, #ad1457, #880e4f);
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(173,20,87,0.5);
        }

        /* Floating makeup particles */
        .sparkle {
            position: absolute;
            width: 15px;
            height: 15px;
            background: radial-gradient(circle, #ff80ab, transparent);
            border-radius: 50%;
            animation: float 6s infinite ease-in-out;
        }

        .sparkle:nth-child(1) { top: 20%; left: 15%; animation-delay: 0s; }
        .sparkle:nth-child(2) { top: 60%; left: 80%; animation-delay: 2s; }
        .sparkle:nth-child(3) { top: 40%; left: 50%; animation-delay: 4s; }
        .sparkle:nth-child(4) { top: 75%; left: 25%; animation-delay: 1s; }
        .sparkle:nth-child(5) { top: 10%; left: 70%; animation-delay: 3s; }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) scale(1); opacity: 0.7; }
            50% { transform: translateY(-30px) scale(1.3); opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <h2>You’ve Logged Out!</h2>
        <p>Thanks for visiting <strong>Glamour Beauty</strong>. Come back soon 💄✨</p>
        <a href="login.jsp">Login Again</a>

        <!-- Sparkles -->
        <div class="sparkle"></div>
        <div class="sparkle"></div>
        <div class="sparkle"></div>
        <div class="sparkle"></div>
        <div class="sparkle"></div>
    </div>

    <!-- Auto redirect after 3s -->
    <script>
        setTimeout(function() {
            window.location.href = "login.jsp";
        }, 3000);
    </script>
</body>
</html>