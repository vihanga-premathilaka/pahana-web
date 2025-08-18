<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu – Admin Login</title>
    <style>
        body{font-family:Arial,Helvetica,sans-serif;background:#f6f8fb;margin:0}
        .card{max-width:380px;margin:10vh auto;background:#fff;border:1px solid #e5e7eb;border-radius:12px;padding:24px;box-shadow:0 10px 20px rgba(0,0,0,.05)}
        h1{margin:0 0 18px;font-size:20px}
        .field{margin-bottom:14px}
        label{display:block;margin-bottom:6px;color:#374151;font-size:14px}
        input{width:100%;padding:10px 12px;border:1px solid #d1d5db;border-radius:8px;font-size:14px}
        button{width:100%;padding:10px 12px;border:0;border-radius:8px;background:#2563eb;color:#fff;font-weight:600;cursor:pointer}
        .err{background:#fee2e2;color:#991b1b;padding:10px;border-radius:8px;margin-bottom:12px}
    </style>
</head>
<body>
<div class="card">
    <h1>Admin Login</h1>
    <%
        String err = (String) request.getAttribute("error");
        if (err != null) {
    %>
    <div class="err"><%= err %></div>
    <% } %>
    <form method="post" action="<%=request.getContextPath()%>/login">
        <div class="field">
            <label for="username">Username</label>
            <input id="username" name="username" required />
        </div>
        <div class="field">
            <label for="password">Password</label>
            <input id="password" name="password" type="password" required />
        </div>
        <button type="submit">Sign in</button>
    </form>
</div>
</body>
</html>
