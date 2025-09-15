<%@ page import="java.util.*, java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Ensure user is logged in
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve or create cart from session
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if(cart == null) cart = new HashMap<>();

    // Add product to cart if coming from products.jsp
    String prodIdStr = request.getParameter("productId");
    String qtyStr = request.getParameter("quantity");
    if(prodIdStr != null && qtyStr != null) {
        int prodId = Integer.parseInt(prodIdStr);
        int qty = Integer.parseInt(qtyStr);
        cart.put(prodId, cart.getOrDefault(prodId, 0) + qty);

        // Save cart back to session
        session.setAttribute("cart", cart);

        // Redirect to avoid duplicate add on refresh
        response.sendRedirect("cart.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Makeup Store - Your Cart</title>
    <style>
        /* Background Gradient */
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #fff0f6, #ffe3ec, #ffeaf5);
            background-size: 300% 300%;
            animation: gradientBG 12s ease infinite;
            color: #333;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        h2 {
            text-align: center;
            color: #d63384;
            margin-bottom: 30px;
            font-size: 2.2em;
            animation: fadeIn 2s ease;
        }

        /* Navbar */
        .navbar {
            background: #d63384;
            padding: 15px 0;
            text-align: center;
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
            border-radius: 0 0 20px 20px;
            margin-bottom: 30px;
            animation: slideDown 1s ease;
        }

        .navbar a {
            color: white;
            margin: 0 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: 0.3s;
        }

        .navbar a:hover {
            color: #ffd6e9;
        }

        /* Table Styling */
        table {
            width: 85%;
            margin: auto;
            border-collapse: collapse;
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(214, 51, 132, 0.2);
            animation: fadeInUp 1.2s ease;
        }

        th, td {
            padding: 18px;
            text-align: center;
        }

        th {
            background: #d63384;
            color: white;
            font-weight: 700;
        }

        tr:nth-child(even) {
            background: #fff5fa;
        }

        /* Buttons */
        .btn {
            padding: 8px 15px;
            background: #ff6b81;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            box-shadow: 0 4px 10px rgba(255,107,129,0.3);
        }

        .btn:hover {
            background: #fa3e62;
            transform: scale(1.05);
        }

        .checkout-btn {
            display: inline-block;
            margin-top: 25px;
            padding: 14px 30px;
            background: linear-gradient(45deg, #ff6bcb, #d63384);
            color: white;
            font-weight: 700;
            border-radius: 30px;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(214, 51, 132, 0.4);
        }

        .checkout-btn:hover {
            transform: translateY(-4px);
            background: linear-gradient(45deg, #d63384, #ff6bcb);
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @keyframes fadeInUp {
            from { transform: translateY(40px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        p {
            text-align: center;
            font-size: 1.2em;
            margin-top: 20px;
            color: #d63384;
        }

        @media(max-width:768px){
            table { width: 95%; font-size: 14px; }
            .navbar a { margin: 0 10px; font-size: 14px; }
            .checkout-btn { font-size: 14px; padding: 10px 20px; }
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

    <h2>🛍 Your Beauty Cart</h2>

    <%
        double grandTotal = 0.0;

        if(cart.isEmpty()) {
    %>
        <p>Your cart is empty. <a href="products.jsp">Discover our makeup collection</a></p>
    <%
        } else {
    %>
    <table>
        <tr>
            <th>Product</th>
            <th>Price (₹)</th>
            <th>Quantity</th>
            <th>Total (₹)</th>
            <th>Action</th>
        </tr>
        <%
            try(Connection conn = DBConnection.getConnection()) {
                for(Map.Entry<Integer,Integer> entry : cart.entrySet()) {
                    int pid = entry.getKey();
                    int qty = entry.getValue();

                    String sql = "SELECT name, price FROM products WHERE id=?";
                    try(PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, pid);
                        try(ResultSet rs = ps.executeQuery()) {
                            if(rs.next()) {
                                String name = rs.getString("name");
                                double price = rs.getDouble("price");
                                double total = price * qty;
                                grandTotal += total;
        %>
        <tr>
            <td><%=name%></td>
            <td>₹<%=price%></td>
            <td><%=qty%></td>
            <td>₹<%=total%></td>
            <td>
                <a class="btn" href="cart.jsp?remove=<%=pid%>">Remove</a>
            </td>
        </tr>
        <%
                            }
                        }
                    }
                }

                // Remove product if requested
                String removeIdStr = request.getParameter("remove");
                if(removeIdStr != null) {
                    int removeId = Integer.parseInt(removeIdStr);
                    cart.remove(removeId);
                    session.setAttribute("cart", cart);
                    response.sendRedirect("cart.jsp");
                    return;
                }

            } catch(Exception e) {
                out.println("<tr><td colspan='5' style='color:red;'>Error: "+e.getMessage()+"</td></tr>");
            }
        %>
        <tr>
            <th colspan="3">Grand Total</th>
            <th colspan="2">₹ <%=grandTotal%></th>
        </tr>
    </table>
    <div style="text-align:center; margin-top:20px;">
        <a class="checkout-btn" href="checkout.jsp">💄 Proceed to Checkout</a>
    </div>
    <%
        }
    %>
</body>
</html>