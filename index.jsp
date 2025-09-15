<%-- 
    Document   : index
    Author     : Sweta
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Glamify - Makeup Store</title>
<style>
/* Import Google Font */
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@400;500;600&display=swap');

/* Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

/* Body with luxury gradient */
body {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    background: linear-gradient(135deg, #fff0f6, #ffe3ec, #ffd6e8);
    background-size: 400% 400%;
    animation: gradientShift 15s ease infinite;
    font-family: 'Poppins', sans-serif;
    color: #333;
}

@keyframes gradientShift {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* Glassmorphic Navbar */
.navbar {
    width: 92%;
    margin: 25px auto;
    padding: 18px 35px;
    display: flex;
    justify-content: center;
    gap: 30px;
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(15px);
    border-radius: 25px;
    box-shadow: 0 8px 32px rgba(214, 51, 132, 0.15);
    transition: all 0.3s ease;
}

.navbar a {
    color: #d63384;
    text-decoration: none;
    font-weight: 600;
    font-size: 1.05em;
    padding: 8px 22px;
    border-radius: 15px;
    transition: all 0.3s ease;
    position: relative;
}

.navbar a::after {
    content: '';
    display: block;
    height: 3px;
    width: 0;
    background: #ff6bcb;
    transition: width 0.3s;
    margin: auto;
}

.navbar a:hover::after {
    width: 100%;
}

.navbar a:hover {
    color: #ff2e93;
    transform: translateY(-2px);
}

/* Glam Welcome Card */
.welcome-card {
    margin-top: 70px;
    width: 92%;
    max-width: 800px;
    background: rgba(255, 255, 255, 0.3);
    backdrop-filter: blur(20px);
    border-radius: 35px;
    padding: 60px 50px;
    text-align: center;
    box-shadow: 0 25px 60px rgba(0,0,0,0.1);
    animation: floatCard 5s ease-in-out infinite;
    transition: transform 0.5s ease, box-shadow 0.5s ease;
}

.welcome-card:hover {
    transform: translateY(-12px) scale(1.03);
    box-shadow: 0 30px 70px rgba(214, 51, 132, 0.2);
}

@keyframes floatCard {
    0% { transform: translateY(0); }
    50% { transform: translateY(-20px); }
    100% { transform: translateY(0); }
}

/* Glam heading */
.welcome-card h1 {
    font-size: 3em;
    font-family: 'Playfair Display', serif;
    font-weight: 700;
    background: linear-gradient(90deg, #ff6bcb, #d63384);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 20px;
}

/* Subtext */
.welcome-card p {
    font-size: 1.2em;
    color: #5c2a43;
    line-height: 1.6;
    margin-bottom: 35px;
}

/* Call-to-action Button */
.cta-btn {
    display: inline-block;
    padding: 15px 45px;
    border-radius: 50px;
    background: linear-gradient(45deg, #ff6bcb, #d63384);
    color: #fff;
    font-weight: 700;
    font-size: 1.1em;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 12px 25px rgba(214, 51, 132, 0.3);
    text-decoration: none;
}

.cta-btn:hover {
    transform: translateY(-6px) scale(1.07);
    background: linear-gradient(45deg, #d63384, #ff6bcb);
    box-shadow: 0 18px 35px rgba(214, 51, 132, 0.4);
}

/* Responsive */
@media(max-width:768px) {
    .welcome-card {
        padding: 40px 25px;
    }
    .welcome-card h1 {
        font-size: 2.2em;
    }
    .welcome-card p {
        font-size: 1em;
    }
    .navbar {
        flex-wrap: wrap;
        gap: 15px;
    }
    .navbar a {
        font-size: 0.95em;
        padding: 6px 15px;
    }
}
</style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Makeup</a>
        <a href="cart.jsp">Cart</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="welcome-card">
        <h1>💄 Welcome to Glamify</h1>
        <p>Discover our latest lipsticks, foundations, eyeshadows & more.  
        Elevate your beauty game with luxury makeup collections.</p>
        <a href="products.jsp" class="cta-btn">✨ Shop Now</a>
    </div>
</body>
</html>