package com.mycompany.expensetracker.dao;

import java.sql.*;
import java.util.*;
import com.mycompany.expensetracker.model.Transaction;
import com.mycompany.expensetracker.util.DBUtil;

public class TransactionDAO {
    public List<Transaction> getTransactionsByUserId(int userId) throws SQLException {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, u.username FROM transactions t JOIN users u ON t.user_id = u.id WHERE t.user_id=? ORDER BY t.date DESC, t.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setId(rs.getInt("id"));
                    t.setName(rs.getString("name"));
                    t.setAmount(rs.getDouble("amount"));
                    t.setCategory(rs.getString("category"));
                    t.setDate(rs.getTimestamp("date"));
                    t.setUserId(rs.getInt("user_id"));
                    t.setUsername(rs.getString("username"));
                    t.setNotes(rs.getString("notes"));
                    t.setTags(rs.getString("tags"));
                    t.setType(rs.getString("type")); // Ensure you have getType/setType in your model
                    list.add(t);
                }
            }
        }
        return list;
    }

    public List<Transaction> getRecentTransactions(int userId, int limit) throws SQLException {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, u.username FROM transactions t JOIN users u ON t.user_id = u.id WHERE t.user_id = ? ORDER BY t.date DESC, t.id DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setId(rs.getInt("id"));
                    t.setName(rs.getString("name"));
                    t.setAmount(rs.getDouble("amount"));
                    t.setCategory(rs.getString("category"));
                    t.setDate(rs.getTimestamp("date"));
                    t.setUserId(rs.getInt("user_id"));
                    t.setUsername(rs.getString("username"));
                    t.setNotes(rs.getString("notes"));
                    t.setTags(rs.getString("tags"));
                    t.setType(rs.getString("type"));
                    list.add(t);
                }
            }
        }
        return list;
    }

    public void addTransaction(Transaction t) throws SQLException {
        String sql = "INSERT INTO transactions (name, amount, category, date, user_id, notes, tags, type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setDouble(2, t.getAmount());
            ps.setString(3, t.getCategory());
            ps.setTimestamp(4, new java.sql.Timestamp(t.getDate().getTime()));
            ps.setInt(5, t.getUserId());
            ps.setString(6, t.getNotes());
            ps.setString(7, t.getTags());
            ps.setString(8, t.getType()); // Set the type (income/expense)
            ps.executeUpdate();
        }
    }

    // Analytics: Total income and total expenses for the user
    public Map<String, Double> getTotalIncomeAndExpenses(int userId) throws SQLException {
        Map<String, Double> result = new HashMap<>();
        String sql = "SELECT type, SUM(amount) as total FROM transactions WHERE user_id = ? GROUP BY type";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("type"), rs.getDouble("total"));
                }
            }
        }
        return result;
    }

    // Analytics: Expenses by category for the user
    public Map<String, Double> getExpensesByCategory(int userId) throws SQLException {
        Map<String, Double> result = new HashMap<>();
        String sql = "SELECT category, SUM(amount) as total FROM transactions WHERE user_id = ? AND type = 'expense' GROUP BY category";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("category"), rs.getDouble("total"));
                }
            }
        }
        return result;
    }
}
