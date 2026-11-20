<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="_common.jspf"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ShopMan - Trang chủ quản lí</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@include file="_nav.jspf"%>
<main>
    <div class="card wide">
        <h2 class="page-title">Trang chủ nhân viên quản lí</h2>
        <p class="subtitle">Chọn chức năng cần thao tác</p>
        <div class="menu-grid">
            <a id="subViewReport" class="menu-item" href="${pageContext.request.contextPath}/manager/reports">
                <strong>Xem báo cáo</strong>
                <span>Xem thống kê mặt hàng theo doanh thu.</span>
            </a>
        </div>
    </div>
</main>
<footer>&copy; ShopMan 2026</footer>
</body>
</html>
