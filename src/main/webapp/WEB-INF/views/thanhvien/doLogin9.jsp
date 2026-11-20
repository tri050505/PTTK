<%@page contentType="text/html" pageEncoding="UTF-8" import="model.Member9, dao.MemberDAO9"%>
<%
    // Use case Đăng nhập (Login9 / ManagerLogin9): tiền điều kiện của modul 2
    // POST /login (gdLogin9.jsp chuyển tiếp sang)
    request.setAttribute("handled", Boolean.TRUE);
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username") == null ? "" : request.getParameter("username").trim();
    String password = request.getParameter("password") == null ? "" : request.getParameter("password");

    String errorMessage = null;
    if (username.isEmpty() || password.isEmpty()) {
        errorMessage = "Vui lòng nhập tên đăng nhập và mật khẩu.";
    } else {
        Member9 member = null;
        boolean connected = true;
        try {
            member = new MemberDAO9().login(username, password);
        } catch (Exception e) {
            e.printStackTrace();
            connected = false;
        }

        if (!connected) {
            errorMessage = "Không kết nối được CSDL. Kiểm tra MySQL đã chạy và mật khẩu trong db-local.properties (xem README.md).";
        } else if (member == null) {
            errorMessage = "Sai tên đăng nhập hoặc mật khẩu.";
        } else {
            session.setAttribute("member", member);
            if ("manager".equals(member.getRole())) {
                response.sendRedirect(request.getContextPath() + "/manager");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            return;
        }
    }
    request.setAttribute("errorMessage", errorMessage);
    request.getRequestDispatcher("/WEB-INF/views/thanhvien/gdLogin9.jsp").forward(request, response);
%>
