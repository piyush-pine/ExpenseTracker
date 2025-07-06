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
