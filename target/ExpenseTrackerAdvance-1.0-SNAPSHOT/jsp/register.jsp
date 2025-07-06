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
