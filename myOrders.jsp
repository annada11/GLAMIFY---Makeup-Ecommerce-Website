<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null){
        response.sendRedirect("login.jsp");
        return;
    }

    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if(cart == null || cart.isEmpty()){
        response.sendRedirect("cart.jsp");
        return;
    }

    String address = request.getParameter("address");
    String payment = request.getParameter("payment");

    int orderId = 0;
    double grandTotal = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - Glamify Cosmetics</title>
    <style>
        /* Global Styles */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #ffe4ec, #f8bbd0, #f48fb1);
            margin: 0;
            padding: 0;
            color: #333;
            animation: fadeIn 1.2s ease-in-out;
        }

        /* Container */
        .container {
            max-width: 850px;
            margin: 60px auto;
            background: #fff;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            padding: 40px 30px;
            text-align: center;
            animation: slideUp 1s ease;
        }

        /* Header */
        .container h1 {
            font-size: 2.5rem;
            color: #d81b60;
            margin-bottom: 15px;
            font-weight: bold;
        }

        .container p {
            font-size: 1.1rem;
            color: #666;
            margin-bottom: 35px;
        }

        .order-id {
            font-size: 1.4rem;
            color: #ec407a;
            font-weight: bold;
            margin-bottom: 25px;
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 14px;
            text-align: center;
        }

        th {
            background: linear-gradient(45deg, #ec407a, #d81b60);
            color: #fff;
            font-size: 1.05em;
        }

        tr:nth-child(even) {
            background: #fce4ec;
        }

        tr:hover {
            background: #f8bbd0;
            transition: 0.3s;
        }

        td {
            color: #444;
        }

        /* Buttons */
        .btn {
            display: inline-block;
            background: linear-gradient(45deg, #ec407a, #d81b60);
            color: #fff;
            padding: 14px 28px;
            border-radius: 40px;
            font-weight: bold;
            margin: 10px;
            transition: 0.3s ease;
            font-size: 1.05em;
            box-shadow: 0 6px 18px rgba(236,64,122,0.3);
        }

        .btn:hover {
            background: linear-gradient(45deg, #d81b60, #ad1457);
            transform: scale(1.07);
            box-shadow: 0 8px 22px rgba(0,0,0,0.2);
        }

        /* Animations */
        @keyframes fadeIn {
            from {opacity: 0;}
            to {opacity: 1;}
        }

        @keyframes slideUp {
            from {transform: translateY(40px); opacity: 0;}
            to {transform: translateY(0); opacity: 1;}
        }

        /* Responsive */
        @media(max-width: 768px){
            .container {
                padding: 25px 18px;
            }
            .container h1 {
                font-size: 2rem;
            }
            .order-id {
                font-size: 1.1rem;
            }
        }
    </style>
</head>
<body>
<%
    try (Connection conn = DBConnection.getConnection()) {
        conn.setAutoCommit(false);

        // Calculate grand total
        for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
            int pid = entry.getKey();
            int qty = entry.getValue();
            try (PreparedStatement ps = conn.prepareStatement("SELECT price FROM products WHERE id=?")) {
                ps.setInt(1, pid);
                try (ResultSet rs = ps.executeQuery()) {
                    if(rs.next()) grandTotal += rs.getDouble("price") * qty;
                }
            }
        }

        // Insert order
        try (PreparedStatement psOrder = conn.prepareStatement(
            "INSERT INTO orders(user_email,address,payment_method,total) VALUES(?,?,?,?)",
            Statement.RETURN_GENERATED_KEYS
        )) {
            psOrder.setString(1, userEmail);
            psOrder.setString(2, address);
            psOrder.setString(3, payment);
            psOrder.setDouble(4, grandTotal);
            psOrder.executeUpdate();

            try (ResultSet rsOrder = psOrder.getGeneratedKeys()) {
                if(rsOrder.next()) orderId = rsOrder.getInt(1);
            }
        }

        // Insert order_items
        for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
            int pid = entry.getKey();
            int qty = entry.getValue();
            double price = 0;
            try (PreparedStatement psPrice = conn.prepareStatement("SELECT price FROM products WHERE id=?")) {
                psPrice.setInt(1, pid);
                try (ResultSet rsPrice = psPrice.executeQuery()) {
                    if(rsPrice.next()) price = rsPrice.getDouble("price");
                }
            }

            try (PreparedStatement psItem = conn.prepareStatement(
                "INSERT INTO order_items(order_id,product_id,quantity,price) VALUES(?,?,?,?)"
            )) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, pid);
                psItem.setInt(3, qty);
                psItem.setDouble(4, price);
                psItem.executeUpdate();
            }
        }

        conn.commit();
        session.removeAttribute("cart");
%>

    <div class="container">
        <h1>💖 Thank You, Gorgeous!</h1>
        <p>Your glam goodies are on their way ✨</p>
        <p class="order-id">Order ID: <strong>#<%=orderId%></strong></p>

        <table>
            <tr><th>Product ID</th><th>Quantity</th><th>Price (₹)</th><th>Total (₹)</th></tr>
            <%
                for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
                    int pid = entry.getKey();
                    int qty = entry.getValue();
                    double price = 0;
                    try (PreparedStatement psPrice = conn.prepareStatement("SELECT price FROM products WHERE id=?")) {
                        psPrice.setInt(1, pid);
                        try (ResultSet rsPrice = psPrice.executeQuery()) {
                            if(rsPrice.next()) price = rsPrice.getDouble("price");
                        }
                    }
                    double total = price * qty;
            %>
            <tr>
                <td>💄 <%=pid%></td>
                <td><%=qty%></td>
                <td>₹<%=price%></td>
                <td>₹<%=total%></td>
            </tr>
            <% } %>
            <tr>
                <th colspan="3">Grand Total</th>
                <th>₹<%=grandTotal%></th>
            </tr>
        </table>

        <a href="products.jsp" class="btn">🛍 Continue Shopping</a>
        <a href="myOrders.jsp" class="btn">📦 View My Orders</a>
    </div>

<%
    } catch(Exception e){
        out.println("<p style='color:red; text-align:center; margin-top:50px;'>Error placing order: "+e.getMessage()+"</p>");
        e.printStackTrace();
    }
%>
</body>
</html>