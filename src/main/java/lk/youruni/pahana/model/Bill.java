package lk.youruni.pahana.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Bill {
    private int billId;
    private int customerAccountNo;
    private String customerName; // optional (for print view convenience)
    private BigDecimal subtotal = BigDecimal.ZERO;
    private BigDecimal total = BigDecimal.ZERO;
    private String note;
    private List<BillItem> items = new ArrayList<>();

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getCustomerAccountNo() { return customerAccountNo; }
    public void setCustomerAccountNo(int customerAccountNo) { this.customerAccountNo = customerAccountNo; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public List<BillItem> getItems() { return items; }
    public void setItems(List<BillItem> items) { this.items = items; }
}
