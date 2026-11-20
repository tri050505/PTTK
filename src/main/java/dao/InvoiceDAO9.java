package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Invoice9;
import model.InvoiceDetail9;
import model.Product9;

public class InvoiceDAO9 extends DAO9 {

    public InvoiceDAO9() {
        super();
    }

    /**
     * Các hóa đơn chứa mặt hàng trong kì [startDate, endDate]; mỗi Invoice9 chứa
     * InvoiceDetail9 của mặt hàng đó. Sắp xếp theo ngày đặt mới nhất trước.
     */
    public List<Invoice9> getInvoicesByProduct(int productId, Date startDate, Date endDate) throws SQLException {
        if (con == null) throw new SQLException("Không kết nối được CSDL");
        String sql = "SELECT i.id, i.invoiceCode, i.orderDate, i.deliveryAddress, "
                + "d.id AS detailId, d.quantity, d.sellingPrice, p.id AS productId, p.productCode, p.name "
                + "FROM tblInvoice9 i "
                + "JOIN tblInvoiceDetail9 d ON d.tblInvoice9id = i.id "
                + "JOIN tblProduct9 p ON d.tblProduct9id = p.id "
                + "WHERE d.tblProduct9id = ? AND i.orderDate BETWEEN ? AND ? "
                + "ORDER BY i.orderDate DESC, i.id DESC";
        List<Invoice9> list = new ArrayList<Invoice9>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setDate(2, startDate);
            ps.setDate(3, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product9 p = new Product9();
                    p.setId(rs.getInt("productId"));
                    p.setProductCode(rs.getString("productCode"));
                    p.setName(rs.getString("name"));

                    InvoiceDetail9 d = new InvoiceDetail9();
                    d.setId(rs.getInt("detailId"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setSellingPrice(rs.getFloat("sellingPrice"));
                    d.setAmount(d.getQuantity() * d.getSellingPrice());
                    d.setProduct(p);

                    Invoice9 inv = new Invoice9();
                    inv.setId(rs.getInt("id"));
                    inv.setInvoiceCode(rs.getString("invoiceCode"));
                    inv.setOrderDate(rs.getDate("orderDate"));
                    inv.setDeliveryAddress(rs.getString("deliveryAddress"));
                    inv.getDetails().add(d);
                    list.add(inv);
                }
            }
        }
        return list;
    }
}
