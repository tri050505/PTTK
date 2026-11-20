package model;

public class InvoiceDetail9 {
    private int id;
    private int quantity;
    private float sellingPrice;
    private float amount;          // thành tiền = quantity x sellingPrice (không lưu CSDL)
    private Product9 product;

    public InvoiceDetail9() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public float getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(float sellingPrice) { this.sellingPrice = sellingPrice; }
    public float getAmount() { return amount; }
    public void setAmount(float amount) { this.amount = amount; }
    public Product9 getProduct() { return product; }
    public void setProduct(Product9 product) { this.product = product; }
}
