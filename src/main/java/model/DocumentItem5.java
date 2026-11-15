package model;

import java.io.Serializable;

/** One physical copy of a document, identified by its barcode (table tblDocumentItem5). */
public class DocumentItem5 implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String STATUS_AVAILABLE = "available";
    public static final String STATUS_BORROWED = "borrowed";

    private int id;
    private String status;
    private Document5 document;

    public DocumentItem5() {
    }

    public boolean isAvailable() {
        return STATUS_AVAILABLE.equalsIgnoreCase(status);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Document5 getDocument() { return document; }
    public void setDocument(Document5 document) { this.document = document; }
}
