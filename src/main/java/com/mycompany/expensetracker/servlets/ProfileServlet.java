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
