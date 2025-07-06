package com.mycompany.expensetracker.dao;
import java.sql.*;
import com.mycompany.expensetracker.model.User;
import com.mycompany.expensetracker.util.DBUtil;

public class UserDAO {
    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPassword(rs.getString("password"));
                    u.setAvatar(rs.getString("avatar"));
                    return u;
                }
            }
        }
        return null;
    }
    public void addUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password, avatar) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getAvatar());
            ps.executeUpdate();
        }
    }
    public void updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET username=?, password=?, avatar=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getAvatar());
            ps.setInt(4, user.getId());
            ps.executeUpdate();
        }
    }
}
