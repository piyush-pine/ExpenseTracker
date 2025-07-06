package com.mycompany.expensetracker.servlets;
import com.mycompany.expensetracker.dao.TransactionDAO;
import com.mycompany.expensetracker.model.Transaction;
import com.mycompany.expensetracker.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.SQLException;
import java.util.List;

public class ExportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("jsp/login.jsp");
            return;
        }
        TransactionDAO dao = new TransactionDAO();
        try {
            List<Transaction> txns = dao.getTransactionsByUserId(user.getId());
            resp.setContentType("text/csv");
            resp.setHeader("Content-Disposition", "attachment; filename=\"transactions.csv\"");
            PrintWriter out = resp.getWriter();
            out.println("Name,Amount,Category,Date,Notes,Tags");
            for (Transaction t : txns) {
                out.printf("\"%s\",%.2f,\"%s\",\"%s\",\"%s\",\"%s\"%n",
                    t.getName(), t.getAmount(), t.getCategory(),
                    new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(t.getDate()),
                    t.getNotes() == null ? "" : t.getNotes().replace("\"","\"\""),
                    t.getTags() == null ? "" : t.getTags().replace("\"","\"\"")
                );
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
