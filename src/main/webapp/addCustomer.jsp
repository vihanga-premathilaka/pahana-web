<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="lk.youruni.pahana.model.Admin" %>
<%
    // Optional: keep the session gate like your other pages
    Admin admin = (Admin) session.getAttribute("ADMIN");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    String err = (String) request.getAttribute("error");
    String ok  = (String) request.getAttribute("success");
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Add Customer — Pahana Edu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{
            --bg:#f6f8fb; --card:#ffffff; --ink:#111827; --muted:#6b7280; --line:#e5e7eb;
            --primary:#2563eb; --primary-2:#1d4ed8; --ok:#059669; --err:#b91c1c;
        }
        *{box-sizing:border-box}
        html,body{margin:0;background:var(--bg);color:var(--ink);font-family:system-ui,Segoe UI,Arial,Helvetica,sans-serif}
        .topbar{
            background:#fff;border-bottom:1px solid var(--line);
            display:flex;align-items:center;justify-content:space-between;
            padding:12px 18px;position:sticky;top:0;z-index:5
        }
        .brand{display:flex;align-items:center;gap:10px;font-weight:800}
        .brand .logo{width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,var(--primary),#60a5fa)}
        .user{display:flex;align-items:center;gap:10px;color:var(--muted);font-size:14px}
        .user a{color:var(--primary);text-decoration:none;font-weight:600}
        .user a:hover{color:var(--primary-2)}

        .wrap{max-width:760px;margin:0 auto;padding:22px}
        h1{margin:0 0 6px}
        .crumbs{font-size:13px;color:var(--muted);margin-bottom:14px}
        .crumbs a{color:var(--primary);text-decoration:none}
        .crumbs a:hover{color:var(--primary-2);text-decoration:underline}

        .card{
            background:var(--card);border:1px solid var(--line);border-radius:14px;
            padding:20px;box-shadow:0 10px 24px rgba(0,0,0,.06);
        }
        .row{margin-bottom:14px}
        label{display:block;font-weight:700;margin-bottom:6px;color:#374151}
        input{
            width:100%;padding:12px 12px;border:1px solid #cfd6e2;border-radius:10px;font-size:15px;
            outline:none;transition:border-color .15s ease, box-shadow .15s ease;
            background:#fff;
        }
        input:focus{border-color:var(--primary);box-shadow:0 0 0 3px rgba(37,99,235,.15)}
        .help{font-size:12px;color:var(--muted);margin-top:6px}

        .banner{
            padding:12px 14px;border-radius:10px;margin-bottom:14px;border:1px solid;
        }
        .banner.ok{background:#ecfdf5;border-color:#a7f3d0;color:#065f46}
        .banner.err{background:#fef2f2;border-color:#fecaca;color:#7f1d1d}

        .actions{display:flex;gap:10px;align-items:center;margin-top:10px}
        .btn{
            display:inline-block;padding:12px 14px;border-radius:10px;border:1px solid var(--primary);
            background:var(--primary);color:#fff;text-decoration:none;font-weight:800;font-size:14px;
            cursor:pointer;min-width:140px;text-align:center;
        }
        .btn:hover{background:var(--primary-2)}
        .btn.secondary{
            background:#fff;color:var(--primary);
        }
        .links{margin-top:14px;font-size:14px}
        .links a{color:var(--primary);text-decoration:none}
        .links a:hover{color:var(--primary-2);text-decoration:underline}

        /* compact on small screens */
        @media (max-width:560px){
            .wrap{padding:16px}
            .actions{flex-direction:column;align-items:stretch}
            .btn{width:100%}
        }
    </style>
</head>
<body>
<header class="topbar">
    <div class="brand">
        <div class="logo" aria-hidden="true"></div>
        <div>Pahana Edu</div>
    </div>
    <div class="user">
        <span>Signed in as <b><%= admin.getFullName() %></b></span>
        <a href="<%=ctx%>/logout.jsp" title="Sign out">Logout</a>
    </div>
</header>

<main class="wrap">
    <div class="crumbs">
        <a href="<%=ctx%>/dashboard.jsp">Dashboard</a> &nbsp;›&nbsp; Add Customer
    </div>
    <h1>Add New Customer</h1>

    <% if (ok != null) { %>
    <div class="banner ok"><%= ok %></div>
    <% } %>
    <% if (err != null) { %>
    <div class="banner err"><%= err %></div>
    <% } %>

    <div class="card">
        <form id="addForm" action="<%=ctx%>/addCustomer" method="post" novalidate>
            <div class="row">
                <label for="accountNo">Account Number</label>
                <input id="accountNo" name="accountNo" type="text" inputmode="numeric" required
                       pattern="\\d{1,9}" placeholder="e.g., 1001" />
                <div class="help">Digits only (max 9). Must be unique.</div>
            </div>

            <div class="row">
                <label for="name">Full Name</label>
                <input id="name" name="name" type="text" required maxlength="100"
                       placeholder="e.g., A. B. Perera" />
            </div>

            <div class="row">
                <label for="telephone">Telephone</label>
                <input id="telephone" name="telephone" type="text" required maxlength="20"
                       pattern="\\+?\\d[\\d\\s-]{6,18}" placeholder="e.g., 077 123 4567" />
                <div class="help">Numbers only; you can include spaces or dashes.</div>
            </div>

            <div class="row">
                <label for="address">Address</label>
                <input id="address" name="address" type="text" required maxlength="200"
                       placeholder="e.g., 221/B, Flower Rd, Colombo 07" />
            </div>

            <div class="actions">
                <button class="btn" type="submit" id="submitBtn">Save Customer</button>
                <a class="btn secondary" href="<%=ctx%>/editCustomer">Manage Customers</a>
            </div>

            <div class="links">
                <a href="<%=ctx%>/dashboard.jsp">← Back to Dashboard</a>
            </div>
        </form>
    </div>
</main>

<script>
    // Small UX: prevent accidental double-submit
    (function(){
        const form = document.getElementById('addForm');
        const btn  = document.getElementById('submitBtn');
        form.addEventListener('submit', function(){
            btn.disabled = true;
            btn.textContent = 'Saving…';
        });

        // Light client-side checks
        form.addEventListener('submit', function(e){
            const acc = document.getElementById('accountNo');
            const tel = document.getElementById('telephone');
            if (acc && !/^\d{1,9}$/.test(acc.value.trim())) {
                e.preventDefault();
                btn.disabled = false; btn.textContent = 'Save Customer';
                alert('Account Number must be 1–9 digits.');
                acc.focus();
                return false;
            }
            if (tel && !/^\+?\d[\d\s-]{6,18}$/.test(tel.value.trim())) {
                e.preventDefault();
                btn.disabled = false; btn.textContent = 'Save Customer';
                alert('Please enter a valid telephone number.');
                tel.focus();
                return false;
            }
        });
    })();
</script>
</body>
</html>
