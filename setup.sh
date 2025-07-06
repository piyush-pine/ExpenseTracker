#!/bin/bash

BASE_PKG="com/mycompany/expensetracker"

mkdir -p src/main/java/$BASE_PKG/dao
mkdir -p src/main/java/$BASE_PKG/model
mkdir -p src/main/java/$BASE_PKG/servlets
mkdir -p src/main/java/$BASE_PKG/util
mkdir -p src/main/webapp/jsp
mkdir -p src/main/webapp/static

# User.java
cat > src/main/java/$BASE_PKG/model/User.java << 'EOF'
package com.mycompany.expensetracker.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String avatar;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
}
EOF

# Transaction.java
cat > src/main/java/$BASE_PKG/model/Transaction.java << 'EOF'
package com.mycompany.expensetracker.model;

import java.util.Date;

public class Transaction {
    private int id;
    private String name;
    private double amount;
    private String category;
    private Date date;
    private int userId;
    private String username;
    private String notes;
    private String tags;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }
}
EOF

# DBUtil.java
cat > src/main/java/$BASE_PKG/util/DBUtil.java << 'EOF'
package com.mycompany.expensetracker.util;
import java.sql.*;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/expensetrackerdb";
    private static final String USER = "root";
    private static final String PASS = "YourNewPassword"; // <-- Change this

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(e);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
EOF

# UserDAO.java
cat > src/main/java/$BASE_PKG/dao/UserDAO.java << 'EOF'
package com.mycompany.expensetracker.dao;
import java.sql.*;
import com.mycompany.expensetracker.model.User;
import com.mycompany.expensetracker.util.DBUtil;

public class UserDAO {
    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPassword(rs.getString("password"));
                    u.setAvatar(rs.getString("avatar"));
                    return u;
                }
            }
        }
        return null;
    }
    public void addUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password, avatar) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getAvatar());
            ps.executeUpdate();
        }
    }
    public void updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET username=?, password=?, avatar=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getAvatar());
            ps.setInt(4, user.getId());
            ps.executeUpdate();
        }
    }
}
EOF

# TransactionDAO.java
cat > src/main/java/$BASE_PKG/dao/TransactionDAO.java << 'EOF'
package com.mycompany.expensetracker.dao;
import java.sql.*;
import java.util.*;
import com.mycompany.expensetracker.model.Transaction;
import com.mycompany.expensetracker.util.DBUtil;

public class TransactionDAO {
    public List<Transaction> getTransactionsByUserId(int userId) throws SQLException {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, u.username FROM transactions t JOIN users u ON t.user_id = u.id WHERE t.user_id=? ORDER BY t.date DESC, t.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setId(rs.getInt("id"));
                    t.setName(rs.getString("name"));
                    t.setAmount(rs.getDouble("amount"));
                    t.setCategory(rs.getString("category"));
                    t.setDate(rs.getTimestamp("date"));
                    t.setUserId(rs.getInt("user_id"));
                    t.setUsername(rs.getString("username"));
                    t.setNotes(rs.getString("notes"));
                    t.setTags(rs.getString("tags"));
                    list.add(t);
                }
            }
        }
        return list;
    }

    public List<Transaction> getRecentTransactions(int limit) throws SQLException {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, u.username FROM transactions t JOIN users u ON t.user_id = u.id ORDER BY t.date DESC, t.id DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setId(rs.getInt("id"));
                    t.setName(rs.getString("name"));
                    t.setAmount(rs.getDouble("amount"));
                    t.setCategory(rs.getString("category"));
                    t.setDate(rs.getTimestamp("date"));
                    t.setUserId(rs.getInt("user_id"));
                    t.setUsername(rs.getString("username"));
                    t.setNotes(rs.getString("notes"));
                    t.setTags(rs.getString("tags"));
                    list.add(t);
                }
            }
        }
        return list;
    }

    public void addTransaction(Transaction t) throws SQLException {
        String sql = "INSERT INTO transactions (name, amount, category, date, user_id, notes, tags) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setDouble(2, t.getAmount());
            ps.setString(3, t.getCategory());
            ps.setTimestamp(4, new java.sql.Timestamp(t.getDate().getTime()));
            ps.setInt(5, t.getUserId());
            ps.setString(6, t.getNotes());
            ps.setString(7, t.getTags());
            ps.executeUpdate();
        }
    }
}
EOF

# AuthServlet.java
cat > src/main/java/$BASE_PKG/servlets/AuthServlet.java << 'EOF'
package com.mycompany.expensetracker.servlets;
import com.mycompany.expensetracker.dao.UserDAO;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

public class AuthServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        UserDAO dao = new UserDAO();
        try {
            User user = dao.getUserByUsername(username);
            if (user != null && user.getPassword().equals(password)) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                resp.sendRedirect("dashboard");
            } else {
                req.setAttribute("error", "Invalid credentials.");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
EOF

# RegisterServlet.java
cat > src/main/java/$BASE_PKG/servlets/RegisterServlet.java << 'EOF'
package com.mycompany.expensetracker.servlets;
import com.mycompany.expensetracker.dao.UserDAO;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String avatar = req.getParameter("avatar");
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setAvatar(avatar);
        UserDAO dao = new UserDAO();
        try {
            if (dao.getUserByUsername(username) != null) {
                req.setAttribute("error", "Username already exists.");
                req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
                return;
            }
            dao.addUser(user);
            resp.sendRedirect("jsp/login.jsp");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
EOF

# ProfileServlet.java
cat > src/main/java/$BASE_PKG/servlets/ProfileServlet.java << 'EOF'
package com.mycompany.expensetracker.servlets;
import com.mycompany.expensetracker.dao.UserDAO;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

public class ProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("jsp/login.jsp");
            return;
        }
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String avatar = req.getParameter("avatar");
        if (username != null && !username.isEmpty()) user.setUsername(username);
        if (password != null && !password.isEmpty()) user.setPassword(password);
        if (avatar != null && !avatar.isEmpty()) user.setAvatar(avatar);
        UserDAO dao = new UserDAO();
        try {
            dao.updateUser(user);
            req.getSession().setAttribute("user", user);
            resp.sendRedirect("jsp/profile.jsp");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
EOF

# DashboardServlet.java
cat > src/main/java/$BASE_PKG/servlets/DashboardServlet.java << 'EOF'
package com.mycompany.expensetracker.servlets;
import com.mycompany.expensetracker.dao.TransactionDAO;
import com.mycompany.expensetracker.model.Transaction;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("jsp/login.jsp");
            return;
        }
        TransactionDAO dao = new TransactionDAO();
        try {
            List<Transaction> userTxns = dao.getTransactionsByUserId(user.getId());
            List<Transaction> recentTxns = dao.getRecentTransactions(10);
            req.setAttribute("userTxns", userTxns);
            req.setAttribute("recentTxns", recentTxns);
            req.getRequestDispatcher("/jsp/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
EOF

# AddTransactionServlet.java
cat > src/main/java/$BASE_PKG/servlets/AddTransactionServlet.java << 'EOF'
package com.mycompany.expensetracker.servlets;
import com.mycompany.expensetracker.dao.TransactionDAO;
import com.mycompany.expensetracker.model.Transaction;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

public class AddTransactionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("jsp/login.jsp");
            return;
        }
        Transaction t = new Transaction();
        t.setName(req.getParameter("name"));
        t.setAmount(Double.parseDouble(req.getParameter("amount")));
        t.setCategory(req.getParameter("category"));
        t.setNotes(req.getParameter("notes"));
        t.setTags(req.getParameter("tags"));
        try {
            String dateStr = req.getParameter("date");
            java.util.Date date = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(dateStr);
            t.setDate(date);
        } catch (Exception ex) {
            t.setDate(new java.util.Date());
        }
        t.setUserId(user.getId());
        TransactionDAO dao = new TransactionDAO();
        try {
            dao.addTransaction(t);
            resp.sendRedirect("dashboard");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
EOF

# ExportServlet.java (CSV only)
cat > src/main/java/$BASE_PKG/servlets/ExportServlet.java << 'EOF'
package com.mycompany.expensetracker.servlets;
import com.mycompany.expensetracker.dao.TransactionDAO;
import com.mycompany.expensetracker.model.Transaction;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.SQLException;
import java.util.List;

public class ExportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("jsp/login.jsp");
            return;
        }
        TransactionDAO dao = new TransactionDAO();
        try {
            List<Transaction> txns = dao.getTransactionsByUserId(user.getId());
            resp.setContentType("text/csv");
            resp.setHeader("Content-Disposition", "attachment; filename=\"transactions.csv\"");
            PrintWriter out = resp.getWriter();
            out.println("Name,Amount,Category,Date,Notes,Tags");
            for (Transaction t : txns) {
                out.printf("\"%s\",%.2f,\"%s\",\"%s\",\"%s\",\"%s\"%n",
                    t.getName(), t.getAmount(), t.getCategory(),
                    new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(t.getDate()),
                    t.getNotes() == null ? "" : t.getNotes().replace("\"","\"\""),
                    t.getTags() == null ? "" : t.getTags().replace("\"","\"\"")
                );
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
EOF

# login.jsp
cat > src/main/webapp/jsp/login.jsp << 'EOF'
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Tracker Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../static/styles.css">
</head>
<body class="dark-bg">
<div class="container d-flex justify-content-center align-items-center" style="height:100vh;">
    <div class="login-card p-4 rounded shadow-lg">
        <h2 class="mb-4 text-center text-primary">Expense Tracker</h2>
        <form action="../auth" method="post">
            <div class="mb-3">
                <input type="text" name="username" class="form-control" placeholder="Username" required autofocus>
            </div>
            <div class="mb-3">
                <input type="password" name="password" class="form-control" placeholder="Password" required>
            </div>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>
        <div class="mt-3 text-center">
            <a href="register.jsp" class="text-light">New user? Register</a>
        </div>
    </div>
</div>
</body>
</html>
EOF

# register.jsp
cat > src/main/webapp/jsp/register.jsp << 'EOF'
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Expense Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../static/styles.css">
</head>
<body class="dark-bg">
<div class="container d-flex justify-content-center align-items-center" style="height:100vh;">
    <div class="login-card p-4 rounded shadow-lg">
        <h2 class="mb-4 text-center text-primary">Register</h2>
        <form action="../register" method="post">
            <div class="mb-3">
                <input type="text" name="username" class="form-control" placeholder="Username" required autofocus>
            </div>
            <div class="mb-3">
                <input type="password" name="password" class="form-control" placeholder="Password" required>
            </div>
            <div class="mb-3">
                <input type="text" name="avatar" class="form-control" placeholder="Avatar URL (optional)">
            </div>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <button type="submit" class="btn btn-primary w-100">Register</button>
        </form>
        <div class="mt-3 text-center">
            <a href="login.jsp" class="text-light">Already have an account? Login</a>
        </div>
    </div>
</div>
</body>
</html>
EOF

# profile.jsp
cat > src/main/webapp/jsp/profile.jsp << 'EOF'
<%@ page import="com.mycompany.expensetracker.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Profile - Expense Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../static/styles.css">
</head>
<body>
<div class="container mt-5">
    <div class="profile-card p-4 rounded shadow-lg mx-auto" style="max-width:400px;">
        <h2 class="mb-4 text-center text-primary">Profile</h2>
        <form action="../profile" method="post">
            <div class="mb-3 text-center">
                <img src="<%= user.getAvatar() != null ? user.getAvatar() : 'https://randomuser.me/api/portraits/men/32.jpg' %>" alt="avatar" class="avatar mb-2" style="width:80px;">
            </div>
            <div class="mb-3">
                <label>Username</label>
                <input type="text" name="username" class="form-control" value="<%= user.getUsername() %>" required>
            </div>
            <div class="mb-3">
                <label>New Password</label>
                <input type="password" name="password" class="form-control" placeholder="Leave blank to keep unchanged">
            </div>
            <div class="mb-3">
                <label>Avatar URL</label>
                <input type="text" name="avatar" class="form-control" value="<%= user.getAvatar() %>">
            </div>
            <button type="submit" class="btn btn-primary w-100">Update Profile</button>
        </form>
    </div>
</div>
</body>
</html>
EOF

# dashboard.jsp (add notes/tags and export button)
cat > src/main/webapp/jsp/dashboard.jsp << 'EOF'
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.expensetracker.model.Transaction" %>
<%@ page import="com.mycompany.expensetracker.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    List<Transaction> userTxns = (List<Transaction>) request.getAttribute("userTxns");
    List<Transaction> recentTxns = (List<Transaction>) request.getAttribute("recentTxns");
    double balance = 0;
    if (userTxns != null) for (Transaction t : userTxns) balance += t.getAmount();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Tracker Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="../static/styles.css">
</head>
<body>
<div class="main-bg"></div>
<header class="header">
    <div class="profile">
        <img src="<%= user.getAvatar() != null ? user.getAvatar() : 'https://randomuser.me/api/portraits/men/32.jpg' %>" alt="<%= user.getUsername() %>" class="avatar">
        <span class="welcome">Welcome back, <b><%= user.getUsername() %></b></span>
        <a href="../jsp/profile.jsp" class="btn btn-outline-light btn-sm ms-3">Profile</a>
        <a href="../jsp/login.jsp" class="btn btn-outline-light btn-sm ms-3">Log out</a>
    </div>
</header>
<main>
    <section class="balance-card">
        <div class="balance-label">Total Balance</div>
        <div class="balance-amount">$<%= String.format("%.2f", balance) %></div>
        <button class="add-btn" onclick="document.getElementById('add-modal').style.display='flex'"><i class="bi bi-plus-lg"></i> Add Transaction</button>
        <a href="../export" class="btn btn-warning ms-2">Export CSV</a>
    </section>
    <section class="recent-transactions">
        <div class="section-title">Recent Transactions</div>
        <div id="transactions-list">
            <% if (recentTxns != null) {
                for (Transaction t : recentTxns) { %>
            <div class="transaction-row">
                <div class="txn-icon"><i class="bi bi-cash-stack"></i></div>
                <div class="txn-details">
                    <div class="txn-name"><%= t.getName() %></div>
                    <div class="txn-meta"><%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(t.getDate()) %></div>
                    <div class="txn-notes"><%= t.getNotes() != null ? t.getNotes() : "" %></div>
                    <div class="txn-tags text-info"><%= t.getTags() != null ? t.getTags() : "" %></div>
                </div>
                <div class="txn-amount <%= t.getAmount() < 0 ? "negative" : "positive" %>">
                    <%= t.getAmount() < 0 ? "-" : "+" %>$<%= String.format("%.2f", Math.abs(t.getAmount())) %>
                    <span class="txn-user">by <%= t.getUsername() %></span>
                </div>
            </div>
            <% } } %>
        </div>
    </section>
</main>
<nav class="bottom-nav">
    <a href="#" class="active"><i class="bi bi-house-door"></i><span>Dashboard</span></a>
    <a href="#"><i class="bi bi-bar-chart"></i><span>Analytics</span></a>
    <a href="#"><i class="bi bi-list-ul"></i><span>Transactions</span></a>
    <a href="../jsp/profile.jsp"><i class="bi bi-person"></i><span>Profile</span></a>
</nav>
<!-- Add Transaction Modal -->
<div id="add-modal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="document.getElementById('add-modal').style.display='none'">&times;</span>
        <h2>Add Transaction</h2>
        <form action="../addTransaction" method="post">
            <input type="text" name="name" placeholder="Transaction Name" required>
            <input type="number" name="amount" placeholder="Amount" step="0.01" required>
            <select name="category" required>
                <option value="" disabled selected>Category</option>
                <option value="Shopping">Shopping</option>
                <option value="Food">Food</option>
                <option value="Travel">Travel</option>
                <option value="Bills">Bills</option>
                <option value="Other">Other</option>
            </select>
            <input type="datetime-local" name="date" required>
            <textarea name="notes" class="form-control" placeholder="Notes"></textarea>
            <input type="text" name="tags" class="form-control" placeholder="Tags (comma separated)">
            <button type="submit" class="add-btn-modal">Add</button>
        </form>
    </div>
</div>
</body>
</html>
EOF

# styles.css (add your custom CSS here)
cat > src/main/webapp/static/styles.css << 'EOF'
/* Paste your modern dark theme, responsive, Bootstrap-enhanced CSS here */
EOF

# web.xml
cat > src/main/webapp/WEB-INF/web.xml << 'EOF'
<web-app>
    <servlet>
        <servlet-name>AuthServlet</servlet-name>
        <servlet-class>com.mycompany.expensetracker.servlets.AuthServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>AuthServlet</servlet-name>
        <url-pattern>/auth</url-pattern>
    </servlet-mapping>

    <servlet>
        <servlet-name>RegisterServlet</servlet-name>
        <servlet-class>com.mycompany.expensetracker.servlets.RegisterServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>RegisterServlet</servlet-name>
        <url-pattern>/register</url-pattern>
    </servlet-mapping>

    <servlet>
        <servlet-name>ProfileServlet</servlet-name>
        <servlet-class>com.mycompany.expensetracker.servlets.ProfileServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>ProfileServlet</servlet-name>
        <url-pattern>/profile</url-pattern>
    </servlet-mapping>

    <servlet>
        <servlet-name>DashboardServlet</servlet-name>
        <servlet-class>com.mycompany.expensetracker.servlets.DashboardServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>DashboardServlet</servlet-name>
        <url-pattern>/dashboard</url-pattern>
    </servlet-mapping>

    <servlet>
        <servlet-name>AddTransactionServlet</servlet-name>
        <servlet-class>com.mycompany.expensetracker.servlets.AddTransactionServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>AddTransactionServlet</servlet-name>
        <url-pattern>/addTransaction</url-pattern>
    </servlet-mapping>

    <servlet>
        <servlet-name>ExportServlet</servlet-name>
        <servlet-class>com.mycompany.expensetracker.servlets.ExportServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>ExportServlet</servlet-name>
        <url-pattern>/export</url-pattern>
    </servlet-mapping>

    <welcome-file-list>
        <welcome-file>jsp/login.jsp</welcome-file>
    </welcome-file-list>
</web-app>
EOF

# Add MySQL JDBC dependency to pom.xml if not present
if ! grep -q "mysql-connector-j" pom.xml; then
    awk '/<\/dependencies>/{
        print "    <dependency>\n      <groupId>com.mysql</groupId>\n      <artifactId>mysql-connector-j</artifactId>\n      <version>8.3.0</version>\n    </dependency>";
    }1' pom.xml > pom.xml.tmp && mv pom.xml.tmp pom.xml
fi

echo "✅ All files created and code inserted!"
echo "⚠️  Please update your DB password in src/main/java/com/mycompany/expensetracker/util/DBUtil.java"
echo "⚡️ Clean and build your project in NetBeans, then deploy to your server."
echo ""
echo "👉 MySQL Table Example:"
echo "CREATE TABLE users ("
echo "  id INT PRIMARY KEY AUTO_INCREMENT,"
echo "  username VARCHAR(50) UNIQUE NOT NULL,"
echo "  password VARCHAR(100) NOT NULL,"
echo "  avatar VARCHAR(255)"
echo ");"
echo ""
echo "CREATE TABLE transactions ("
echo "  id INT PRIMARY KEY AUTO_INCREMENT,"
echo "  name VARCHAR(100),"
echo "  amount DOUBLE,"
echo "  category VARCHAR(30),"
echo "  date DATETIME,"
echo "  user_id INT,"
echo "  notes TEXT,"
echo "  tags VARCHAR(255),"
echo "  FOREIGN KEY (user_id) REFERENCES users(id)"
echo ");"
