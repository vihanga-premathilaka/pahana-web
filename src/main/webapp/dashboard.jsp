<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="lk.youruni.pahana.model.Admin" %>
<%
    Admin admin = (Admin) session.getAttribute("ADMIN");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu – Dashboard</title>
</head>
<body>
<h2>Welcome, <%= admin.getFullName() %>!</h2>
<p>You are logged in as: <b><%= admin.getUsername() %></b></p>
<p><a href="<%=request.getContextPath()%>/logout.jsp">Logout</a></p>
<p><a href="<%=request.getContextPath()%>/addCustomer.jsp">Add Customer</a></p>
<p><a href="<%=request.getContextPath()%>/editCustomer.jsp">Edit Customer</a></p>
<p><a href="<%=request.getContextPath()%>/items.jsp">Manage Item</a></p>
</body>
</html>
