package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import model.Customer9;

public class CustomerDAO9 extends DAO9 {

    public CustomerDAO9() {
        super();
    }

    /**
     * Lưu tblMember9 (role = "customer") và tblCustomer9 trong cùng một giao dịch (BR07, NFR03).
     * Mã khách hàng = "KH" + id thành viên 5 chữ số; ngày đăng kí = ngày hiện tại.
     * @return true nếu lưu thành công.
     */
    public boolean registerCustomer(Customer9 customer) {
        if (con == null) return false;
        String sqlMember = "INSERT INTO tblMember9(username, password, fullName, birthDate, address, email, phone, role) "
                + "VALUES(?,?,?,?,?,?,?,'customer')";
        String sqlCustomer = "INSERT INTO tblCustomer9(tblMember9id, customerCode, registerDate) VALUES(?,?,?)";
        synchronized (con) {
            try {
                con.setAutoCommit(false);
                int memberId;
                try (PreparedStatement ps = con.prepareStatement(sqlMember, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, customer.getUsername());
                    ps.setString(2, MemberDAO9.hash(customer.getPassword()));
                    ps.setString(3, customer.getFullName());
                    ps.setDate(4, customer.getBirthDate());
                    ps.setString(5, customer.getAddress());
                    ps.setString(6, customer.getEmail());
                    ps.setString(7, customer.getPhone());
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) throw new Exception("Không lấy được id thành viên");
                        memberId = rs.getInt(1);
                    }
                }
                customer.setId(memberId);
                customer.setRole("customer");
                customer.setCustomerCode(String.format("KH%05d", memberId));
                customer.setRegisterDate(new Date(System.currentTimeMillis()));
                try (PreparedStatement ps = con.prepareStatement(sqlCustomer)) {
                    ps.setInt(1, memberId);
                    ps.setString(2, customer.getCustomerCode());
                    ps.setDate(3, customer.getRegisterDate());
                    ps.executeUpdate();
                }
                con.commit();
                return true;
            } catch (Exception e) {
                e.printStackTrace();
                try { con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
                return false;
            } finally {
                try { con.setAutoCommit(true); } catch (Exception ex) { /* bỏ qua */ }
            }
        }
    }
}
