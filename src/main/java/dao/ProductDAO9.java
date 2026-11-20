package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Product9;

public class ProductDAO9 extends DAO9 {

    public ProductDAO9() {
        super();
    }

    /** Lấy thông tin chi tiết mặt hàng từ tblProduct9; null nếu không có. */
    public Product9 getProductById(int productId) throws SQLException {
        if (con == null) throw new SQLException("Không kết nối được CSDL");
        String sql = "SELECT id, productCode, name, sellingPrice, stockQuantity, description, image "
                + "FROM tblProduct9 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Product9 p = new Product9();
                p.setId(rs.getInt("id"));
                p.setProductCode(rs.getString("productCode"));
                p.setName(rs.getString("name"));
                p.setSellingPrice(rs.getFloat("sellingPrice"));
                p.setStockQuantity(rs.getInt("stockQuantity"));
                p.setDescription(rs.getString("description"));
                p.setImage(rs.getString("image"));
                return p;
            }
        }
    }
}
