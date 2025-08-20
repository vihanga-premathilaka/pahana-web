<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="lk.youruni.pahana.model.Admin" %>
<%
    Admin admin = (Admin) session.getAttribute("ADMIN");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu – Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{
            --bg:#f6f8fb; --card:#ffffff; --ink:#111827; --ink2:#374151;
            --muted:#6b7280; --line:#e5e7eb; --primary:#2563eb; --primary-2:#1d4ed8;
            --good:#059669; --warn:#d97706;
        }
        *{box-sizing:border-box}
        html,body{margin:0;background:var(--bg);color:var(--ink);font-family:system-ui,Segoe UI,Arial,Helvetica,sans-serif}
        .topbar{
            background:#ffffff;border-bottom:1px solid var(--line);
            display:flex;align-items:center;justify-content:space-between;
            padding:12px 18px;position:sticky;top:0;z-index:10
        }
        .brand{display:flex;align-items:center;gap:10px;font-weight:800}
        .brand .logo{width:32px;height:32px;border-radius:8px;background:linear-gradient(135deg,var(--primary),#60a5fa)}
        .user{display:flex;align-items:center;gap:12px}
        .user .name{font-weight:600}
        .user a{color:var(--primary);text-decoration:none;font-weight:600}
        .user a:hover{color:var(--primary-2)}
        .wrap{max-width:1100px;margin:0 auto;padding:22px}
        h1{margin:0 0 8px;font-size:24px}
        .muted{color:var(--muted)}
        .grid{
            display:grid;gap:18px;
            grid-template-columns:repeat(3,minmax(0,1fr));
        }
        @media (max-width:980px){ .grid{grid-template-columns:repeat(2,minmax(0,1fr));} }
        @media (max-width:640px){ .grid{grid-template-columns:1fr;} }

        .card{
            background:var(--card);border:1px solid var(--line);border-radius:14px;
            padding:18px;box-shadow:0 8px 24px rgba(0,0,0,.06);
            display:flex;flex-direction:column;gap:10px;min-height:130px;
            transition:transform .08s ease, box-shadow .08s ease, border-color .08s ease;
        }
        .card:hover{transform:translateY(-2px);border-color:#dbe3ef;box-shadow:0 12px 30px rgba(0,0,0,.08)}
        .card h3{margin:0;font-size:18px}
        .card p{margin:0;color:var(--muted);font-size:14px;line-height:1.35}
        .actions{margin-top:auto;display:flex;gap:10px;flex-wrap:wrap}
        .btn{
            display:inline-block;padding:10px 12px;border-radius:10px;border:1px solid var(--primary);
            background:var(--primary);color:#fff;text-decoration:none;font-weight:700;font-size:14px
        }
        .btn:hover{background:var(--primary-2)}
        .btn-outline{
            background:#fff;color:var(--primary);border-color:var(--primary);font-weight:700
        }
        .kpi{
            display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin:16px 0 22px;
        }
        .k{background:#fff;border:1px solid var(--line);border-radius:12px;padding:12px}
        .k .t{font-size:12px;color:var(--muted)}
        .k .v{font-size:20px;font-weight:800;margin-top:4px}
        .note{background:#ecfeff;border:1px solid #bae6fd;color:#0e7490;padding:10px;border-radius:10px;margin:14px 0}
    </style>
</head>
<body>
<header class="topbar">
    <div class="brand">
        <div class="logo" aria-hidden="true"></div>
        <div>Pahana Edu</div>
    </div>
    <div class="user">
        <div class="name">Welcome, <%= admin.getFullName() %></div>
        <span class="muted">(<%= admin.getUsername() %>)</span>
        <a href="<%=ctx%>/logout.jsp" title="Sign out">Logout</a>
    </div>
</header>

<main class="wrap">
    <h1>Dashboard</h1>
    <div class="muted">Quick access to customers, items, billing, and reports.</div>

    <!-- Optional friendly note -->
    <div class="note">Tip: Use the <b>Help &amp; User Guide</b> for step‑by‑step instructions on each page.</div>

    <!-- Optional KPIs (static placeholders; wire to real counts later if you like) -->
    <section class="kpi" aria-label="Key indicators">
        <div class="k">
            <div class="t">Signed-in Admin</div>
            <div class="v"><%= admin.getFullName() %></div>
        </div>
        <div class="k">
            <div class="t">Today</div>
            <div class="v"><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %></div>
        </div>
        <div class="k">
            <div class="t">Status</div>
            <div class="v" style="color:var(--good)">Online</div>
        </div>
    </section>

    <section class="grid" aria-label="Main navigation">
        <!-- Add Customer -->
        <article class="card">
            <h3>Add Customer</h3>
            <p>Create a new customer account with account no., name, phone and address.</p>
            <div class="actions">
                <a class="btn" href="<%=ctx%>/addCustomer.jsp">Open</a>
                <a class="btn btn-outline" href="<%=ctx%>/editCustomer">Manage</a>
            </div>
        </article>

        <!-- Edit Customer -->
        <article class="card">
            <h3>Edit / Delete Customers</h3>
            <p>View the customer list, edit details, or remove records.</p>
            <div class="actions">
                <a class="btn" href="<%=ctx%>/editCustomer">Open</a>
            </div>
        </article>

        <!-- Items -->
        <article class="card">
            <h3>Item Management</h3>
            <p>Add, update, delete, and view items with price and current stock.</p>
            <div class="actions">
                <a class="btn" href="<%=ctx%>/items">Open</a>
                <a class="btn btn-outline" href="<%=ctx%>/items">View</a>
            </div>
        </article>

        <!-- Billing -->
        <article class="card">
            <h3>Create a Bill</h3>
            <p>Select a customer, add items &amp; quantities, confirm and print the bill.</p>
            <div class="actions">
                <a class="btn" href="<%=ctx%>/billing">Open</a>
            </div>
        </article>

        <!-- Customer Details -->
        <article class="card">
            <h3>Customer Details</h3>
            <p>Search by account no. or name and view profile with billing history.</p>
            <div class="actions">
                <a class="btn" href="<%=ctx%>/customerDetails">Open</a>
            </div>
        </article>

        <!-- Help -->
        <article class="card">
            <h3>Help &amp; User Guide</h3>
            <p>Step‑by‑step instructions, tips, FAQs and troubleshooting.</p>
            <div class="actions">
                <a class="btn" href="<%=ctx%>/help">Open</a>
            </div>
        </article>
    </section>
</main>
</body>
</html>
