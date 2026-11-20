# ShopMan9 – Đề số 35

Hệ thống quản lý bán hàng bách hóa trực tuyến. Mã nguồn cài đặt 2 modul:

- **Modul 1:** Khách hàng đăng kí thành viên
- **Modul 2:** Nhân viên quản lí xem thống kê mặt hàng theo doanh thu

Công nghệ: Java (JSP + JDBC, mô hình JSP + DAO), MySQL, Maven.

## Cần cài sẵn

- JDK 8 trở lên (đã chạy với JDK 17)
- Maven 3.6 trở lên (hoặc dùng `mvnw` có sẵn trong project)
- MySQL 8

## Chạy trong 3 bước

**1. Tạo CSDL.** Chạy file `database/shopman9.sql`:

```bash
mysql -u root -p < database/shopman9.sql
```

Hoặc mở file trong MySQL Workbench rồi bấm chạy. Script tạo CSDL `shopman9` (13 bảng) kèm dữ liệu mẫu. Nếu CSDL `shopman9` đã có thì script xóa và tạo lại.

**2. Khai báo mật khẩu MySQL.** Mặc định ứng dụng kết nối bằng `root` với mật khẩu trống. Nếu MySQL của bạn có mật khẩu, chép file

```
src/main/resources/db-local.properties.example  →  src/main/resources/db-local.properties
```

rồi sửa dòng `db.password=`. Cũng có thể đặt biến môi trường `DB_USER`, `DB_PASSWORD` (và `DB_URL` nếu MySQL không chạy ở `localhost:3306`).

**3. Chạy ứng dụng.**

```bash
mvn jetty:run
```

Trên Windows nếu chưa cài Maven: `mvnw.cmd jetty:run`. Mở trình duyệt tại **http://localhost:8080/shopman/**

## Chạy bằng IntelliJ + Tomcat 9 (cách khác)

1. *File → Open* → chọn thư mục chứa `pom.xml` → *Trust Project*, chờ IntelliJ nạp xong Maven.
2. *Run → Edit Configurations → + → Tomcat Server → Local*, chọn thư mục Tomcat 9.
3. Tab *Deployment* → *+ → Artifact → demo:war exploded*, ô *Application context* ghi `/shopman`.
4. Bấm Run, mở http://localhost:8080/shopman/

Lưu ý: dùng Tomcat 9 (gói `javax.servlet`), không dùng Tomcat 10 trở lên.

## Tài khoản mẫu

Mật khẩu của mọi tài khoản mẫu: `Abc12345`

| Tài khoản | Vai trò |
|---|---|
| `manager` | Nhân viên quản lí (vào modul 2) |
| `khach01` … `khach08` | Khách hàng |

Dữ liệu hóa đơn mẫu từ 01/2026 đến 11/2026. Ví dụ chọn kì **01/09/2026 – 30/09/2026** để xem thống kê.

## Các đường dẫn

| Đường dẫn | Trang JSP (trong `WEB-INF/views`) |
|---|---|
| `GET /home` | `thanhvien/gdHome9.jsp` |
| `GET /register`, `POST /register` | `thanhvien/gdRegister9.jsp`, `thanhvien/doRegister9.jsp` |
| `GET /login`, `POST /login` | `thanhvien/gdLogin9.jsp`, `thanhvien/doLogin9.jsp` |
| `GET /logout` | `thanhvien/doLogout9.jsp` |
| `GET /manager` | `quanli/gdManagerMain9.jsp` |
| `GET /manager/reports` | `quanli/gdSelectReport9.jsp` |
| `GET /manager/reports/product-revenue?startDate=&endDate=` | `quanli/gdRevenueStat9.jsp` |
| `GET /manager/reports/product-revenue/detail?productId=&startDate=&endDate=` | `quanli/gdProductDetail9.jsp` |
| `GET /manager/reports/product-revenue/transactions?productId=&startDate=&endDate=` | `quanli/gdTransactionHistory9.jsp` |

## Cấu trúc mã nguồn

```
database/shopman9.sql              Script tạo CSDL + dữ liệu mẫu
src/main/java/model/               Lớp thực thể (Member9, Customer9, Product9, RevenueStatistic9, ...)
src/main/java/dao/                 Lớp truy cập CSDL (DAO9, MemberDAO9, CustomerDAO9, RevenueStatisticDAO9, ...)
src/main/resources/db.properties   Cấu hình kết nối MySQL mặc định
src/main/webapp/WEB-INF/views/     Các trang JSP (thanhvien/, quanli/)
src/main/webapp/WEB-INF/web.xml    Khai báo đường dẫn
src/main/webapp/css, images        Giao diện, ảnh mặt hàng
```
