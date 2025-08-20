<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.youruni.pahana.model.Customer" %>
<%@ page import="lk.youruni.pahana.model.Item" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.youruni.pahana.model.Item" %>
<%
    String ctx = request.getContextPath();
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    List<Item> items = (List<Item>) request.getAttribute("items");
    if (customers == null || items == null) { response.sendRedirect(ctx + "/billing"); return; }
    String err = (String) request.getAttribute("error");
    String qerr = request.getParameter("err");
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Bill</title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;background:#f6f8fb;margin:0;padding:24px}
        .wrap{max-width:1100px;margin:0 auto}
        .grid{display:grid;grid-template-columns: 1fr 420px;gap:20px;align-items:start}
        .card{background:#fff;border:1px solid #e5e7eb;border-radius:12px;box-shadow:0 6px 18px rgba(0,0,0,.05)}
        .hd{padding:16px 18px;border-bottom:1px solid #eef2f7;font-weight:700}
        .bd{padding:18px}
        table{width:100%;border-collapse:collapse;font-size:14px;background:#fff}
        th,td{padding:10px;border-bottom:1px solid #eef2f7;text-align:left}
        th{font-weight:700;color:#374151;background:#f9fafb}
        input, select, textarea{width:100%;padding:10px;border:1px solid #d1d5db;border-radius:8px;font-size:14px}
        input[type="number"]{text-align:right}
        .btn{display:inline-block;padding:8px 12px;border-radius:8px;border:1px solid #d1d5db;background:#fff;color:#111827;text-decoration:none;font-weight:600;cursor:pointer}
        .btn:hover{background:#f3f4f6}
        .btn-primary{background:#2563eb;border-color:#2563eb;color:#fff}
        .btn-primary:hover{background:#1d4ed8}
        .btn-danger{background:#dc2626;border-color:#dc2626;color:#fff}
        .btn-danger:hover{background:#b91c1c}
        .err{background:#fee2e2;color:#991b1b;padding:10px;border-radius:8px;margin:0 0 12px}
        .total{font-size:18px;font-weight:700;text-align:right;margin-top:12px}
        .muted{color:#6b7280;font-size:12px}
    </style>
</head>
<body>
<div class="wrap">
    <h2 style="margin:0 0 18px">Create Bill</h2>

    <div class="grid">
        <!-- Left: Detail lines -->
        <div class="card">
            <div class="hd">Items</div>
            <div class="bd">
                <% if (qerr != null) { %><div class="err"><%= qerr %></div><% } %>
                <% if (err != null)  { %><div class="err"><%= err %></div><% } %>

                <table id="linesTable">
                    <thead>
                    <tr>
                        <th style="width:40%">Item</th>
                        <th style="width:15%">Price</th>
                        <th style="width:15%">Stock</th>
                        <th style="width:15%">Qty</th>
                        <th style="width:15%">Line Total</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- rows injected by JS -->
                    </tbody>
                </table>

                <div style="margin-top:10px">
                    <button type="button" class="btn" onclick="addRow()">+ Add Item</button>
                </div>

                <div class="total">
                    Subtotal: LKR <span id="subtotal">0.00</span>
                </div>
                <div class="muted">* Prices & stock shown are current. Final validation happens on confirmation.</div>
            </div>
        </div>

        <!-- Right: Header & confirm -->
        <div class="card">
            <div class="hd">Bill Header</div>
            <div class="bd">
                <form id="billForm" method="post" action="<%=ctx%>/billing">
                    <input type="hidden" name="action" value="confirm">

                    <div style="margin-bottom:12px">
                        <label for="customer">Customer *</label>
                        <select id="customer" name="customerAccountNo" required>
                            <option value="">-- Select Customer --</option>
                            <% for (Customer c : customers) { %>
                            <option value="<%= c.getAccountNo() %>">
                                <%= c.getAccountNo() %> - <%= c.getName() %>
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div style="margin-bottom:12px">
                        <label for="note">Note (optional)</label>
                        <textarea id="note" name="note" rows="3" placeholder="Anything to note on this bill?"></textarea>
                    </div>

                    <!-- dynamic hidden inputs for itemId[] and qty[] get injected before submit -->

                    <button type="button" class="btn-primary" style="width:100%" onclick="submitBill()">Confirm & Generate Bill</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // preload items from server into JS
    const ITEMS = [
        <%  for (lk.youruni.pahana.model.Item it : (java.util.List<lk.youruni.pahana.model.Item>)request.getAttribute("items")) { %>
        { id:<%= it.getItemId() %>, name:"<%= it.getItemName().replace("\"","\\\"") %>", price:<%= it.getPrice() %>, stock:<%= it.getStock() %> },
        <% } %>
    ];

    const tbody = document.querySelector('#linesTable tbody');
    const subtotalEl = document.getElementById('subtotal');

    function addRow() {
        const tr = document.createElement('tr');

        // build options safely (no EL)
        var opts = '';
        for (var i = 0; i < ITEMS.length; i++) {
            var it = ITEMS[i];
            opts += '<option value="' + it.id + '" data-price="' + it.price + '" data-stock="' + it.stock + '">' + it.name + '</option>';
        }

        tr.innerHTML = `
    <td>
      <select class="itemSel" onchange="syncPriceStock(this)">
        <option value="">-- select --</option>` + opts + `
      </select>
    </td>
    <td><input class="price" type="number" step="0.01" readonly></td>
    <td><input class="stock" type="number" readonly></td>
    <td><input class="qty" type="number" min="1" value="1" oninput="recalc()"></td>
    <td class="lineTotal">0.00</td>
    <td><button type="button" onclick="removeRow(this)">Remove</button></td>
  `;
        document.querySelector('#linesTable tbody').appendChild(tr);
    }

    function removeRow(btn) {
        btn.closest('tr').remove();
        recalc();
    }

    function syncPriceStock(sel) {
        const opt = sel.selectedOptions[0];
        const row = sel.closest('tr');
        const price = parseFloat(opt.getAttribute('data-price') || '0');
        const stock = parseInt(opt.getAttribute('data-stock') || '0', 10);
        row.querySelector('.price').value = price.toFixed(2);
        row.querySelector('.stock').value = stock;
        const qtyEl = row.querySelector('.qty');
        if (qtyEl.value === '' || parseInt(qtyEl.value,10) <= 0) qtyEl.value = 1;
        recalc();
    }

    function recalc() {
        let subtotal = 0;
        [...tbody.querySelectorAll('tr')].forEach(tr => {
            const price = parseFloat(tr.querySelector('.price').value || '0');
            const qty = parseInt(tr.querySelector('.qty').value || '0', 10);
            const stock = parseInt(tr.querySelector('.stock').value || '0', 10);
            if (qty > stock) tr.querySelector('.qty').value = stock > 0 ? stock : 0;
            const lt = price * parseInt(tr.querySelector('.qty').value || '0', 10);
            tr.querySelector('.lineTotal').value = lt.toFixed(2);
            subtotal += lt;
        });
        subtotalEl.textContent = subtotal.toFixed(2);
    }

    function submitBill() {
        // build hidden inputs itemId[] and qty[]
        const form = document.getElementById('billForm');
        // remove old hidden inputs
        [...form.querySelectorAll('input[name="itemId[]"], input[name="qty[]"]')].forEach(e=>e.remove());

        const rows = [...tbody.querySelectorAll('tr')];
        if (rows.length === 0) { alert('Please add at least one item.'); return; }

        for (const tr of rows) {
            const sel = tr.querySelector('.itemSel');
            const itemId = sel.value;
            const qty = tr.querySelector('.qty').value;
            if (!itemId || parseInt(qty,10) <= 0) {
                alert('Please select item and enter valid qty.');
                return;
            }
            const hi1 = document.createElement('input');
            hi1.type = 'hidden'; hi1.name = 'itemId[]'; hi1.value = itemId;
            const hi2 = document.createElement('input');
            hi2.type = 'hidden'; hi2.name = 'qty[]'; hi2.value = qty;
            form.appendChild(hi1);
            form.appendChild(hi2);
        }

        form.submit();
    }

    // start with one blank row
    addRow();
</script>
</body>
</html>
