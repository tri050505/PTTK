package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.RevenueStatistic9;

public class RevenueStatisticDAO9 extends DAO9 {

    public RevenueStatisticDAO9() {
        super();
    }

    /**
     * Truy vấn gộp theo từng mặt hàng trên tblInvoiceDetail9 và tblInvoice9
     * (lọc theo orderDate trong [startDate, endDate]), sắp xếp doanh thu giảm dần.
     */
    public List<RevenueStatistic9> getRevenueStatistic(Date startDate, Date endDate) throws SQLException {
        if (con == null) throw new SQLException("Không kết nối được CSDL");
        String sql = "SELECT p.id, p.productCode, p.name, p.sellingPrice, "
                + "SUM(d.quantity) AS quantitySold, SUM(d.quantity * d.sellingPrice) AS revenue "
                + "FROM tblInvoiceDetail9 d "
                + "JOIN tblInvoice9 i ON d.tblInvoice9id = i.id "
                + "JOIN tblProduct9 p ON d.tblProduct9id = p.id "
                + "WHERE i.orderDate BETWEEN ? AND ? "
                + "GROUP BY p.id, p.productCode, p.name, p.sellingPrice "
                + "ORDER BY revenue DESC, p.productCode";
        List<RevenueStatistic9> list = new ArrayList<RevenueStatistic9>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RevenueStatistic9 r = new RevenueStatistic9();
                    r.setId(rs.getInt("id"));
                    r.setProductCode(rs.getString("productCode"));
                    r.setName(rs.getString("name"));
                    r.setSellingPrice(rs.getFloat("sellingPrice"));
                    r.setQuantitySold(rs.getInt("quantitySold"));
                    r.setRevenue(rs.getFloat("revenue"));
                    list.add(r);
                }
            }
        }
        return list;
    }
}
