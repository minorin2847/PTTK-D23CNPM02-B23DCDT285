package model;

import java.io.Serializable;
import java.util.Date;

/** Reader card of a reader (table tblReaderCard5). */
public class ReaderCard5 implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String STATUS_ACTIVE = "active";

    private int id;
    private byte[] image;
    private Date issueDate;
    private String status;
    private Reader5 reader;

    public ReaderCard5() {
    }

    /** A card can be used to borrow documents only while it is active. */
    public boolean isActive() {
        return STATUS_ACTIVE.equalsIgnoreCase(status);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public byte[] getImage() { return image; }
    public void setImage(byte[] image) { this.image = image; }

    public Date getIssueDate() { return issueDate; }
    public void setIssueDate(Date issueDate) { this.issueDate = issueDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Reader5 getReader() { return reader; }
    public void setReader(Reader5 reader) { this.reader = reader; }
}
