package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.Document5;

/** Module 1 - Reader finds document information. */
public class DocumentDAO5 extends DAO5 {

    public DocumentDAO5() {
        super();
    }

    /**
     * Searches documents whose given field contains the query (case-insensitive, LIKE %query%).
     *
     * @param searchType  which field to search: "name" (default), "author", "publisher", "genre", "type"
     * @param searchQuery the keyword typed by the reader
     * @return matching documents ordered by name; an empty array if the query is blank
     */
    public Document5[] searchDocuments(String searchType, String searchQuery) {
        if (searchQuery == null || searchQuery.trim().isEmpty()) {
            return new Document5[0];
        }
        // The column name cannot be a bind parameter, so it comes from a fixed whitelist.
        String column = columnFor(searchType);
        String sql = "SELECT * FROM tblDocument5 WHERE " + column + " LIKE ? ORDER BY name";

        ArrayList<Document5> result = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + escapeLike(searchQuery.trim()) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Document5 d = new Document5();
                    d.setCode(rs.getString("code"));
                    d.setType(rs.getString("type"));
                    d.setName(rs.getString("name"));
                    d.setAuthor(rs.getString("author"));
                    d.setPublisher(rs.getString("publisher"));
                    d.setPublishedYear(rs.getInt("publishedYear"));
                    d.setGenre(rs.getString("genre"));
                    d.setDescription(rs.getString("description"));
                    d.setImage(rs.getBytes("image"));
                    result.add(d);
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Search documents failed: " + e.getMessage(), e);
        }
        return result.toArray(new Document5[0]);
    }

    private static String columnFor(String searchType) {
        if (searchType == null) {
            return "name";
        }
        switch (searchType) {
            case "author":
                return "author";
            case "publisher":
                return "publisher";
            case "genre":
                return "genre";
            case "type":
                return "type";
            default:
                return "name";
        }
    }

    /** Makes %, _ and \ in the user's text match literally inside LIKE. */
    private static String escapeLike(String s) {
        return s.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
    }
}
