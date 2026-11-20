<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="_common.jspf"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ShopMan - Chọn loại thống kê</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@include file="_nav.jspf"%>
<main>
    <div class="card wide">
        <h2 class="page-title">Xem báo cáo</h2>
        <p class="subtitle">Chọn loại thống kê</p>
        <div id="reportMenu" class="menu-grid"></div>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/manager" class="btn btn-outline">Quay lại</a>
        </div>
    </div>
</main>
<footer>&copy; ShopMan 2026</footer>

<script>
    /** Dựng danh sách các loại thống kê. */
    function selectReport() {
        // 4 loại thống kê theo kịch bản 3.2.1 (bước 2); modul này cài đặt thống kê mặt hàng theo doanh thu
        var reports = [
            {id: "linkImportStat",   name: "Thống kê hàng nhập", desc: "Chưa có trong phạm vi hai modul đã chọn.", enabled: false},
            {id: "linkRevenueStat",  name: "Thống kê mặt hàng theo doanh thu", desc: "Số lượng bán và doanh thu của từng mặt hàng trong kì.", href: "${pageContext.request.contextPath}/manager/reports/product-revenue", enabled: true},
            {id: "linkCustomerStat", name: "Thống kê khách hàng", desc: "Chưa có trong phạm vi hai modul đã chọn.", enabled: false},
            {id: "linkSupplierStat", name: "Thống kê nhà cung cấp", desc: "Chưa có trong phạm vi hai modul đã chọn.", enabled: false}
        ];
        var menu = document.getElementById("reportMenu");
        reports.forEach(function (r) {
            var el = document.createElement(r.enabled ? "a" : "div");
            el.id = r.id;
            el.className = "menu-item" + (r.enabled ? "" : " disabled");
            if (r.enabled) el.href = r.href;
            var title = document.createElement("strong");
            title.textContent = r.name;
            var desc = document.createElement("span");
            desc.textContent = r.desc;
            el.appendChild(title);
            el.appendChild(desc);
            menu.appendChild(el);
        });
    }
    selectReport();
</script>
</body>
</html>
