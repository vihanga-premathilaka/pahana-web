<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="lk.youruni.pahana.model.Bill" %>
<%@ page import="lk.youruni.pahana.model.BillItem" %>
<%
    Bill bill = (Bill) request.getAttribute("bill");
    if (bill == null) { response.sendRedirect(request.getContextPath() + "/billing?err=No+bill+to+print"); return; }
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill #<%= bill.getBillId() %></title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;margin:24px}
        h2{margin:0 0 12px}
        table{width:100%;border-collapse:collapse;margin-top:12px}
        th,td{border:1px solid #ddd;padding:8px;text-align:left}
        th{background:#f5f5f5}
        .tot{font-weight:700;text-align:right}
        .muted{color:#6b7280}
        .toolbar{margin-top:16px}
        .btn{display:inline-block;padding:8px 12px;border:1px solid #d1d5db;border-radius:8px;text-decoration:none}
    </style>
</head>
<body>
<h2>Pahana Edu — Bill #<%= bill.getBillId() %></h2>
<div class="muted">Customer: <strong><%= bill.getCustomerAccountNo() %></strong>
    <% if (bill.getCustomerName()!=null) { %> — <%= bill.getCustomerName() %> <% } %>
</div>

<table>
    <tr>
        <th style="width:10%">#</th>
        <th>Item</th>
        <th style="width:15%">Unit Price</th>
        <th style="width:10%">Qty</th>
        <th style="width:15%">Line Total</th>
    </tr>
    <%
        int i=1;
        for (BillItem bi : bill.getItems()) {
    %>
    <tr>
        <td><%= i++ %></td>
        <td><%= bi.getItemName() %></td>
        <td>LKR <%= bi.getUnitPrice() %></td>
        <td><%= bi.getQty() %></td>
        <td>LKR <%= bi.getLineTotal() %></td>
    </tr>
    <% } %>
    <tr>
        <td colspan="4" class="tot">Subtotal</td>
        <td>LKR <%= bill.getSubtotal() %></td>
    </tr>
    <tr>
        <td colspan="4" class="tot">Total</td>
        <td>LKR <%= bill.getTotal() %></td>
    </tr>
</table>

<div class="toolbar">
    <a class="btn" href="#" onclick="window.print();return false;">Print</a>
    <a class="btn" href="<%= request.getContextPath() %>/billing">Back</a>
</div>
</body>
</html>
