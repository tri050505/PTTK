<%@page contentType="text/html" pageEncoding="UTF-8" import="model.*, dao.*, java.util.List, java.sql.Date"%>
<%@include file="_common.jspf"%>
<%!
    /** Dựng bảng danh sách mặt hàng theo doanh thu. */
    private String viewProductRevenueList(String ctx, List<RevenueStatistic9> list, Date start, Date end) {
        StringBuilder sb = new StringBuilder();
        sb.append("<div class=\"table-wrap\"><table class=\"data\"><thead><tr>")
          .append("<th>TT</th><th>Mã hàng</th><th>Tên hàng</th>")
          .append("<th class=\"num\">SL bán</th><th class=\"num\">Doanh thu</th><th>Xem chi tiết</th>")
          .append("</tr></thead><tbody>");
        if (list.isEmpty()) {
            sb.append("<tr><td colspan=\"6\" class=\"empty\">Không có dữ liệu thống kê trong khoảng thời gian này</td></tr>");
        } else {
            int i = 1;
            for (RevenueStatistic9 r : list) {
                String url = ctx + "/manager/reports/product-revenue/detail?productId=" + r.getId()
                        + "&amp;startDate=" + start + "&amp;endDate=" + end;
                sb.append("<tr><td>").append(i++).append("</td>")
                  .append("<td>").append(esc(r.getProductCode())).append("</td>")
                  .append("<td>").append(esc(r.getName())).append("</td>")
                  .append("<td class=\"num\">").append(r.getQuantitySold()).append("</td>")
                  .append("<td class=\"num\">").append(money(r.getRevenue())).append("</td>")
                  .append("<td><a class=\"link-btn\" href=\"").append(url).append("\">xem</a></td></tr>");
            }
        }
        sb.append("</tbody></table></div>");
        return sb.toString();
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    String startStr = request.getParameter("startDate") == null ? "" : request.getParameter("startDate").trim();
    String endStr   = request.getParameter("endDate") == null ? "" : request.getParameter("endDate").trim();

    String errorMessage = null;
    List<RevenueStatistic9> statList = null;
    Date startDate = null, endDate = null;
    float totalRevenue = 0;

    if (!startStr.isEmpty() || !endStr.isEmpty()) {
        if (startStr.isEmpty() || endStr.isEmpty()) {
            errorMessage = "Vui lòng chọn đủ ngày bắt đầu và ngày kết thúc.";
        } else {
            try {
                startDate = Date.valueOf(startStr);
                endDate = Date.valueOf(endStr);
            } catch (IllegalArgumentException e) {
                errorMessage = "Ngày không hợp lệ.";
            }
            if (errorMessage == null && startDate.after(endDate)) {
                errorMessage = "Ngày bắt đầu không được lớn hơn ngày kết thúc.";
            }
            if (errorMessage == null) {
                RevenueStatisticDAO9 dao = new RevenueStatisticDAO9();
                try {
                    statList = dao.getRevenueStatistic(startDate, endDate);
                    for (RevenueStatistic9 r : statList) totalRevenue += r.getRevenue();
                    // Lưu kết quả để trang chi tiết lấy lại số lượng bán, doanh thu của mặt hàng
                    session.setAttribute("revenueStatList", statList);
                    session.setAttribute("revenueStatRange", startDate + "_" + endDate);
                    if (statList.isEmpty()) errorMessage = "Không có dữ liệu thống kê trong khoảng thời gian này.";
                } catch (Exception e) {
                    e.printStackTrace();
                    errorMessage = "Không lấy được dữ liệu thống kê: " + e.getMessage();
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ShopMan - Thống kê mặt hàng theo doanh thu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@include file="_nav.jspf"%>
<main>
    <div class="card wide">
        <h2 class="page-title">Thống kê mặt hàng theo doanh thu</h2>
        <p class="subtitle">Chọn khoảng thời gian cần thống kê</p>

        <div id="errorMessage" class="<%= (errorMessage != null) ? "show" : "" %>"><%= esc(errorMessage) %></div>

        <form id="rangeForm" class="inline-form" method="get" action="${pageContext.request.contextPath}/manager/reports/product-revenue" onsubmit="return selectDateRange();" novalidate>
            <div class="form-group">
                <label for="startDate">Ngày bắt đầu</label>
                <input type="date" id="startDate" name="startDate" value="<%= esc(startStr) %>">
            </div>
            <div class="form-group">
                <label for="endDate">Ngày kết thúc</label>
                <input type="date" id="endDate" name="endDate" value="<%= esc(endStr) %>">
            </div>
            <button type="submit" class="btn">Xem</button>
        </form>

        <% if (statList != null) { %>
        <p class="summary">
            Kì thống kê: <strong><%= dmy(startDate) %></strong> - <strong><%= dmy(endDate) %></strong>
            &nbsp;|&nbsp; Số mặt hàng: <strong><%= statList.size() %></strong>
            &nbsp;|&nbsp; Tổng doanh thu: <strong><%= money(totalRevenue) %></strong>
        </p>
        <%= viewProductRevenueList(request.getContextPath(), statList, startDate, endDate) %>
        <% } %>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/manager/reports" class="btn btn-outline">Quay lại</a>
        </div>
    </div>
</main>
<footer>&copy; ShopMan 2026</footer>

<script>
    /** Kiểm tra khoảng thời gian: bắt buộc chọn đủ, ngày bắt đầu không lớn hơn ngày kết thúc. */
    function selectDateRange() {
        var s = document.getElementById("startDate").value;
        var e = document.getElementById("endDate").value;
        var box = document.getElementById("errorMessage");
        var msg = "";
        if (!s || !e) msg = "Vui lòng chọn đủ ngày bắt đầu và ngày kết thúc.";
        else if (s > e) msg = "Ngày bắt đầu không được lớn hơn ngày kết thúc.";
        if (msg) {
            box.textContent = msg;
            box.className = "show";
            return false;
        }
        return true;
    }
</script>
</body>
</html>
