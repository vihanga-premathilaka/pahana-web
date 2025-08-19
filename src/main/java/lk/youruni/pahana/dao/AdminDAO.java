package lk.youruni.pahana.dao;

import lk.youruni.pahana.model.Admin;
import java.sql.*;

public class AdminDAO {
    public Admin findByUsernameAndPassword(String username, String password) throws Exception {
        String sql = "SELECT * FROM admin WHERE username=? AND password=?";
        try (Connection con = lk.youruni.pahana.config.DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setPassword(rs.getString("password"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setEmail(rs.getString("email"));
                    return admin;
                }
            }
        }
        return null;
    }
}
