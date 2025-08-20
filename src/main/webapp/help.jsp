<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Help & User Guide – Pahana Edu</title>
    <style>
        :root{
            --bg:#f6f8fb; --card:#fff; --muted:#6b7280; --line:#e5e7eb;
            --ink:#111827; --ink2:#374151; --primary:#2563eb; --primary-2:#1d4ed8;
        }
        *{box-sizing:border-box}
        body{font-family:system-ui,Segoe UI,Arial,Helvetica,sans-serif;background:var(--bg);color:var(--ink);margin:0}
        .wrap{max-width:1100px;margin:0 auto;padding:24px}
        h1{margin:0 0 6px}
        .muted{color:var(--muted)}
        .grid{display:grid;grid-template-columns:280px 1fr;gap:18px}
        @media (max-width:980px){.grid{grid-template-columns:1fr}}
        .card{background:var(--card);border:1px solid var(--line);border-radius:12px;box-shadow:0 6px 18px rgba(0,0,0,.05)}
        .bd{padding:18px}
        nav ul{list-style:none;margin:0;padding:0}
        nav li{margin:6px 0}
        nav a{display:block;padding:8px 10px;border-radius:8px;color:var(--ink2);text-decoration:none}
        nav a:hover{background:#eef2ff;color:var(--primary)}
        h2{margin:14px 0 8px}
        h3{margin:12px 0 6px}
        .kbd{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;background:#f3f4f6;border:1px solid var(--line);
            border-bottom-width:2px;border-radius:6px;padding:2px 6px}
        .step{margin:0 0 12px}
        .step li{margin:8px 0}
        .tip{background:#ecfeff;border:1px solid #bae6fd;padding:10px;border-radius:8px;margin:10px 0}
        .warn{background:#fff7ed;border:1px solid #fed7aa;padding:10px;border-radius:8px;margin:10px 0}
        table{width:100%;border-collapse:collapse}
        th,td{padding:10px;border-bottom:1px solid var(--line);text-align:left}
        th{background:#f9fafb}
        .btn{display:inline-block;padding:10px 14px;border-radius:8px;border:1px solid var(--primary);background:var(--primary);color:#fff;text-decoration:none}
        .btn:hover{background:var(--primary-2)}
        .pill{display:inline-block;padding:2px 8px;border-radius:999px;background:#eef2ff;color:var(--primary);font-size:12px}
        .sp{height:12px}
        .toc-title{font-weight:700;margin-bottom:8px}
    </style>
</head>
<body>
<div class="wrap">
    <h1>Help & User Guide</h1>
    <div class="muted">Pahana Edu – Web Billing System</div>
    <div class="sp"></div>

    <div class="grid">
        <!-- Left: Table of contents -->
        <div class="card">
            <div class="bd">
                <div class="toc-title">Contents</div>
                <nav>
                    <ul>
                        <li><a href="#login">Sign In & Sign Out</a></li>
                        <li><a href="#customers">Customers</a></li>
                        <li><a href="#items">Items</a></li>
                        <li><a href="#billing">Create a Bill</a></li>
                        <li><a href="#print">View / Print Bill</a></li>
                        <li><a href="#customer-details">Customer Details Page</a></li>
                        <li><a href="#shortcuts">Useful Shortcuts</a></li>
                        <li><a href="#faq">FAQ</a></li>
                        <li><a href="#contact">Support</a></li>
                    </ul>
                </nav>
                <div class="sp"></div>
                <a class="btn" href="<%=ctx%>/dashboard.jsp">Back to Dashboard</a>
            </div>
        </div>

        <!-- Right: Content -->
        <div>

            <div id="login" class="card">
                <div class="bd">
                    <h2>Sign In & Sign Out</h2>
                    <ol class="step">
                        <li>Open the app and enter your <b>Username</b> and <b>Password</b>, then click <b>Sign in</b>.</li>
                        <li>On success, you’ll land on the <b>Dashboard</b>.</li>
                        <li>To sign out, click <b>Logout</b> (top‑right). Sessions time out automatically after a short period of inactivity.</li>
                    </ol>
                </div>
            </div>

            <div id="customers" class="card">
                <div class="bd">
                    <h2>Customers <span class="pill">Add / Edit / Delete / View</span></h2>

                    <h3>Add a Customer</h3>
                    <ol class="step">
                        <li>Go to <b>Add Customer</b>.</li>
                        <li>Enter <b>Account No</b>, <b>Name</b>, <b>Telephone</b>, and <b>Address</b>.</li>
                        <li>Click <b>Save</b>.</li>
                    </ol>

                    <h3>Edit a Customer</h3>
                    <ol class="step">
                        <li>Open <b>Edit Customer</b>.</li>
                        <li>Click <b>Edit</b> on the row you want to change; the form on the right will load the details.</li>
                        <li>Update fields and click <b>Save Changes</b>.</li>
                    </ol>

                    <h3>Delete a Customer</h3>
                    <ol class="step">
                        <li>In <b>Edit Customer</b>, click <b>Delete</b> on the row.</li>
                        <li>Confirm the prompt to remove the record.</li>
                    </ol>

                    <div class="warn"><b>Note:</b> Customers with existing bills may be protected by business rules. If you cannot delete, keep the record and mark it inactive in the name (e.g., “(Inactive)”).</div>
                </div>
            </div>

            <div id="items" class="card">
                <div class="bd">
                    <h2>Items <span class="pill">Add / Edit / Delete / View</span></h2>
                    <ol class="step">
                        <li>Go to <b>Items</b>.</li>
                        <li>Use the form to add a new item with <b>Name</b>, <b>Price</b>, and <b>Current Stock</b>.</li>
                        <li>Use <b>Edit</b> to update details or <b>Delete</b> to remove an item.</li>
                    </ol>
                    <div class="tip">When a bill is confirmed, the system automatically reduces the item’s stock by the billed quantity.</div>
                </div>
            </div>

            <div id="billing" class="card">
                <div class="bd">
                    <h2>Create a Bill</h2>
                    <ol class="step">
                        <li>Open the <b>Billing</b> page.</li>
                        <li>Select a <b>Customer</b> from the dropdown.</li>
                        <li>Click <b>+ Add Item</b>. Choose an item; price and stock will appear automatically.</li>
                        <li>Enter the <b>Quantity</b>. Add more lines if needed.</li>
                        <li>Check the <b>Subtotal</b> at the bottom.</li>
                        <li>Click <b>Confirm &amp; Generate Bill</b> to save the bill and reduce stock.</li>
                    </ol>
                    <div class="warn"><b>If quantity exceeds stock:</b> reduce the quantity or update the item’s stock on the Items page, then try again.</div>
                </div>
            </div>

            <div id="print" class="card">
                <div class="bd">
                    <h2>View / Print Bill</h2>
                    <p>After confirming a bill, a print‑friendly page opens. Use your browser’s <span class="kbd">Ctrl</span> + <span class="kbd">P</span> to print or save as PDF.</p>
                </div>
            </div>

            <div id="customer-details" class="card">
                <div class="bd">
                    <h2>Customer Details Page</h2>
                    <ol class="step">
                        <li>Open <b>Customer Details</b> from the dashboard.</li>
                        <li>Search by <b>Account No</b> or <b>Name</b>.</li>
                        <li>Click <b>View</b> to see the profile and their billing history.</li>
                    </ol>
                </div>
            </div>

            <div id="shortcuts" class="card">
                <div class="bd">
                    <h2>Useful Shortcuts</h2>
                    <table>
                        <tr><th>Action</th><th>Shortcut</th></tr>
                        <tr><td>Find text on the page</td><td><span class="kbd">Ctrl</span> + <span class="kbd">F</span></td></tr>
                        <tr><td>Print (browser)</td><td><span class="kbd">Ctrl</span> + <span class="kbd">P</span></td></tr>
                        <tr><td>Refresh the page</td><td><span class="kbd">F5</span></td></tr>
                    </table>
                </div>
            </div>

            <div id="faq" class="card">
                <div class="bd">
                    <h2>FAQ</h2>
                    <h3>Why can’t I delete a customer?</h3>
                    <p>The customer may have bills linked to their account. Keep the record or contact an administrator to review.</p>
                    <h3>Why do I get “insufficient stock” when billing?</h3>
                    <p>Reduce the quantity or update the item stock on the Items page, then confirm the bill again.</p>
                    <h3>Can I edit a bill after confirmation?</h3>
                    <p>Bills are final once confirmed. Create a new bill to adjust or add a note for correction as per your process.</p>
                </div>
            </div>

            <div id="contact" class="card">
                <div class="bd">
                    <h2>Support</h2>
                    <p>If you need help, contact your system administrator or email <b>admin@pahana.edu</b>.</p>
                    <p>For security, always sign out after use.</p>
                </div>
            </div>

        </div>
    </div>
</div>
</body>
</html>
