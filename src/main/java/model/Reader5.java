package model;

/** A reader (student) of the library (table tblReader5). */
public class Reader5 extends User5 {
    private static final long serialVersionUID = 1L;

    private String studentid;

    public Reader5() {
        super();
    }

    public String getStudentid() { return studentid; }
    public void setStudentid(String studentid) { this.studentid = studentid; }
}
