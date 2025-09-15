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
<html>
<head>
    <meta charset="UTF-8">
    <title>✨ Glamour Beauty - Order Confirmation</title>
    <style>
        /* Background */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fce4ec, #f8bbd0, #f48fb1);
            background-size: 400% 400%;
            animation: gradientFlow 10s ease infinite;
            margin: 0;
            padding: 0;
        }

        @keyframes gradientFlow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Container */
        .container {
            max-width: 900px;
            margin: 70px auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            padding: 50px 40px;
            text-align: center;
            animation: fadeIn 1.2s ease-in-out;
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(30px);}
            to {opacity: 1; transform: translateY(0);}
        }

        /* Header */
        h1 {
            font-size: 2.5rem;
            color: #e91e63; /* Rose Pink */
            margin-bottom: 15px;
            letter-spacing: 1px;
        }
        .subtitle {
            font-size: 1.2rem;
            color: #777;
            margin-bottom: 40px;
        }

        /* Order ID */
        .order-id {
            font-size: 1.4rem;
            color: #ab47bc; /* Soft Purple */
            font-weight: bold;
            margin-bottom: 25px;
            background: #f3e5f5;
            padding: 10px 20px;
            border-radius: 12px;
            display: inline-block;
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 25px 0;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 14px 18px;
            text-align: center;
        }
        th {
            background: #ec407a;
            color: #fff;
            font-size: 1rem;
        }
        tr:nth-child(even) {
            background: #fce4ec;
        }
        td {
            font-size: 1rem;
            color: #444;
        }

        /* Buttons */
        .btn {
            display: inline-block;
            background: linear-gradient(135deg, #f06292, #ec407a, #d81b60);
            color: #fff;
            padding: 14px 28px;
            border-radius: 30px;
            font-weight: bold;
            margin: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(233,30,99,0.3);
        }
        .btn:hover {
            transform: translateY(-4px) scale(1.05);
            box-shadow: 0 12px 25px rgba(233,30,99,0.4);
        }

        /* Responsive */
        @media(max-width: 768px){
            .container { padding: 30px 20px; }
            h1 { font-size: 2rem; }
            .order-id { font-size: 1rem; }
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
        <h1>💄 Thank You, Gorgeous!</h1>
        <p class="subtitle">Your glam package is on its way ✨</p>
        <p class="order-id">Your Order ID: <%=orderId%></p>

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
                <td><%=pid%></td>
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