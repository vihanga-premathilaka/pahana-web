<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.youruni.pahana.model.Customer" %>
<%
    String ctx = request.getContextPath();
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    Customer selected = (Customer) request.getAttribute("selectedCustomer");

    // Guard: if the servlet didn’t set attributes, redirect to it
    if (customers == null) {
        response.sendRedirect(ctx + "/editCustomer");
        return;
    }
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Customers</title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;background:#f6f8fb;margin:0;padding:24px}
        .wrap{max-width:1100px;margin:0 auto}
        .grid{display:grid;grid-template-columns: 1fr 360px;gap:20px;align-items:start}
        .card{background:#fff;border:1px solid #e5e7eb;border-radius:12px;box-shadow:0 6px 18px rgba(0,0,0,.05)}
        .card .hd{padding:16px 18px;border-bottom:1px solid #eef2f7;font-weight:700}
        .card .bd{padding:18px}
        table{width:100%;border-collapse:collapse;font-size:14px}
        th,td{padding:10px;border-bottom:1px solid #eef2f7;text-align:left}
        th{font-weight:700;color:#374151;background:#f9fafb}
        .btn{display:inline-block;padding:8px 12px;border-radius:8px;border:1px solid #d1d5db;background:#fff;color:#111827;text-decoration:none;font-weight:600}
        .btn:hover{background:#f3f4f6}
        .btn-primary{background:#2563eb;border-color:#2563eb;color:#fff}
        .btn-primary:hover{background:#1d4ed8}
        .row{margin-bottom:12px}
        label{display:block;margin-bottom:6px;color:#374151;font-size:13px}
        input{width:100%;padding:10px;border:1px solid #d1d5db;border-radius:8px;font-size:14px}
        .err{background:#fee2e2;color:#991b1b;padding:10px;border-radius:8px;margin:0 0 12px}
        .muted{color:#6b7280;font-size:12px;margin-top:6px}
        .btn-danger {background:#dc2626; border-color:#dc2626; color:#fff;}
        .btn-danger:hover {background:#b91c1c;}
    </style>
</head>
<body>
<div class="wrap">
    <h2 style="margin:0 0 18px">Customer Management – Edit</h2>

    <div class="grid">
        <!-- Left: table -->
        <div class="card">
            <div class="hd">Customers</div>
            <div class="bd">
                <%
                    String err = (String) request.getAttribute("error");
                    if (err != null) { %><div class="err"><%= err %></div><% }
            %>
                <table>
                    <tr>
                        <th>Account No</th>
                        <th>Name</th>
                        <th>Telephone</th>
                        <th>Address</th>
                        <th>Action</th>
                    </tr>
                    <%
                        if (customers != null) {
                            for (Customer c : customers) {
                    %>
                    <tr>
                        <td><%= c.getAccountNo() %></td>
                        <td><%= c.getName() %></td>
                        <td><%= c.getTelephone() %></td>
                        <td><%= c.getAddress() %></td>
                        <td>
                            <a class="btn" href="<%= ctx %>/editCustomer?action=edit&accountNo=<%= c.getAccountNo() %>">Edit</a>
                            <a class="btn btn-danger"
                               href="<%= ctx %>/editCustomer?action=delete&accountNo=<%= c.getAccountNo() %>"
                               onclick="return confirm('Are you sure you want to delete this customer?');">
                                Delete
                            </a>
                        </td>
                    </tr>
                    <%  } } %>
                </table>
            </div>
        </div>

        <!-- Right: in-page edit form -->
        <div class="card">
            <div class="hd">Edit Customer</div>
            <div class="bd">
                <form method="post" action="<%= ctx %>/editCustomer">
                    <div class="row">
                        <label for="accountNo">Account No</label>
                        <input id="accountNo" name="accountNo" value="<%= selected!=null? selected.getAccountNo() : "" %>" readonly>
                        <div class="muted">Pick a row from the table (Edit) to load here.</div>
                    </div>
                    <div class="row">
                        <label for="name">Full Name</label>
                        <input id="name" name="name" value="<%= selected!=null? selected.getName() : "" %>" required>
                    </div>
                    <div class="row">
                        <label for="telephone">Telephone</label>
                        <input id="telephone" name="telephone" value="<%= selected!=null? selected.getTelephone() : "" %>" required>
                    </div>
                    <div class="row">
                        <label for="address">Address</label>
                        <input id="address" name="address" value="<%= selected!=null? selected.getAddress() : "" %>" required>
                    </div>
                    <button class="btn-primary" type="submit" style="width:100%">Save Changes</button>
                </form>
            </div>
        </div>
    </div>
    <div class="links">
        <a href="<%=ctx%>/dashboard.jsp">← Back to Dashboard</a>
    </div>
</div>
</body>
</html>
