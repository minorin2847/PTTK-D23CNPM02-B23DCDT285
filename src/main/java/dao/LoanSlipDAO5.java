package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import model.DocumentItem5;
import model.LoanDocumentItem5;
import model.LoanSlip5;

/** Module 2 - Library staff lends documents: save the finished loan slip. */
public class LoanSlipDAO5 extends DAO5 {

    public LoanSlipDAO5() {
        super();
    }

    /**
     * Saves a loan slip in one transaction:
     * <ol>
     *   <li>insert the slip into tblLoanSlip5 and read back its generated id,</li>
     *   <li>for each line, mark the copy as borrowed - only if it is still available -
     *       and insert the line into tblLoanDocumentItem5.</li>
     * </ol>
     * If any copy was borrowed by someone else in the meantime, or any statement fails,
     * everything is rolled back and nothing is saved.
     *
     * @param slip the slip built on LendDocumentFrm5; on success its id is filled in
     * @return true if saved, false if the slip is empty or a copy is no longer available
     */
    public boolean saveLoanSlip(LoanSlip5 slip) {
        if (slip == null || slip.getReader() == null || slip.getDocuments().isEmpty()) {
            return false;
        }
        String insertSlip = "INSERT INTO tblLoanSlip5 (loanDate, tblReaderCard5id) VALUES (?, ?)";
        String markBorrowed = "UPDATE tblDocumentItem5 SET status = ? WHERE id = ? AND status = ?";
        String insertLine = "INSERT INTO tblLoanDocumentItem5 "
                + "(dueDate, returnDate, status, tblLoanSlip5id, tblDocumentItem5id) VALUES (?, NULL, ?, ?, ?)";

        try {
            con.setAutoCommit(false);

            int slipId;
            try (PreparedStatement ps = con.prepareStatement(insertSlip, Statement.RETURN_GENERATED_KEYS)) {
                ps.setDate(1, new java.sql.Date(slip.getLoanDate().getTime()));
                ps.setInt(2, slip.getReader().getId());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    keys.next();
                    slipId = keys.getInt(1);
                }
            }

            try (PreparedStatement update = con.prepareStatement(markBorrowed);
                 PreparedStatement insert = con.prepareStatement(insertLine)) {
                for (LoanDocumentItem5 line : slip.getDocuments()) {
                    update.setString(1, DocumentItem5.STATUS_BORROWED);
                    update.setInt(2, line.getDocument().getId());
                    update.setString(3, DocumentItem5.STATUS_AVAILABLE);
                    if (update.executeUpdate() != 1) {
                        // the copy is no longer available
                        con.rollback();
                        return false;
                    }
                    insert.setDate(1, new java.sql.Date(line.getDueDate().getTime()));
                    insert.setString(2, LoanDocumentItem5.STATUS_BORROWING);
                    insert.setInt(3, slipId);
                    insert.setInt(4, line.getDocument().getId());
                    insert.executeUpdate();
                }
            }

            con.commit();
            slip.setId(slipId);
            for (LoanDocumentItem5 line : slip.getDocuments()) {
                line.setSlip(slip);
                line.setStatus(LoanDocumentItem5.STATUS_BORROWING);
                line.getDocument().setStatus(DocumentItem5.STATUS_BORROWED);
            }
            return true;
        } catch (SQLException e) {
            try {
                con.rollback();
            } catch (SQLException ignored) {
                // the original error is the one worth reporting
            }
            throw new IllegalStateException("Save loan slip failed: " + e.getMessage(), e);
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (SQLException ignored) {
                // connection is closed right after anyway
            }
        }
    }
}
