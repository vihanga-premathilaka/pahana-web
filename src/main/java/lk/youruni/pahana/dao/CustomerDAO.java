package lk.youruni.pahana.dao;

import lk.youruni.pahana.model.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    private final Connection conn;

    public CustomerDAO(Connection conn) {
        this.conn = conn;
    }

    /* CREATE */
    public void addCustomer(Customer customer) throws SQLException {
        final String sql =
                "INSERT INTO customers (account_no, name, address, telephone) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customer.getAccountNo());
            ps.setString(2, customer.getName());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getTelephone());
            ps.executeUpdate();
        } catch (SQLIntegrityConstraintViolationException dup) {
            // account_no PK/UNIQUE violation
            throw new SQLException("Account number already exists: " + customer.getAccountNo(), dup);
        }
    }

    /* UPDATE */
    public int updateCustomer(Customer customer) throws SQLException {
        final String sql =
                "UPDATE customers SET name = ?, address = ?, telephone = ? WHERE account_no = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getAddress());
            ps.setString(3, customer.getTelephone());
            ps.setInt(4, customer.getAccountNo());
            return ps.executeUpdate(); // returns 1 if updated, 0 if not found
        }
    }

    /* READ: by id */
    public Customer getCustomer(int accountNo) throws SQLException {
        final String sql =
                "SELECT account_no, name, address, telephone FROM customers WHERE account_no = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("account_no"),
                            rs.getString("name"),
                            rs.getString("address"),
                            rs.getString("telephone")
                    );
                }
            }
        }
        return null;
    }

    /* READ: all (ordered) */
    public List<Customer> getAllCustomers() throws SQLException {
        final String sql =
                // order by created_at desc if you have that column; otherwise account_no
                "SELECT account_no, name, address, telephone FROM customers ORDER BY account_no ASC";
        List<Customer> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Customer(
                        rs.getInt("account_no"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("telephone")
                ));
            }
        }
        return list;
    }

    /* Helpers (optional but useful) */
    public boolean existsByAccountNo(int accountNo) throws SQLException {
        final String sql = "SELECT 1 FROM customers WHERE account_no = ? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int deleteByAccountNo(int accountNo) throws SQLException {
        final String sql = "DELETE FROM customers WHERE account_no = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountNo);
            return ps.executeUpdate(); // 1 if deleted, 0 if not found
        }
    }
}
