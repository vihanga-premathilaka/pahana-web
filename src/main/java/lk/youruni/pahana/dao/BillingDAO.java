package lk.youruni.pahana.dao;

import lk.youruni.pahana.model.Bill;
import lk.youruni.pahana.model.BillItem;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillingDAO {
    private final Connection conn;

    public BillingDAO(Connection conn) {
        this.conn = conn;
    }

    /* Insert bill + lines, decrement stock (atomic) */
    public int createBillAndUpdateStock(Bill bill) throws Exception {
        String insertBillSql  = "INSERT INTO bills (customer_ac_no, subtotal, total, note) VALUES (?, ?, ?, ?)";
        String insertLineSql  = "INSERT INTO bill_items (bill_id, item_id, item_name, unit_price, qty, line_total) VALUES (?,?,?,?,?,?)";

        // UPDATED: match your items schema
        String selectItemSql  = "SELECT item_name, price, stock FROM items WHERE item_id = ? FOR UPDATE";
        String updateStockSql = "UPDATE items SET stock = stock - ? WHERE item_id = ?";

        boolean oldAuto = conn.getAutoCommit();
        conn.setAutoCommit(false);

        try (PreparedStatement billPs  = conn.prepareStatement(insertBillSql, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement linePs  = conn.prepareStatement(insertLineSql);
             PreparedStatement itemSel = conn.prepareStatement(selectItemSql);
             PreparedStatement stockUpd= conn.prepareStatement(updateStockSql)) {

            // server-side recompute to avoid tampering
            BigDecimal subtotal = BigDecimal.ZERO;

            // Validate stock and compute totals using DB values
            for (BillItem bi : bill.getItems()) {
                itemSel.setInt(1, bi.getItemId());
                try (ResultSet rs = itemSel.executeQuery()) {
                    if (!rs.next()) {
                        throw new SQLException("Item not found: id=" + bi.getItemId());
                    }

                    String dbName        = rs.getString("item_name");
                    BigDecimal dbPrice   = rs.getBigDecimal("price");
                    int currentStock     = rs.getInt("stock");

                    if (bi.getQty() <= 0) {
                        throw new SQLException("Invalid qty for item " + dbName);
                    }
                    if (bi.getQty() > currentStock) {
                        throw new SQLException("Insufficient stock for item " + dbName + " (available " + currentStock + ")");
                    }

                    BigDecimal lineTotal = dbPrice.multiply(BigDecimal.valueOf(bi.getQty()));
                    subtotal = subtotal.add(lineTotal);

                    // snapshot into the bill item
                    bi.setItemName(dbName);
                    bi.setUnitPrice(dbPrice);
                    bi.setLineTotal(lineTotal);
                }
            }

            bill.setSubtotal(subtotal);
            bill.setTotal(subtotal); // add tax/discount here if needed

            // Insert bill header
            billPs.setInt(1, bill.getCustomerAccountNo());
            billPs.setBigDecimal(2, bill.getSubtotal());
            billPs.setBigDecimal(3, bill.getTotal());
            billPs.setString(4, bill.getNote());
            billPs.executeUpdate();

            int billId;
            try (ResultSet keys = billPs.getGeneratedKeys()) {
                if (!keys.next()) throw new SQLException("No bill id returned");
                billId = keys.getInt(1);
            }

            // Insert lines & queue stock updates
            for (BillItem bi : bill.getItems()) {
                linePs.setInt(1, billId);
                linePs.setInt(2, bi.getItemId());
                linePs.setString(3, bi.getItemName());
                linePs.setBigDecimal(4, bi.getUnitPrice());
                linePs.setInt(5, bi.getQty());
                linePs.setBigDecimal(6, bi.getLineTotal());
                linePs.addBatch();

                stockUpd.setInt(1, bi.getQty());
                stockUpd.setInt(2, bi.getItemId());
                stockUpd.addBatch();
            }
            linePs.executeBatch();
            stockUpd.executeBatch();

            conn.commit();
            return billId;

        } catch (Exception ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(oldAuto);
        }
    }

    /* Load bill with lines for printing */
    public Bill getBillWithItems(int billId) throws SQLException {
        String billSql =
                "SELECT b.bill_id, b.customer_ac_no, b.bill_date, b.subtotal, b.total, c.name AS customer_name " +
                        "FROM bills b JOIN customers c ON c.account_no = b.customer_ac_no WHERE b.bill_id = ?";
        String linesSql =
                "SELECT item_id, item_name, unit_price, qty, line_total FROM bill_items WHERE bill_id = ?";

        Bill bill = null;
        try (PreparedStatement bp = conn.prepareStatement(billSql)) {
            bp.setInt(1, billId);
            try (ResultSet rs = bp.executeQuery()) {
                if (rs.next()) {
                    bill = new Bill();
                    bill.setBillId(rs.getInt("bill_id"));
                    bill.setCustomerAccountNo(rs.getInt("customer_ac_no"));
                    bill.setCustomerName(rs.getString("customer_name"));
                    bill.setSubtotal(rs.getBigDecimal("subtotal"));
                    bill.setTotal(rs.getBigDecimal("total"));
                }
            }
        }
        if (bill == null) return null;

        try (PreparedStatement lp = conn.prepareStatement(linesSql)) {
            lp.setInt(1, billId);
            List<BillItem> items = new ArrayList<>();
            try (ResultSet rs = lp.executeQuery()) {
                while (rs.next()) {
                    BillItem bi = new BillItem();
                    bi.setItemId(rs.getInt("item_id"));
                    bi.setItemName(rs.getString("item_name"));
                    bi.setUnitPrice(rs.getBigDecimal("unit_price"));
                    bi.setQty(rs.getInt("qty"));
                    bi.setLineTotal(rs.getBigDecimal("line_total"));
                    items.add(bi);
                }
            }
            bill.setItems(items);
        }
        return bill;
    }
}
