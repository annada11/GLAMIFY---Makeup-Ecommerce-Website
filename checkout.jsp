<%@ page import="java.util.*,java.sql.*,com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) { response.sendRedirect("login.jsp"); return; }

    Map<Integer,Integer> cart = (Map<Integer,Integer>) session.getAttribute("cart");
    if(cart == null || cart.isEmpty()) { response.sendRedirect("cart.jsp"); return; }

    double grandTotal = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout - Confirm Order</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fce4ec, #f8bbd0, #f48fb1);
            margin: 0;
            padding: 0;
            color: #333;
            animation: fadeIn 1s ease-in-out;
        }

        header {
            background: linear-gradient(to right, #ec407a, #d81b60);
            padding: 25px;
            text-align: center;
            color: #fff;
            font-size: 2.2em;
            font-weight: bold;
            letter-spacing: 2px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            border-bottom-left-radius: 30px;
            border-bottom-right-radius: 30px;
        }

        h2 {
            text-align: center;
            margin: 30px 0;
            color: #880e4f;
            font-size: 1.8em;
            animation: slideDown 1s ease;
        }

        table {
            width: 85%;
            margin: auto;
            border-collapse: collapse;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            background: #fff;
            animation: fadeUp 1s ease;
        }

        th, td {
            padding: 14px;
            text-align: center;
        }

        th {
            background: #ec407a;
            color: white;
            font-weight: bold;
            font-size: 1.1em;
        }

        tr:nth-child(even) {
            background: #fce4ec;
        }

        tr:hover {
            background: #f8bbd0;
            transition: 0.3s;
        }

        textarea, select {
            width: 60%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 10px;
            font-size: 1em;
            margin-top: 8px;
            transition: all 0.3s ease;
        }

        textarea:focus, select:focus {
            outline: none;
            border-color: #ec407a;
            box-shadow: 0 0 8px rgba(236,64,122,0.5);
        }

        .btn {
            display: inline-block;
            padding: 14px 30px;
            margin-top: 25px;
            background: linear-gradient(45deg, #ec407a, #d81b60);
            color: white;
            border: none;
            border-radius: 50px;
            font-weight: bold;
            cursor: pointer;
            font-size: 1.1em;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(236,64,122,0.3);
        }

        .btn:hover {
            background: linear-gradient(45deg, #d81b60, #ad1457);
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0,0,0,0.25);
        }

        form {
            text-align: center;
            margin-top: 40px;
            background: #fff;
            padding: 25px;
            border-radius: 20px;
            width: 70%;
            margin-left: auto;
            margin-right: auto;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            animation: fadeUp 1.2s ease;
        }

        label {
            font-weight: 600;
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            color: #880e4f;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { transform: translateY(-30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @keyframes fadeUp {
            from { transform: translateY(30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @media(max-width: 768px) {
            table { width: 95%; }
            textarea, select { width: 90%; }
            form { width: 90%; }
        }
    </style>
</head>
<body>
    <header>💄 Checkout - Glamify Cosmetics</header>

    <h2>Confirm Your Beautiful Order ✨</h2>

    <table>
        <tr><th>Product</th><th>Quantity</th><th>Price (₹)</th><th>Total (₹)</th></tr>
        <%
            try(Connection conn = DBConnection.getConnection()) {
                for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
                    int pid = entry.getKey();
                    int qty = entry.getValue();

                    PreparedStatement ps = conn.prepareStatement("SELECT name, price FROM products WHERE id=?");
                    ps.setInt(1, pid);
                    ResultSet rs = ps.executeQuery();
                    if(rs.next()){
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        double total = price * qty;
                        grandTotal += total;
        %>
                        <tr>
                            <td><%=name%></td>
                            <td><%=qty%></td>
                            <td>₹<%=price%></td>
                            <td>₹<%=total%></td>
                        </tr>
        <%
                    }
                    rs.close(); ps.close();
                }
            } catch(Exception e){ out.println("<tr><td colspan='4'>Error: "+e.getMessage()+"</td></tr>"); }
        %>
        <tr><th colspan="3">Grand Total</th><th>₹<%=grandTotal%></th></tr>
    </table>

    <form action="placeOrder.jsp" method="post">
        <label>Shipping Address:</label>
        <textarea name="address" rows="3" required></textarea>

        <label>Payment Method:</label>
        <select name="payment" required>
            <option value="Cash on Delivery">💵 Cash on Delivery</option>
            <option value="Online Payment">💳 Online Payment</option>
        </select>

        <button type="submit" class="btn">Confirm & Pay 💖</button>
    </form>
</body>
</html>