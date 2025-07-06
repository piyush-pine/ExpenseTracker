<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.mycompany.expensetracker.model.Transaction" %>
<%@ page import="com.mycompany.expensetracker.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    List<Transaction> userTxns = (List<Transaction>) request.getAttribute("userTxns");
    List<Transaction> recentTxns = (List<Transaction>) request.getAttribute("recentTxns");

    double balance = 0;
    if (userTxns != null) for (Transaction t : userTxns) balance += t.getAmount();

    String avatar = user.getAvatar();
    if (avatar == null || avatar.isEmpty()) {
        avatar = "https://randomuser.me/api/portraits/men/32.jpg";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Tracker Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/styles.css">
</head>
<body>
<div class="main-bg"></div>
<header class="header">
    <div class="profile">
        <img src="<%= avatar %>" alt="<%= user.getUsername() %>" class="avatar">
        <span class="welcome">Welcome back, <b><%= user.getUsername() %></b></span>
        <a href="${pageContext.request.contextPath}/jsp/profile.jsp" class="btn btn-outline-light btn-sm ms-3">Profile</a>
        <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-outline-light btn-sm ms-3">Log out</a>
    </div>
</header>
<main>
    <section class="balance-card">
        <div class="balance-label">Total Balance</div>
        <div class="balance-amount">$<%= String.format("%.2f", balance) %></div>
        <button class="add-btn" onclick="document.getElementById('add-modal').style.display='flex'"><i class="bi bi-plus-lg"></i> Add Transaction</button>
        <a href="${pageContext.request.contextPath}/export" class="btn btn-warning ms-2">Export CSV</a>
    </section>
    <section class="recent-transactions">
        <div class="section-title">Recent Transactions</div>
        <div id="transactions-list">
            <% if (recentTxns != null) {
                for (Transaction t : recentTxns) { %>
            <div class="transaction-row">
                <div class="txn-icon">
                    <% if (t.getAmount() >= 0) { %>
                        <i class="bi bi-arrow-down-circle text-success"></i>
                    <% } else { %>
                        <i class="bi bi-arrow-up-circle text-danger"></i>
                    <% } %>
                </div>
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
    <a href="${pageContext.request.contextPath}/dashboard" class="active"><i class="bi bi-house-door"></i><span>Dashboard</span></a>
    <a href="${pageContext.request.contextPath}/analytics"><i class="bi bi-bar-chart"></i><span>Analytics</span></a>
    <a href="#"><i class="bi bi-list-ul"></i><span>Transactions</span></a>
    <a href="${pageContext.request.contextPath}/jsp/profile.jsp"><i class="bi bi-person"></i><span>Profile</span></a>
</nav>
<!-- Add Transaction Modal -->
<div id="add-modal" class="modal">
    <div class="modal-content" style="max-width:400px;">
        <span class="close" onclick="document.getElementById('add-modal').style.display='none'">&times;</span>
        <h2 class="mb-3 text-center text-primary">Add Transaction</h2>
        <form action="${pageContext.request.contextPath}/addTransaction" method="post" autocomplete="off">
            <div class="mb-3">
                <label class="form-label">Type</label>
                <select name="type" class="form-select" required>
                    <option value="" disabled selected>Select type</option>
                    <option value="income">Income</option>
                    <option value="expense">Expense</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Transaction Name</label>
                <input type="text" name="name" class="form-control" placeholder="e.g. Salary, Grocery Shopping" required autofocus>
            </div>
            <div class="mb-3">
                <label class="form-label">Amount</label>
                <input type="number" name="amount" class="form-control" placeholder="e.g. 50.00" step="0.01" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Category</label>
                <select name="category" class="form-select" required>
                    <option value="" disabled selected>Select category</option>
                    <option value="Shopping">Shopping</option>
                    <option value="Food">Food</option>
                    <option value="Travel">Travel</option>
                    <option value="Bills">Bills</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Date & Time</label>
                <input type="datetime-local" name="date" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Notes</label>
                <textarea name="notes" class="form-control" placeholder="Optional notes"></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Tags</label>
                <input type="text" name="tags" class="form-control" placeholder="e.g. groceries,weekly">
            </div>
            <button type="submit" class="btn btn-success w-100 mt-2">
                <i class="bi bi-plus-lg"></i> Add Transaction
            </button>
        </form>
    </div>
</div>
</body>
</html>
