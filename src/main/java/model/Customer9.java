package model;

import java.sql.Date;

public class Customer9 extends Member9 {
    private String customerCode;
    private Date registerDate;

    public Customer9() {}

    public String getCustomerCode() { return customerCode; }
    public void setCustomerCode(String customerCode) { this.customerCode = customerCode; }
    public Date getRegisterDate() { return registerDate; }
    public void setRegisterDate(Date registerDate) { this.registerDate = registerDate; }
}
