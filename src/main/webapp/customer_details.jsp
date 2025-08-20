<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.youruni.pahana.model.Customer" %>
<%@ page import="lk.youruni.pahana.model.BillSummary" %>
<%
    String ctx = request.getContextPath();
    String query = (String) request.getAttribute("query");
    List<Customer> results = (List<Customer>) request.getAttribute("results");
    Customer customer = (Customer) request.getAttribute("customer");
    List<BillSummary> bills = (List<BillSummary>) request.getAttribute("bills");
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Details</title>
    <style>
        body{font-family:system-ui,Segoe UI,Arial,Helvetica,sans-serif;background:#f6f8fb;margin:0;padding:24px}
        .wrap{max-width:1100px;margin:0 auto}
        .card{background:#fff;border:1px solid #e5e7eb;border-radius:12px;box-shadow:0 6px 18px rgba(0,0,0,.05);margin-bottom:16px}
        .hd{padding:16px 18px;border-bottom:1px solid #eef2f7;font-weight:700}
        .bd{padding:18px}
        .row{display:flex;gap:12px;align-items:center}
        input[type=text]{flex:1;padding:10px;border:1px solid #d1d5db;border-radius:8px;font-size:14px}
        .btn{padding:10px 14px;border-radius:8px;border:1px solid #2563eb;background:#2563eb;color:#fff;font-weight:600;cursor:pointer}
        table{width:100%;border-collapse:collapse;font-size:14px}
        th,td{padding:10px;border-bottom:1px solid #eef2f7;text-align:left}
        th{font-weight:700;color:#374151;background:#f9fafb}
        .err{background:#fee2e2;color:#991b1b;padding:10px;border-radius:8px;margin-bottom:12px}
        .grid{display:grid;grid-template-columns:1fr;gap:16px}
        @media (min-width:960px){ .grid{grid-template-columns: 1fr 1fr; } }
        .muted{color:#6b7280}
        .pill{background:#eef2ff;color:#1d4ed8;padding:2px 8px;border-radius:999px;font-size:12px}
        a.link{color:#2563eb;text-decoration:none}
        a.link:hover{text-decoration:underline}
    </style>
</head>
<body>
<div class="wrap">
    <h2 style="margin:0 0 16px">Customer Details</h2>

    <div class="card">
        <div class="hd">Search</div>
        <div class="bd">
            <form method="get" action="<%=ctx%>/customerDetails">
                <div class="row">
                    <input type="text" name="q" value="<%=query!=null?query:""%>" placeholder="Enter Account No or Name and press Enter…">
                    <button class="btn" type="submit">Search</button>
                </div>
                <div class="muted" style="margin-top:8px">Tip: type an account number for exact match, or a name fragment to search by name.</div>
            </form>
        </div>
    </div>

    <%
        String err = (String) request.getAttribute("error");
        if (err != null) {
    %>
    <div class="err"><%= err %></div>
    <% } %>

    <!-- Search results list -->
    <%
        if (results != null) {
    %>
    <div class="card">
        <div class="hd">Search Results <span class="pill"><%= results.size() %></span></div>
        <div class="bd">
            <table>
                <tr>
                    <th>Account No</th>
                    <th>Name</th>
                    <th>Telephone</th>
                    <th>Address</th>
                    <th>Action</th>
                </tr>
                <% for (Customer c : results) { %>
                <tr>
                    <td><%= c.getAccountNo() %></td>
                    <td><%= c.getName() %></td>
                    <td><%= c.getTelephone() %></td>
                    <td><%= c.getAddress() %></td>
                    <td><a class="link" href="<%=ctx%>/customerDetails?accountNo=<%=c.getAccountNo()%>">View</a></td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
    <% } %>

    <!-- Details + Billing history -->
    <%
        if (customer != null) {
    %>
    <div class="grid">
        <div class="card">
            <div class="hd">Customer</div>
            <div class="bd">
                <div style="font-size:18px;font-weight:700;margin-bottom:6px"><%= customer.getName() %></div>
                <div class="muted" style="margin-bottom:8px">Account No: <b><%= customer.getAccountNo() %></b></div>
                <div>Telephone: <b><%= customer.getTelephone() %></b></div>
                <div>Address: <b><%= customer.getAddress() %></b></div>
            </div>
        </div>

        <div class="card" style="grid-column:1 / -1">
            <div class="hd">Billing History</div>
            <div class="bd">
                <%
                    if (bills == null || bills.isEmpty()) {
                %>
                <div class="muted">No bills found for this customer.</div>
                <%
                } else {
                %>
                <table>
                    <tr>
                        <th>Bill ID</th>
                        <th>Date</th>
                        <th>Items</th>
                        <th>Subtotal</th>
                        <th>Total</th>
                        <th>Action</th>
                    </tr>
                    <% for (BillSummary b : bills) { %>
                    <tr>
                        <td>#<%= b.getBillId() %></td>
                        <td><%= b.getBillDate() %></td>
                        <td><%= b.getItemCount() %></td>
                        <td>LKR <%= b.getSubtotal() %></td>
                        <td>LKR <%= b.getTotal() %></td>
                    </tr>
                    <% } %>
                </table>
                <% } %>
            </div>
        </div>
    </div>
    <% } %>
    <div class="links">
        <a href="<%=ctx%>/dashboard.jsp">← Back to Dashboard</a>
    </div>
</div>
</body>
</html>
