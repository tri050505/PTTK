<%@page contentType="text/html" pageEncoding="UTF-8" import="model.Member9"%>
<%
    Member9 member = (Member9) session.getAttribute("member");
    boolean isManager = member != null && "manager".equals(member.getRole());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ShopMan - Trang chủ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<header>
    <div class="nav">
        <a class="brand" href="${pageContext.request.contextPath}/home">ShopMan</a>
        <ul>
            <li><a class="link active" href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <% if (member == null) { %>
            <li><a class="link" href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
            <li><a class="link" href="${pageContext.request.contextPath}/register">Đăng kí thành viên</a></li>
            <% } else { %>
            <% if (isManager) { %><li><a class="link" href="${pageContext.request.contextPath}/manager">Trang quản lí</a></li><% } %>
            <li><span class="who">Xin chào, <%= member.getFullName().replace("<", "&lt;").replace(">", "&gt;") %></span></li>
            <li><a class="link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
            <% } %>
        </ul>
    </div>
</header>
<main>
    <section class="hero">
        <h1>Chào mừng đến với ShopMan</h1>
        <p>Hệ thống bán hàng bách hóa trực tuyến - mua sắm nhanh chóng, tiện lợi.</p>
        <% if (member == null) { %>
        <a class="btn" href="${pageContext.request.contextPath}/register">Đăng kí thành viên</a>
        <a class="btn btn-outline" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        <% } else if (isManager) { %>
        <a class="btn" href="${pageContext.request.contextPath}/manager">Vào trang quản lí</a>
        <% } %>
    </section>
</main>
<footer>&copy; ShopMan 2026</footer>
</body>
</html>
