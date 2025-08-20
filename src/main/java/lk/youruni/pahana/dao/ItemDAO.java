package lk.youruni.pahana.dao;

import lk.youruni.pahana.model.Item;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {
    private final Connection conn;

    public ItemDAO(Connection conn) {
        this.conn = conn;
    }

    /* ========== CREATE ========== */
    public void addItem(Item item) throws SQLException {
        final String sql = "INSERT INTO items (item_name, price, stock) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getItemName());
            ps.setDouble(2, item.getPrice());
            ps.setInt(3, item.getStock());
            ps.executeUpdate();
        }
    }

    /* ========== UPDATE ========== */
    public void updateItem(Item item) throws SQLException {
        final String sql = "UPDATE items SET item_name = ?, price = ?, stock = ? WHERE item_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getItemName());
            ps.setDouble(2, item.getPrice());
            ps.setInt(3, item.getStock());
            ps.setInt(4, item.getItemId());
            ps.executeUpdate();
        }
    }

    /* ========== DELETE ========== */
    public void deleteItem(int itemId) throws SQLException {
        final String sql = "DELETE FROM items WHERE item_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.executeUpdate();
        }
    }

    /* ========== READ (single) ========== */
    public Item getItem(int itemId) throws SQLException {
        final String sql = "SELECT item_id, item_name, price, stock FROM items WHERE item_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Item(
                            rs.getInt("item_id"),
                            rs.getString("item_name"),
                            rs.getDouble("price"),
                            rs.getInt("stock")
                    );
                }
            }
        }
        return null;
    }

    /* ========== READ (list) ========== */
    public List<Item> getAllItems() throws SQLException {
        final String sql = "SELECT item_id, item_name, price, stock FROM items ORDER BY item_name";
        List<Item> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Item(
                        rs.getInt("item_id"),
                        rs.getString("item_name"),
                        rs.getDouble("price"),
                        rs.getInt("stock")
                ));
            }
        }
        return list;
    }

    /* Convenience alias used by BillingServlet */
    public List<Item> listAll() throws SQLException {
        return getAllItems();
    }
}
