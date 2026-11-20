package model;

/** Lớp trừu tượng (Hình 4.1, 4.6): chỉ tạo đối tượng qua lớp con Manager9. */
public abstract class Staff9 extends Member9 {
    private String staffCode;
    private String position;

    public Staff9() {}

    public String getStaffCode() { return staffCode; }
    public void setStaffCode(String staffCode) { this.staffCode = staffCode; }
    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}
