package model;

/** An employee of the library (table tblEmployee5). */
public class Employee5 extends User5 {
    private static final long serialVersionUID = 1L;

    private String role;

    public Employee5() {
        super();
    }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}
