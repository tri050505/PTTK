package dao;

import java.security.MessageDigest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Manager9;
import model.Member9;

public class MemberDAO9 extends DAO9 {

    public MemberDAO9() {
        super();
    }

    /** true nếu tên đăng nhập đã tồn tại trong tblMember9 (BR02). */
    public boolean checkUsernameExists(String username) throws SQLException {
        return exists("SELECT 1 FROM tblMember9 WHERE username = ?", username);
    }

    /** true nếu email đã tồn tại trong tblMember9 (BR03). */
    public boolean checkEmailExists(String email) throws SQLException {
        return exists("SELECT 1 FROM tblMember9 WHERE email = ?", email);
    }

    /**
     * Thuộc use case Đăng nhập (Login9, FR01; ManagerLogin9 kế thừa) - tiền điều kiện của modul 2.
     * @return Manager9 nếu role = "manager", Member9 với vai trò khác, null nếu sai thông tin.
     */
    public Member9 login(String username, String password) throws SQLException {
        if (con == null) throw new SQLException("Không kết nối được CSDL");
        String sql = "SELECT m.id, m.username, m.fullName, m.birthDate, m.address, m.email, m.phone, m.role, "
                + "s.staffCode, s.position "
                + "FROM tblMember9 m LEFT JOIN tblStaff9 s ON s.tblMember9id = m.id "
                + "WHERE m.username = ? AND m.password = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hash(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                String role = rs.getString("role");
                Member9 m;
                if ("manager".equals(role)) {
                    Manager9 mg = new Manager9();
                    mg.setStaffCode(rs.getString("staffCode"));
                    mg.setPosition(rs.getString("position"));
                    m = mg;
                } else {
                    m = new Member9();
                }
                m.setId(rs.getInt("id"));
                m.setUsername(rs.getString("username"));
                m.setFullName(rs.getString("fullName"));
                m.setBirthDate(rs.getDate("birthDate"));
                m.setAddress(rs.getString("address"));
                m.setEmail(rs.getString("email"));
                m.setPhone(rs.getString("phone"));
                m.setRole(role);
                return m;
            }
        }
    }

    private boolean exists(String sql, String value) throws SQLException {
        if (con == null) throw new SQLException("Không kết nối được CSDL");
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Băm SHA-256 (NFR04: không lưu mật khẩu bản rõ). */
    static String hash(String s) {
        try {
            byte[] d = MessageDigest.getInstance("SHA-256").digest(s.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : d) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
