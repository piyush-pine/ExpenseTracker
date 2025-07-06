package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.dao.TransactionDAO;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

public class AnalyticsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("jsp/login.jsp");
            return;
        }
        TransactionDAO dao = new TransactionDAO();
        try {
            Map<String, Double> totals = dao.getTotalIncomeAndExpenses(user.getId());
            Map<String, Double> expensesByCategory = dao.getExpensesByCategory(user.getId());
            req.setAttribute("totals", totals);
            req.setAttribute("expensesByCategory", expensesByCategory);
            req.getRequestDispatcher("/jsp/analytics.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
