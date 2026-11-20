<%@page contentType="text/html" pageEncoding="UTF-8" import="model.Customer9, dao.MemberDAO9, dao.CustomerDAO9, java.sql.Date"%>
<%!
    private String t(String s) { return s == null ? "" : s.trim(); }
%>
<%
    // POST /register (gdRegister9.jsp chuyển tiếp sang)
    request.setAttribute("handled", Boolean.TRUE);
    // Trang xử lí (không có giao diện riêng): nhận dữ liệu từ gdRegister9.jsp
    request.setCharacterEncoding("UTF-8");

    String fullName  = t(request.getParameter("fullName"));
    String birthStr  = t(request.getParameter("birthDate"));
    String phone     = t(request.getParameter("phone"));
    String address   = t(request.getParameter("address"));
    String email     = t(request.getParameter("email"));
    String username  = t(request.getParameter("username"));
    String password  = request.getParameter("password") == null ? "" : request.getParameter("password");
    String confirm   = request.getParameter("confirmPassword") == null ? "" : request.getParameter("confirmPassword");

    String resultMessage = null;   // lỗi (nếu có)

    // Kiểm tra lại phía server theo Bảng 3.2 (phòng khi người dùng tắt JavaScript)
    Date birthDate = null;
    if (fullName.isEmpty() || birthStr.isEmpty() || phone.isEmpty() || address.isEmpty()
            || email.isEmpty() || username.isEmpty() || password.isEmpty() || confirm.isEmpty()) {
        resultMessage = "Vui lòng nhập đầy đủ các trường bắt buộc.";                                   // BR01
    } else if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$") || email.length() > 255) {
        resultMessage = "Email không đúng định dạng (ví dụ: nguyenvana@gmail.com).";                // BR03
    } else if (!phone.matches("^0\\d{9}$")) {
        resultMessage = "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0.";                   // BR04
    } else if (!username.matches("^[A-Za-z0-9._]{4,50}$")) {
        resultMessage = "Tên đăng nhập dài 4-50 kí tự, không dấu, không chứa khoảng trắng.";       // BR02
    } else if (password.length() < 8 || !password.matches(".*[A-Za-z].*") || !password.matches(".*\\d.*")) {
        resultMessage = "Mật khẩu tối thiểu 8 kí tự, có cả chữ và số.";                              // BR05
    } else if (!password.equals(confirm)) {
        resultMessage = "Mật khẩu nhập lại không khớp.";                                             // BR05
    } else {
        try {
            birthDate = Date.valueOf(birthStr);
            if (!birthDate.before(Date.valueOf(java.time.LocalDate.now()))) {
                resultMessage = "Ngày sinh phải nhỏ hơn ngày hiện tại.";                              // BR06
            }
        } catch (IllegalArgumentException e) {
            resultMessage = "Ngày sinh không hợp lệ.";
        }
    }

    boolean saved = false;
    if (resultMessage == null) {
        // Đóng gói thông tin khách hàng
        Customer9 customer = new Customer9();
        customer.setFullName(fullName);
        customer.setBirthDate(birthDate);
        customer.setPhone(phone);
        customer.setAddress(address);
        customer.setEmail(email);
        customer.setUsername(username);
        customer.setPassword(password);

        // Kiểm tra trùng tên đăng nhập, rồi email (BR02, BR03)
        boolean connected = true, usernameExists = false, emailExists = false;
        try {
            MemberDAO9 memberDAO = new MemberDAO9();
            usernameExists = memberDAO.checkUsernameExists(customer.getUsername());
            emailExists = !usernameExists && memberDAO.checkEmailExists(customer.getEmail());
        } catch (Exception e) {
            e.printStackTrace();
            connected = false;
        }

        if (!connected) {
            resultMessage = "Không kết nối được CSDL. Kiểm tra MySQL đã chạy và mật khẩu trong db-local.properties (xem README.md).";
        } else if (usernameExists) {
            resultMessage = "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.";
        } else if (emailExists) {
            resultMessage = "Email đã được sử dụng. Vui lòng dùng email khác.";
        } else {
            // Lưu tblMember9 + tblCustomer9
            CustomerDAO9 customerDAO = new CustomerDAO9();
            saved = customerDAO.registerCustomer(customer);
            if (!saved) resultMessage = "Đăng kí thất bại, vui lòng thử lại.";
        }
    }

    if (!saved) {
        // Quay lại form, giữ nguyên dữ liệu đã nhập
        request.setAttribute("errorMessage", resultMessage);
        request.getRequestDispatcher("/WEB-INF/views/thanhvien/gdRegister9.jsp").forward(request, response);
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng kí thành công</title>
</head>
<body>
<script>
    alert("Đăng kí thành viên thành công!");
    window.location.href = "${pageContext.request.contextPath}/login";
</script>
</body>
</html>
