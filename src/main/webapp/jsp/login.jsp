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
        <form action="${pageContext.request.contextPath}/auth" method="post">
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
        <div class="mt-4 text-center">
            <span class="text-light">New here?</span>
            <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="btn btn-success ms-2">Create a User</a>
        </div>
    </div>
</div>
</body>
</html>
