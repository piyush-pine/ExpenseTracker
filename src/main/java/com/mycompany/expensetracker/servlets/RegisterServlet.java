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
