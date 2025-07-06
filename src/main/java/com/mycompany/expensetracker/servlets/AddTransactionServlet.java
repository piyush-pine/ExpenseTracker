package com.mycompany.expensetracker.servlets;

import com.mycompany.expensetracker.dao.TransactionDAO;
import com.mycompany.expensetracker.model.Transaction;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

public class AddTransactionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        java.util.Enumeration<String> params = req.getParameterNames();
        while (params.hasMoreElements()) {
            String param = params.nextElement();
            System.out.println("PARAM: " + param + " = " + req.getParameter(param));
        }

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("jsp/login.jsp");
            return;
        }
        Transaction t = new Transaction();
        t.setName(req.getParameter("name"));

        String type = req.getParameter("type");
        double amount = Double.parseDouble(req.getParameter("amount"));

        System.out.println("DEBUG: type=" + type + ", amount=" + amount);

        if ("expense".equals(type)) {
            amount = -Math.abs(amount);
        } else {
            amount = Math.abs(amount);
        }
        System.out.println("DEBUG: final amount to store=" + amount);
        t.setAmount(amount);

        t.setCategory(req.getParameter("category"));
        t.setNotes(req.getParameter("notes"));
        t.setTags(req.getParameter("tags"));
        try {
            String dateStr = req.getParameter("date");
            java.util.Date date = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(dateStr);
            t.setDate(date);
        } catch (Exception ex) {
            t.setDate(new java.util.Date());
        }
        t.setUserId(user.getId());
        TransactionDAO dao = new TransactionDAO();
        try {
            dao.addTransaction(t);
            resp.sendRedirect("dashboard");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
