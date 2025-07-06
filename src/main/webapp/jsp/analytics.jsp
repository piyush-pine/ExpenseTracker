<%@ page import="java.util.Map" %>
<%@ page import="com.mycompany.expensetracker.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    Map<String, Double> totals = (Map<String, Double>) request.getAttribute("totals");
    Map<String, Double> expensesByCategory = (Map<String, Double>) request.getAttribute("expensesByCategory");

    double income = (totals != null && totals.get("income") != null) ? totals.get("income") : 0.0;
    double expense = (totals != null && totals.get("expense") != null) ? totals.get("expense") : 0.0;

    String avatar = user.getAvatar();
    if (avatar == null || avatar.isEmpty()) {
        avatar = "https://randomuser.me/api/portraits/men/32.jpg";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Analytics - Expense Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
    <style>
        .analytics-header { margin-top: 32px; margin-bottom: 24px; }
        .card { box-shadow: 0 2px 10px rgba(0,0,0,0.07); }
        .avatar { width: 40px; height: 40px; border-radius: 50%; }
    </style>
</head>
<body>
<header class="header">
    <div class="profile">
        <img src="<%= avatar %>" alt="<%= user.getUsername() %>" class="avatar">
        <span class="welcome">Analytics for <b><%= user.getUsername() %></b></span>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light btn-sm ms-3">Dashboard</a>
        <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-outline-light btn-sm ms-3">Log out</a>
    </div>
</header>
<main class="container">
    <div class="analytics-header text-center">
        <h2 class="mb-3">Expense Analytics</h2>
        <p class="text-muted">See your financial summary and spending breakdown</p>
    </div>
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card text-center bg-light mb-3">
                <div class="card-header"><i class="bi bi-cash-coin text-success"></i> Total Income</div>
                <div class="card-body">
                    <h4 class="card-title text-success">$<%= String.format("%.2f", income) %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center bg-light mb-3">
                <div class="card-header"><i class="bi bi-credit-card-2-back text-danger"></i> Total Expenses</div>
                <div class="card-body">
                    <h4 class="card-title text-danger">$<%= String.format("%.2f", expense) %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center bg-light mb-3">
                <div class="card-header"><i class="bi bi-wallet2 text-primary"></i> Net Balance</div>
                <div class="card-body">
                    <h4 class="card-title text-primary">$<%= String.format("%.2f", income - expense) %></h4>
                </div>
            </div>
        </div>
    </div>
    <div class="row justify-content-center mb-4">
        <div class="col-md-8">
            <div class="card p-4">
                <h5 class="card-title text-center mb-3"><i class="bi bi-pie-chart-fill"></i> Expenses by Category</h5>
                <canvas id="categoryPieChart" height="320"></canvas>
            </div>
        </div>
    </div>
</main>
<nav class="bottom-nav">
    <a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-house-door"></i><span>Dashboard</span></a>
    <a href="#" class="active"><i class="bi bi-bar-chart"></i><span>Analytics</span></a>
    <a href="#"><i class="bi bi-list-ul"></i><span>Transactions</span></a>
    <a href="${pageContext.request.contextPath}/jsp/profile.jsp"><i class="bi bi-person"></i><span>Profile</span></a>
</nav>
<%
    StringBuilder labels = new StringBuilder();
    StringBuilder data = new StringBuilder();
    if (expensesByCategory != null && !expensesByCategory.isEmpty()) {
        for (Map.Entry<String, Double> entry : expensesByCategory.entrySet()) {
            labels.append("'").append(entry.getKey()).append("',");
            data.append(entry.getValue()).append(",");
        }
        if (labels.length() > 0) labels.setLength(labels.length() - 1);
        if (data.length() > 0) data.setLength(data.length() - 1);
    }
%>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const ctx = document.getElementById('categoryPieChart').getContext('2d');
    if ([<%= data.toString() %>].length > 0 && [<%= labels.toString() %>].length > 0) {
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: [<%= labels.toString() %>],
                datasets: [{
                    data: [<%= data.toString() %>],
                    backgroundColor: [
                        '#4e79a7', '#f28e2b', '#e15759', '#76b7b2', '#59a14f', '#edc949', '#af7aa1', '#ff9da7'
                    ],
                    borderColor: '#fff',
                    borderWidth: 2,
                    hoverOffset: 12
                }]
            },
            options: {
                responsive: true,
                cutout: '65%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { color: '#333', font: { size: 16, weight: 'bold' } }
                    },
                    title: {
                        display: false
                    },
                    datalabels: {
                        color: '#fff',
                        font: { weight: 'bold', size: 14 },
                        formatter: (value, ctx) => '$' + value.toFixed(2)
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.label + ': $' + context.parsed.toFixed(2);
                            }
                        }
                    }
                }
            },
            plugins: [ChartDataLabels]
        });
    }
});
</script>
</body>
</html>
