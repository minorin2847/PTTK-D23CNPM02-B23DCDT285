package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

/** A loan slip: one reader card borrowing several document items (table tblLoanSlip5). */
public class LoanSlip5 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Date loanDate;
    private ReaderCard5 reader;
    private ArrayList<LoanDocumentItem5> documents = new ArrayList<>();

    public LoanSlip5() {
    }

    /** True if the given document item is already on this slip. */
    public boolean containsItem(int documentItemId) {
        for (LoanDocumentItem5 item : documents) {
            if (item.getDocument() != null && item.getDocument().getId() == documentItemId) {
                return true;
            }
        }
        return false;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Date getLoanDate() { return loanDate; }
    public void setLoanDate(Date loanDate) { this.loanDate = loanDate; }

    public ReaderCard5 getReader() { return reader; }
    public void setReader(ReaderCard5 reader) { this.reader = reader; }

    public ArrayList<LoanDocumentItem5> getDocuments() { return documents; }
    public void setDocuments(ArrayList<LoanDocumentItem5> documents) { this.documents = documents; }
}
