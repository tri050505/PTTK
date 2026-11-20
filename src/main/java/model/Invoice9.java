package model;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class Invoice9 {
    private int id;
    private String invoiceCode;
    private Date orderDate;
    private String deliveryAddress;
    private List<InvoiceDetail9> details = new ArrayList<InvoiceDetail9>();

    public Invoice9() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getInvoiceCode() { return invoiceCode; }
    public void setInvoiceCode(String invoiceCode) { this.invoiceCode = invoiceCode; }
    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }
    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
    public List<InvoiceDetail9> getDetails() { return details; }
    public void setDetails(List<InvoiceDetail9> details) { this.details = details; }
}
