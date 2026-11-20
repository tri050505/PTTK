<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    /** Escape HTML để hiển thị lại dữ liệu đã nhập an toàn. */
    private String v(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<%
    // Cùng một URL: GET hiển thị form, POST chuyển cho trang xử lí doRegister9.jsp
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getAttribute("handled") == null) {
        request.getRequestDispatcher("/WEB-INF/views/thanhvien/doRegister9.jsp").forward(request, response);
        return;
    }
    request.setCharacterEncoding("UTF-8");
    // errorMessage: thuộc tính ẩn, nhận thông báo lỗi từ doRegister9.jsp
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ShopMan - Đăng kí thành viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<header>
    <div class="nav">
        <a class="brand" href="${pageContext.request.contextPath}/home">ShopMan</a>
        <ul>
            <li><a class="link" href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <li><a class="link" href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
            <li><a class="link active" href="${pageContext.request.contextPath}/register">Đăng kí thành viên</a></li>
        </ul>
    </div>
</header>
<main>
    <div class="card">
        <h2>Đăng kí thành viên</h2>

        <div id="errorMessage" class="<%= (errorMessage != null) ? "show" : "" %>"><%= v(errorMessage) %></div>

        <form id="registerForm" method="post" action="${pageContext.request.contextPath}/register" onsubmit="return validateForm();" novalidate>
            <div class="form-group">
                <label for="fullName">Họ tên <span class="req">*</span></label>
                <input type="text" id="fullName" name="fullName" maxlength="100" value="<%= v(request.getParameter("fullName")) %>">
            </div>

            <div class="row">
                <div class="form-group">
                    <label for="birthDate">Ngày sinh <span class="req">*</span></label>
                    <input type="date" id="birthDate" name="birthDate" value="<%= v(request.getParameter("birthDate")) %>">
                </div>
                <div class="form-group">
                    <label for="phone">Số điện thoại <span class="req">*</span></label>
                    <input type="tel" id="phone" name="phone" maxlength="10" placeholder="0912345678" value="<%= v(request.getParameter("phone")) %>">
                </div>
            </div>

            <div class="form-group">
                <label for="address">Địa chỉ <span class="req">*</span></label>
                <input type="text" id="address" name="address" maxlength="255" value="<%= v(request.getParameter("address")) %>">
            </div>

            <div class="form-group">
                <label for="email">Email <span class="req">*</span></label>
                <input type="email" id="email" name="email" maxlength="255" value="<%= v(request.getParameter("email")) %>">
            </div>

            <div class="form-group">
                <label for="username">Tên đăng nhập <span class="req">*</span></label>
                <input type="text" id="username" name="username" maxlength="50" value="<%= v(request.getParameter("username")) %>">
            </div>

            <div class="row">
                <div class="form-group">
                    <label for="password">Mật khẩu <span class="req">*</span></label>
                    <input type="password" id="password" name="password" maxlength="50">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Nhập lại mật khẩu <span class="req">*</span></label>
                    <input type="password" id="confirmPassword" name="confirmPassword" maxlength="50">
                </div>
            </div>

            <div class="actions">
                <button type="submit" class="btn">Đăng kí</button>
                <button type="reset" class="btn btn-secondary" onclick="clearError()">Nhập lại</button>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline">Hủy</a>
            </div>
        </form>

        <p class="hint">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
    </div>
</main>
<footer>&copy; ShopMan 2026</footer>

<script>
    // BR06: ngày sinh phải nhỏ hơn ngày hiện tại
    function todayStr() {
        var d = new Date();
        return d.getFullYear() + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" + ("0" + d.getDate()).slice(-2);
    }
    (function () {
        var y = new Date(); y.setDate(y.getDate() - 1);
        document.getElementById("birthDate").max =
            y.getFullYear() + "-" + ("0" + (y.getMonth() + 1)).slice(-2) + "-" + ("0" + y.getDate()).slice(-2);
    })();

    function showError(msg, fieldId) {
        var box = document.getElementById("errorMessage");
        box.textContent = msg;
        box.className = "show";
        if (fieldId) document.getElementById(fieldId).focus();
        return false;
    }

    function clearError() {
        var box = document.getElementById("errorMessage");
        box.textContent = "";
        box.className = "";
    }

    /** Kiểm tra dữ liệu theo Bảng 3.2: BR01 (bắt buộc), BR02 (tên đăng nhập), BR03 (email),
     *  BR04 (số điện thoại), BR05 (mật khẩu), BR06 (ngày sinh). */
    function validateForm() {
        var f = document.getElementById("registerForm");
        var fullName = f.fullName.value.trim();
        var birthDate = f.birthDate.value;
        var phone = f.phone.value.trim();
        var address = f.address.value.trim();
        var email = f.email.value.trim();
        var username = f.username.value.trim();
        var password = f.password.value;
        var confirm = f.confirmPassword.value;

        if (!fullName)  return showError("Vui lòng nhập họ tên.", "fullName");
        if (!birthDate) return showError("Vui lòng chọn ngày sinh.", "birthDate");
        if (birthDate >= todayStr()) return showError("Ngày sinh phải nhỏ hơn ngày hiện tại.", "birthDate");
        if (!phone)     return showError("Vui lòng nhập số điện thoại.", "phone");
        if (!/^0\d{9}$/.test(phone)) return showError("Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0.", "phone");
        if (!address)   return showError("Vui lòng nhập địa chỉ.", "address");
        if (!email)     return showError("Vui lòng nhập email.", "email");
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return showError("Email không đúng định dạng (ví dụ: nguyenvana@gmail.com).", "email");
        if (!username)  return showError("Vui lòng nhập tên đăng nhập.", "username");
        if (!/^[A-Za-z0-9._]{4,50}$/.test(username))
            return showError("Tên đăng nhập dài 4-50 kí tự, không dấu, không chứa khoảng trắng.", "username");
        if (!password)  return showError("Vui lòng nhập mật khẩu.", "password");
        if (password.length < 8 || !/[A-Za-z]/.test(password) || !/\d/.test(password))
            return showError("Mật khẩu tối thiểu 8 kí tự, có cả chữ và số.", "password");
        if (!confirm)   return showError("Vui lòng nhập lại mật khẩu.", "confirmPassword");
        if (password !== confirm) return showError("Mật khẩu nhập lại không khớp.", "confirmPassword");

        clearError();
        return true;
    }
</script>
</body>
</html>
