package lk.youruni.pahana.dao;

import lk.youruni.pahana.model.Customer;
import lk.youruni.pahana.model.BillSummary;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDetailsDAO {
    private final Connection con;

    public CustomerDetailsDAO(Connection con) {
        this.con = con;
    }

    /** Exact load by account number */
    public Customer getCustomer(int accountNo) throws SQLException {
        String sql = "SELECT account_no, name, address, telephone FROM customers WHERE account_no = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
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

    /**
     * Search by account number or name.
     * - If q is numeric -> exact account_no OR name LIKE %q%
     * - If q is text   -> name LIKE %q%
     */
    public List<Customer> search(String q) throws SQLException {
        List<Customer> list = new ArrayList<>();
        boolean numeric = q != null && q.trim().matches("\\d+");
        String sql;

        if (numeric) {
            sql = "SELECT account_no, name, address, telephone " +
                    "FROM customers WHERE account_no = ? OR name LIKE ? ORDER BY name";
        } else {
            sql = "SELECT account_no, name, address, telephone " +
                    "FROM customers WHERE name LIKE ? ORDER BY name";
        }

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            if (numeric) {
                ps.setInt(1, Integer.parseInt(q.trim()));
                ps.setString(2, "%" + q.trim() + "%");
            } else {
                ps.setString(1, "%" + q.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Customer(
                            rs.getInt("account_no"),
                            rs.getString("name"),
                            rs.getString("address"),
                            rs.getString("telephone")
                    ));
                }
            }
        }
        return list;
    }

    /** Bills for a given customer with item count */
    public List<BillSummary> getBillsForCustomer(int accountNo) throws SQLException {
        List<BillSummary> list = new ArrayList<>();
        String sql =
                "SELECT b.bill_id, b.bill_date, b.subtotal, b.total, " +
                        "       COALESCE((SELECT SUM(qty) FROM bill_items bi WHERE bi.bill_id = b.bill_id), 0) AS item_count " +
                        "FROM bills b " +
                        "WHERE b.customer_ac_no = ? " +
                        "ORDER BY b.bill_date DESC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new BillSummary(
                            rs.getInt("bill_id"),
                            rs.getTimestamp("bill_date"),
                            rs.getBigDecimal("subtotal"),
                            rs.getBigDecimal("total"),
                            rs.getInt("item_count")
                    ));
                }
            }
        }
        return list;
    }
}
