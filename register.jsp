<%@ page import="java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>GlamUp - Register</title>
    <style>
        /* Reset and box-sizing */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #fff0f6, #ffe5ec, #ffd6e0);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #333;
        }

        /* Container */
        .form-container {
            background: #fff;
            padding: 40px 35px;
            border-radius: 20px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.1);
            width: 420px;
            animation: slideIn 1s ease-in-out;
            position: relative;
            overflow: hidden;
            z-index: 1; /* ✅ Keep form on top */
        }

        /* Glow effect */
        .form-container::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,182,193,0.2), transparent);
            transform: rotate(25deg);
            transition: all 0.5s ease;
            z-index: -1; /* ✅ Push background behind inputs */
        }
        .form-container:hover::before {
            top: -30%;
            left: -30%;
        }

        /* Heading */
        .form-container h2 {
            text-align: center;
            color: #ff4c68;
            font-size: 2.2em;
            font-weight: 700;
            margin-bottom: 25px;
            letter-spacing: 1px;
        }

        /* Label */
        label {
            display: block;
            margin-top: 15px;
            font-weight: 500;
            color: #555;
            font-size: 0.95em;
        }

        /* Inputs */
        input, textarea, select {
            width: 100%;
            padding: 10px 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 12px;
            font-size: 0.95em;
            transition: all 0.3s ease;
        }

        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #ff4c68;
            box-shadow: 0 0 10px rgba(255, 76, 104, 0.2);
        }

        /* Button */
        button {
            margin-top: 25px;
            padding: 12px;
            width: 100%;
            border: none;
            background: linear-gradient(90deg, #ff8fab, #ff4c68);
            color: white;
            font-weight: bold;
            font-size: 1em;
            border-radius: 30px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        button:hover {
            background: linear-gradient(90deg, #ff4c68, #ff8fab);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(255, 76, 104, 0.25);
        }

        /* Messages */
        .success, .error {
            text-align: center;
            margin-top: 18px;
            font-weight: 500;
            font-size: 0.95em;
        }

        .success { color: #38a169; }
        .error { color: #e53e3e; }

        a {
            color: #ff4c68;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        a:hover {
            text-decoration: underline;
        }

        /* Animations */
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-25px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media(max-width: 450px) {
            .form-container {
                width: 90%;
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Create Your GlamUp Account</h2>
        <form method="post">
            <label>Full Name:</label>
            <input type="text" name="fullname" required>

            <label>Email:</label>
            <input type="email" name="email" required>

            <label>Password:</label>
            <input type="password" name="password" required>

            <label>Gender:</label>
            <select name="gender" required>
                <option value="">Select</option>
                <option value="Female">Female</option>
                <option value="Male">Male</option>
                <option value="Other">Other</option>
            </select>

            <label>Date of Birth:</label>
            <input type="date" name="dob" required>

            <label>Phone:</label>
            <input type="text" name="phone" required>

            <label>Address:</label>
            <textarea name="address" rows="3"></textarea>

            <label>Role:</label>
            <select name="role" required>
                <option value="User" selected>User</option>
                <option value="Admin">Admin</option>
                <option value="Guest">Guest</option>
            </select>

            <button type="submit">Register</button>
        </form>

        <%
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String gender = request.getParameter("gender");
            String dob = request.getParameter("dob");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String role = request.getParameter("role");

            if (fullname != null && email != null && password != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    conn = DBConnection.getConnection();

                    // ✅ Check if email already exists
                    ps = conn.prepareStatement("SELECT id FROM users WHERE email=?");
                    ps.setString(1, email);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        out.println("<p class='error'>Email already exists! Try another.</p>");
                    } else {
                        // ✅ Insert new user
                        ps.close();
                        ps = conn.prepareStatement(
                            "INSERT INTO users(fullname,email,password,gender,dob,phone,address,role) VALUES (?,?,?,?,?,?,?,?)"
                        );
                        ps.setString(1, fullname);
                        ps.setString(2, email);
                        ps.setString(3, password);
                        ps.setString(4, gender);
                        ps.setString(5, dob);
                        ps.setString(6, phone);
                        ps.setString(7, address);
                        ps.setString(8, role);

                        int rows = ps.executeUpdate();
                        if (rows > 0) {
                            out.println("<p class='success'>Registration successful! <a href='login.jsp'>Login here</a></p>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
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
