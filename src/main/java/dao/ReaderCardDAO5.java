package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Reader5;
import model.ReaderCard5;

/** Module 2 - Library staff lends documents: look up the reader card. */
public class ReaderCardDAO5 extends DAO5 {

    public ReaderCardDAO5() {
        super();
    }

    /**
     * Loads a reader card together with its owner (reader + user info).
     *
     * @param id the code scanned from / typed in for the card
     * @return the card, or null if no card has this id
     */
    public ReaderCard5 getReaderCard(int id) {
        String sql = "SELECT c.id AS cardId, c.image, c.issueDate, c.status, r.studentid, "
                + "u.id AS userId, u.username, u.name, u.birthday, u.address, u.email, u.phone, u.note "
                + "FROM tblReaderCard5 c "
                + "JOIN tblReader5 r ON r.tblUser5id = c.tblUser5id "
                + "JOIN tblUser5 u ON u.id = r.tblUser5id "
                + "WHERE c.id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Reader5 reader = new Reader5();
                reader.setId(rs.getInt("userId"));
                reader.setUsername(rs.getString("username"));
                reader.setName(rs.getString("name"));
                reader.setBirthday(rs.getDate("birthday"));
                reader.setAddress(rs.getString("address"));
                reader.setEmail(rs.getString("email"));
                reader.setPhone(rs.getString("phone"));
                reader.setNote(rs.getString("note"));
                reader.setStudentid(rs.getString("studentid"));

                ReaderCard5 card = new ReaderCard5();
                card.setId(rs.getInt("cardId"));
                card.setImage(rs.getBytes("image"));
                card.setIssueDate(rs.getDate("issueDate"));
                card.setStatus(rs.getString("status"));
                card.setReader(reader);
                return card;
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Get reader card failed: " + e.getMessage(), e);
        }
    }
}
