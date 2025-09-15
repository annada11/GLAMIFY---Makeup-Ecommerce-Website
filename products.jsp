<%@ page import="java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - GlamUp Cosmetics</title>
    <style>
        /* Reset */
        * { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fff5f8, #ffeaea);
            padding: 20px;
            color: #333;
        }

        /* Navbar */
        .navbar {
            text-align: center;
            background: linear-gradient(90deg, #ff8fab, #ff4c68);
            padding: 15px 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            border-radius: 50px;
            margin-bottom: 40px;
        }

        .navbar a {
            color: white;
            margin: 0 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .navbar a:hover {
            color: #ffe6e6;
            transform: scale(1.1);
        }

        /* Page title */
        h2 {
            text-align: center;
            color: #ff4c68;
            margin-bottom: 30px;
            font-size: 2.2em;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* Products grid */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 25px;
            width: 90%;
            margin: auto;
        }

        /* Product card */
        .card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1; /* ✅ keep content above pseudo-element */
        }

        .card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,182,193,0.2), transparent);
            transform: rotate(25deg);
            transition: all 0.5s ease;
            z-index: -1; /* ✅ push behind inputs */
        }

        .card:hover {
            transform: translateY(-8px);
        }

        .card:hover::before {
            top: -30%;
            left: -30%;
        }

        .card h3 {
            color: #ff4c68;
            margin-bottom: 10px;
            font-size: 1.3em;
        }

        .card p {
            font-size: 0.9em;
            margin-bottom: 10px;
            color: #555;
        }

        .price {
            font-weight: bold;
            font-size: 1.2em;
            color: #ff4c68;
            margin: 10px 0;
        }

        input[type="number"] {
            width: 60px;
            padding: 6px;
            border-radius: 8px;
            border: 1px solid #ccc;
            text-align: center;
            margin-bottom: 10px;
        }

        .btn {
            padding: 8px 16px;
            background: linear-gradient(90deg, #ff8fab, #ff4c68);
            color: #fff;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: bold;
        }

        .btn:hover {
            background: linear-gradient(90deg, #ff4c68, #ff8fab);
            transform: scale(1.05);
        }

        /* Responsive */
        @media(max-width:768px){
            .navbar a { margin: 0 10px; font-size: 14px; }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Products</a>
        <a href="cart.jsp">Cart</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <h2>Our Glam Collection</h2>

    <div class="products-grid">
        <%
            try(Connection conn = DBConnection.getConnection()) {
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM products");
                while(rs.next()){
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String desc = rs.getString("description");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
        %>
            <div class="card">
                <h3><%=name%></h3>
                <p><%=desc%></p>
                <div class="price">₹<%=price%></div>
                <p>In Stock: <%=stock%></p>
                <form action="cart.jsp" method="get">
                    <input type="number" name="quantity" value="1" min="1" max="<%=stock%>" required><br>
                    <input type="hidden" name="productId" value="<%=id%>">
                    <button type="submit" class="btn">Add to Cart</button>
                </form>
            </div>
        <%
                }
                rs.close();
                st.close();
            } catch(Exception e){
                out.println("<p style='color:red; text-align:center;'>Error: "+e.getMessage()+"</p>");
            }
        %>
    </div>
</body>
</html>
