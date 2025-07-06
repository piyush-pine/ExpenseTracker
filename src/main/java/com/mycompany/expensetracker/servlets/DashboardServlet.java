package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.dao.TransactionDAO;
import com.mycompany.expensetracker.model.Transaction;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("jsp/login.jsp");
            return;
        }
        TransactionDAO dao = new TransactionDAO();
        try {
            // All transactions for this user
            List<Transaction> userTxns = dao.getTransactionsByUserId(user.getId());
            // Recent transactions for this user (limit 10)
            List<Transaction> recentTxns = dao.getRecentTransactions(user.getId(), 10);

            // Analytics: total income/expenses and expenses by category
            Map<String, Double> totals = dao.getTotalIncomeAndExpenses(user.getId());
            Map<String, Double> expensesByCategory = dao.getExpensesByCategory(user.getId());

            req.setAttribute("userTxns", userTxns);
            req.setAttribute("recentTxns", recentTxns);
            req.setAttribute("totals", totals);
            req.setAttribute("expensesByCategory", expensesByCategory);

            req.getRequestDispatcher("/jsp/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
