package model;

/**
 * Lớp thống kê mặt hàng theo doanh thu: kế thừa Product9 (Hình 4.1, 4.6),
 * chỉ bổ sung số lượng bán và doanh thu trong kì. Không có bảng riêng trong CSDL.
 */
public class RevenueStatistic9 extends Product9 {
    private int quantitySold;
    private float revenue;

    public RevenueStatistic9() {
        super();
    }

    public int getQuantitySold() { return quantitySold; }
    public void setQuantitySold(int quantitySold) { this.quantitySold = quantitySold; }
    public float getRevenue() { return revenue; }
    public void setRevenue(float revenue) { this.revenue = revenue; }
}
