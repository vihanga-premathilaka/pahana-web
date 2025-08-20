package lk.youruni.pahana.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class BillSummary {
    private int billId;
    private Timestamp billDate;
    private BigDecimal subtotal;
    private BigDecimal total;
    private int itemCount;

    public BillSummary() {}

    public BillSummary(int billId, Timestamp billDate, BigDecimal subtotal, BigDecimal total, int itemCount) {
        this.billId = billId;
        this.billDate = billDate;
        this.subtotal = subtotal;
        this.total = total;
        this.itemCount = itemCount;
    }

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public Timestamp getBillDate() { return billDate; }
    public void setBillDate(Timestamp billDate) { this.billDate = billDate; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }

    public int getItemCount() { return itemCount; }
    public void setItemCount(int itemCount) { this.itemCount = itemCount; }
}
