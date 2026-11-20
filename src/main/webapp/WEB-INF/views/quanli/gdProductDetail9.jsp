<%@page contentType="text/html" pageEncoding="UTF-8" import="model.*, dao.*, java.util.List, java.sql.Date"%>
<%@include file="_common.jspf"%>
<%!
    /** Ghép thông tin mặt hàng với số lượng bán, doanh thu trong kì. */
    private String viewProductDetail(String ctx, Product9 p, int quantitySold, float revenue, Date start, Date end) {
        StringBuilder sb = new StringBuilder("<div class=\"product-detail\">");
        if (p.getImage() != null && !p.getImage().isEmpty()) {
            sb.append("<img class=\"product-img\" src=\"").append(ctx).append("/").append(esc(p.getImage()))
              .append("\" alt=\"").append(esc(p.getName())).append("\">");
        } else {
            sb.append("<div class=\"product-img no-img\">Chưa có hình ảnh</div>");
        }
        sb.append("<dl class=\"info\">");
        sb.append("<dt>Mã hàng</dt><dd>").append(esc(p.getProductCode())).append("</dd>");
        sb.append("<dt>Tên hàng</dt><dd>").append(esc(p.getName())).append("</dd>");
        sb.append("<dt>Đơn giá bán</dt><dd>").append(money(p.getSellingPrice())).append("</dd>");
        sb.append("<dt>Mô tả</dt><dd>").append(p.getDescription() == null || p.getDescription().isEmpty() ? "-" : esc(p.getDescription())).append("</dd>");
        sb.append("<dt>Kì thống kê</dt><dd>").append(dmy(start)).append(" - ").append(dmy(end)).append("</dd>");
        sb.append("<dt>Số lượng bán trong kì</dt><dd><strong>").append(quantitySold).append("</strong></dd>");
        sb.append("<dt>Doanh thu trong kì</dt><dd><strong>").append(money(revenue)).append("</strong></dd>");
        sb.append("</dl></div>");
        return sb.toString();
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    int productId;
    int quantitySold = 0;
    float revenue = 0;
    Date startDate, endDate;
    try {
        productId = Integer.parseInt(request.getParameter("productId"));
        startDate = Date.valueOf(request.getParameter("startDate"));
        endDate = Date.valueOf(request.getParameter("endDate"));
    } catch (Exception e) {
        // Thiếu/sai tham số: quay về trang chọn kì thống kê
        response.sendRedirect(request.getContextPath() + "/manager/reports/product-revenue");
        return;
    }

    Product9 product = null;
    String errorMessage = null;
    // Số lượng bán, doanh thu của mặt hàng: lấy từ danh sách thống kê vừa xem (session);
    // nếu mở trực tiếp bằng đường dẫn thì thống kê lại cho đúng kì.
    try {
        List<RevenueStatistic9> stats = null;
        if ((startDate + "_" + endDate).equals(session.getAttribute("revenueStatRange"))) {
            stats = (List<RevenueStatistic9>) session.getAttribute("revenueStatList");
        }
        if (stats == null) stats = new RevenueStatisticDAO9().getRevenueStatistic(startDate, endDate);
        for (RevenueStatistic9 r : stats) {
            if (r.getId() == productId) { quantitySold = r.getQuantitySold(); revenue = r.getRevenue(); break; }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    ProductDAO9 dao = new ProductDAO9();
    try {
        product = dao.getProductById(productId);
        if (product == null) errorMessage = "Không tìm thấy mặt hàng.";
    } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "Không lấy được thông tin mặt hàng: " + e.getMessage();
    }

    String ctx = request.getContextPath();
    String backUrl = ctx + "/manager/reports/product-revenue?startDate=" + startDate + "&endDate=" + endDate;
    String historyUrl = ctx + "/manager/reports/product-revenue/transactions?productId=" + productId
            + "&startDate=" + startDate + "&endDate=" + endDate;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ShopMan - Chi tiết mặt hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@include file="_nav.jspf"%>
<main>
    <div class="card wide">
        <h2 class="page-title">Chi tiết mặt hàng</h2>
        <p class="subtitle">Thông tin mặt hàng và kết quả bán hàng trong kì</p>

        <% if (errorMessage != null) { %>
        <div id="errorMessage" class="show"><%= esc(errorMessage) %></div>
        <% } else { %>
        <%= viewProductDetail(ctx, product, quantitySold, revenue, startDate, endDate) %>
        <% } %>

        <div class="actions">
            <a href="<%= backUrl %>" class="btn btn-outline">Quay lại</a>
            <% if (errorMessage == null) { %>
            <a href="<%= historyUrl %>" class="btn">Xem các lần giao dịch</a>
            <% } %>
        </div>
    </div>
</main>
<footer>&copy; ShopMan 2026</footer>
</body>
</html>
