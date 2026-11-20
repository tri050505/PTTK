<%@page contentType="text/html" pageEncoding="UTF-8" import="model.*, dao.*, java.util.List, java.sql.Date"%>
<%@include file="_common.jspf"%>
<%!
    /** Dựng bảng các lần giao dịch của mặt hàng. */
    private String viewTransactionHistory(List<Invoice9> invoices) {
        StringBuilder sb = new StringBuilder();
        sb.append("<div class=\"table-wrap\"><table class=\"data\"><thead><tr>")
          .append("<th>TT</th><th>Mã hóa đơn</th><th>Ngày giao dịch</th>")
          .append("<th class=\"num\">SL bán</th><th class=\"num\">Đơn giá</th><th class=\"num\">Thành tiền</th>")
          .append("</tr></thead><tbody>");
        float total = 0;
        int totalQty = 0;
        if (invoices.isEmpty()) {
            sb.append("<tr><td colspan=\"6\" class=\"empty\">Không có giao dịch nào trong kì</td></tr>");
        } else {
            int i = 1;
            for (Invoice9 inv : invoices) {
                for (InvoiceDetail9 d : inv.getDetails()) {
                    total += d.getAmount();
                    totalQty += d.getQuantity();
                    sb.append("<tr><td>").append(i++).append("</td>")
                      .append("<td>").append(esc(inv.getInvoiceCode())).append("</td>")
                      .append("<td>").append(dmy(inv.getOrderDate())).append("</td>")
                      .append("<td class=\"num\">").append(d.getQuantity()).append("</td>")
                      .append("<td class=\"num\">").append(money(d.getSellingPrice())).append("</td>")
                      .append("<td class=\"num\">").append(money(d.getAmount())).append("</td></tr>");
                }
            }
        }
        sb.append("</tbody>");
        if (!invoices.isEmpty()) {
            sb.append("<tfoot><tr><td colspan=\"3\">Tổng cộng</td><td class=\"num\">").append(totalQty)
              .append("</td><td></td><td class=\"num\">").append(money(total)).append("</td></tr></tfoot>");
        }
        sb.append("</table></div>");
        return sb.toString();
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    int productId;
    Date startDate, endDate;
    try {
        productId = Integer.parseInt(request.getParameter("productId"));
        startDate = Date.valueOf(request.getParameter("startDate"));
        endDate = Date.valueOf(request.getParameter("endDate"));
    } catch (Exception e) {
        response.sendRedirect(request.getContextPath() + "/manager/reports/product-revenue");
        return;
    }

    List<Invoice9> invoices = null;
    String errorMessage = null;
    InvoiceDAO9 dao = new InvoiceDAO9();
    try {
        invoices = dao.getInvoicesByProduct(productId, startDate, endDate);
    } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "Không lấy được danh sách giao dịch: " + e.getMessage();
    }

    // Tên mặt hàng lấy từ chi tiết hóa đơn (nếu có giao dịch)
    String productLabel = "";
    if (invoices != null && !invoices.isEmpty()) {
        Product9 p = invoices.get(0).getDetails().get(0).getProduct();
        productLabel = p.getProductCode() + " - " + p.getName();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ShopMan - Các lần giao dịch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@include file="_nav.jspf"%>
<main>
    <div class="card wide">
        <h2 class="page-title">Các lần giao dịch của mặt hàng</h2>
        <p class="subtitle">
            <% if (!productLabel.isEmpty()) { %><strong><%= esc(productLabel) %></strong><br><% } %>
            Kì: <%= dmy(startDate) %> - <%= dmy(endDate) %>
        </p>

        <% if (errorMessage != null) { %>
        <div id="errorMessage" class="show"><%= esc(errorMessage) %></div>
        <% } else { %>
        <%= viewTransactionHistory(invoices) %>
        <% } %>

        <div class="actions">
            <a href="javascript:history.back()" class="btn btn-outline">Quay lại</a>
        </div>
    </div>
</main>
<footer>&copy; ShopMan 2026</footer>
</body>
</html>
