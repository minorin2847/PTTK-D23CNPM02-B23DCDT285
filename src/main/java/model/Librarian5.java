package model;

/** A library staff member: an Employee5 whose role is "librarian". */
public class Librarian5 extends Employee5 {
    private static final long serialVersionUID = 1L;

    public static final String ROLE = "librarian";

    public Librarian5() {
        super();
        setRole(ROLE);
    }
}
