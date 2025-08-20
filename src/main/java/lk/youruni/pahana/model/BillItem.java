package lk.youruni.pahana.model;

import java.math.BigDecimal;

public class BillItem {
    private int itemId;
    private String itemName;
    private BigDecimal unitPrice = BigDecimal.ZERO;
    private int qty;
    private BigDecimal lineTotal = BigDecimal.ZERO;

    public BillItem() {}

    public BillItem(int itemId, String itemName, BigDecimal unitPrice, int qty) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.unitPrice = unitPrice;
        this.qty = qty;
        this.lineTotal = unitPrice.multiply(BigDecimal.valueOf(qty));
    }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }

    public BigDecimal getLineTotal() { return lineTotal; }
    public void setLineTotal(BigDecimal lineTotal) { this.lineTotal = lineTotal; }
}
