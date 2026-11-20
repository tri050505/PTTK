<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    private String v(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<%
    // Cùng một URL: GET hiển thị form, POST chuyển cho trang xử lí doLogin9.jsp
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getAttribute("handled") == null) {
        request.getRequestDispatcher("/WEB-INF/views/thanhvien/doLogin9.jsp").forward(request, response);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ShopMan - Đăng nhập</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<header>
    <div class="nav">
        <a class="brand" href="${pageContext.request.contextPath}/home">ShopMan</a>
        <ul>
            <li><a class="link" href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <li><a class="link active" href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
            <li><a class="link" href="${pageContext.request.contextPath}/register">Đăng kí thành viên</a></li>
        </ul>
    </div>
</header>
<main>
    <div class="card">
        <h2>Đăng nhập</h2>
        <div id="errorMessage" class="<%= (errorMessage != null) ? "show" : "" %>"><%= v(errorMessage) %></div>
        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-group">
                <label for="username">Tên đăng nhập</label>
                <input type="text" id="username" name="username" value="<%= v(request.getParameter("username")) %>">
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password">
            </div>
            <div class="actions">
                <button type="submit" class="btn">Đăng nhập</button>
            </div>
        </form>
        <p class="hint">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng kí thành viên</a></p>
    </div>
</main>
<footer>&copy; ShopMan 2026</footer>
</body>
</html>
