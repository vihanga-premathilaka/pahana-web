package lk.youruni.pahana.dao;

import lk.youruni.pahana.model.Item;
import java.sql.*;
import java.util.*;

public class ItemDAO {
    private final Connection conn;

    public ItemDAO(Connection conn) {
        this.conn = conn;
    }

    public void addItem(Item item) throws SQLException {
        String sql = "INSERT INTO items(item_name, price, stock) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getItemName());
            ps.setDouble(2, item.getPrice());
            ps.setInt(3, item.getStock());
            ps.executeUpdate();
        }
    }

    public void updateItem(Item item) throws SQLException {
        String sql = "UPDATE items SET item_name=?, price=?, stock=? WHERE item_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getItemName());
            ps.setDouble(2, item.getPrice());
            ps.setInt(3, item.getStock());
            ps.setInt(4, item.getItemId());
            ps.executeUpdate();
        }
    }

    public void deleteItem(int itemId) throws SQLException {
        String sql = "DELETE FROM items WHERE item_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.executeUpdate();
        }
    }

    public Item getItem(int itemId) throws SQLException {
        String sql = "SELECT * FROM items WHERE item_id=?";
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

    public List<Item> getAllItems() throws SQLException {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT * FROM items";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
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
}
