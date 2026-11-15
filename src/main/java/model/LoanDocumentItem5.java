package model;

import java.io.Serializable;
import java.util.Date;

/** One line of a loan slip: a borrowed document item (table tblLoanDocumentItem5). */
public class LoanDocumentItem5 implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String STATUS_BORROWING = "borrowing";

    private Date dueDate;
    private Date returnDate;
    private String status;
    private LoanSlip5 slip;
    private DocumentItem5 document;

    public LoanDocumentItem5() {
    }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LoanSlip5 getSlip() { return slip; }
    public void setSlip(LoanSlip5 slip) { this.slip = slip; }

    public DocumentItem5 getDocument() { return document; }
    public void setDocument(DocumentItem5 document) { this.document = document; }
}
