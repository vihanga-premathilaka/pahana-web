<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.youruni.pahana.model.Item" %>
<%
    String ctx = request.getContextPath();
    List<Item> items = (List<Item>) request.getAttribute("items");
    Item selected = (Item) request.getAttribute("selectedItem");

    // If not loaded via servlet, redirect so the list gets populated
    if (items == null) {
        response.sendRedirect(ctx + "/items");
        return;
    }
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Items</title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;background:#f6f8fb;margin:0;padding:24px}
        .wrap{max-width:1100px;margin:0 auto}
        .grid{display:grid;grid-template-columns:1fr 360px;gap:20px}
        .card{background:#fff;border:1px solid #ddd;border-radius:8px;box-shadow:0 4px 10px rgba(0,0,0,.05)}
        .hd{padding:12px;font-weight:bold;border-bottom:1px solid #eee}
        .bd{padding:16px}
        table{width:100%;border-collapse:collapse;font-size:14px}
        th,td{padding:10px;border-bottom:1px solid #eee}
        th{background:#f9fafb;text-align:left}
        .btn{padding:6px 10px;border-radius:6px;text-decoration:none;font-weight:600;margin-right:5px}
        .btn-edit{background:#2563eb;color:#fff}
        .btn-del{background:#dc2626;color:#fff}
    </style>
</head>
<body>
<div class="wrap">
    <h2>Item Management</h2>
    <div class="grid">
        <div class="card">
            <div class="hd">Items</div>
            <div class="bd">
                <table>
                    <tr><th>ID</th><th>Name</th><th>Price</th><th>Stock</th><th>Actions</th></tr>
                    <% if (items != null) { for (Item i : items) { %>
                    <tr>
                        <td><%= i.getItemId() %></td>
                        <td><%= i.getItemName() %></td>
                        <td><%= i.getPrice() %></td>
                        <td><%= i.getStock() %></td>
                        <td>
                            <a class="btn btn-edit" href="<%=ctx%>/items?action=edit&id=<%=i.getItemId()%>">Edit</a>
                            <a class="btn btn-del" href="<%=ctx%>/items?action=delete&id=<%=i.getItemId()%>"
                               onclick="return confirm('Delete this item?')">Delete</a>
                        </td>
                    </tr>
                    <% } } %>
                </table>
            </div>
        </div>
        <div class="card">
            <div class="hd">Add / Edit Item</div>
            <div class="bd">
                <form method="post" action="<%=ctx%>/items">
                    <input type="hidden" name="itemId" value="<%= selected!=null? selected.getItemId() : "" %>">
                    <label>Name</label>
                    <input type="text" name="itemName" value="<%= selected!=null? selected.getItemName() : "" %>" required>
                    <label>Price</label>
                    <input type="number" step="0.01" name="price" value="<%= selected!=null? selected.getPrice() : "" %>" required>
                    <label>Stock</label>
                    <input type="number" name="stock" value="<%= selected!=null? selected.getStock() : "" %>" required>
                    <button type="submit">Save</button>
                </form>
            </div>
        </div>
    </div>
</div>
<p><a href="<%=request.getContextPath()%>/dashboard.jsp">Back to Main Menu</a></p>
</body>
</html>
