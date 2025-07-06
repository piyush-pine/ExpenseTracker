<%@ page import="com.mycompany.expensetracker.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    String avatar = user.getAvatar();
    if (avatar == null || avatar.isEmpty()) {
        avatar = "https://randomuser.me/api/portraits/men/32.jpg";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Profile - Expense Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/styles.css">
</head>
<body>
<div class="container mt-5">
    <div class="profile-card p-4 rounded shadow-lg mx-auto" style="max-width:400px;">
        <h2 class="mb-4 text-center text-primary">Profile</h2>
        <form action="${pageContext.request.contextPath}/profile" method="post">
            <div class="mb-3 text-center">
                <img src="<%= avatar %>" alt="avatar" class="avatar mb-2" style="width:80px;">
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
