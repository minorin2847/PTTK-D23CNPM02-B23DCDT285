package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Document5;
import model.DocumentItem5;

/** Module 2 - Library staff lends documents: look up a scanned document copy. */
public class DocumentItemDAO5 extends DAO5 {

    public DocumentItemDAO5() {
        super();
    }

    /**
     * Loads one physical copy together with its document information.
     *
     * @param id the barcode scanned from / typed in for the copy
     * @return the copy, or null if no copy has this id
     */
    public DocumentItem5 getDocument(int id) {
        String sql = "SELECT i.id AS itemId, i.status AS itemStatus, d.* "
                + "FROM tblDocumentItem5 i "
                + "JOIN tblDocument5 d ON d.code = i.tblDocument5code "
                + "WHERE i.id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Document5 d = new Document5();
                d.setCode(rs.getString("code"));
                d.setType(rs.getString("type"));
                d.setName(rs.getString("name"));
                d.setAuthor(rs.getString("author"));
                d.setPublisher(rs.getString("publisher"));
                d.setPublishedYear(rs.getInt("publishedYear"));
                d.setGenre(rs.getString("genre"));
                d.setDescription(rs.getString("description"));

                DocumentItem5 item = new DocumentItem5();
                item.setId(rs.getInt("itemId"));
                item.setStatus(rs.getString("itemStatus"));
                item.setDocument(d);
                return item;
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Get document item failed: " + e.getMessage(), e);
        }
    }
}
