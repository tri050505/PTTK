package dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

/**
 * Lớp cha của các DAO (Hình 2.4, 2.6): giữ thuộc tính con dùng chung,
 * hàm khởi tạo mở kết nối nếu chưa có hoặc kết nối cũ đã mất.
 *
 * Thông tin kết nối không ghi trong code mà đọc lần lượt (cái sau ghi đè cái trước):
 *   1. src/main/resources/db.properties        (mặc định: root, mật khẩu trống)
 *   2. src/main/resources/db-local.properties  (cấu hình riêng từng máy, không đẩy lên Git)
 *   3. biến môi trường DB_URL, DB_USER, DB_PASSWORD
 */
public class DAO9 {
    private static final Properties CONFIG = loadConfig();

    protected static Connection con;

    public DAO9() {
        synchronized (DAO9.class) {
            try {
                if (con == null || !con.isValid(2)) {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(CONFIG.getProperty("db.url"),
                            CONFIG.getProperty("db.user"), CONFIG.getProperty("db.password"));
                }
            } catch (Exception e) {
                System.err.println("Không kết nối được MySQL với " + CONFIG.getProperty("db.url")
                        + ", user " + CONFIG.getProperty("db.user")
                        + ". Kiểm tra db.properties / db-local.properties (xem README.md).");
                e.printStackTrace();
                con = null;
            }
        }
    }

    private static Properties loadConfig() {
        Properties p = new Properties();
        p.setProperty("db.url", "jdbc:mysql://localhost:3306/shopman9?useUnicode=true&characterEncoding=UTF-8"
                + "&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true&useSSL=false");
        p.setProperty("db.user", "root");
        p.setProperty("db.password", "");
        for (String file : new String[]{"db.properties", "db-local.properties"}) {
            try (InputStream in = DAO9.class.getClassLoader().getResourceAsStream(file)) {
                if (in != null) p.load(new java.io.InputStreamReader(in, "UTF-8"));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        String[][] env = {{"DB_URL", "db.url"}, {"DB_USER", "db.user"}, {"DB_PASSWORD", "db.password"}};
        for (String[] e : env) {
            String v = System.getenv(e[0]);
            if (v != null && !v.isEmpty()) p.setProperty(e[1], v);
        }
        return p;
    }
}
