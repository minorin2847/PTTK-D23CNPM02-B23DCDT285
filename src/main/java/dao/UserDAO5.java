package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Employee5;
import model.Librarian5;
import model.Reader5;
import model.User5;

/** Login (view/user): needed so ReaderMainFrm5 / LibrarianMainFrm5 know who is logged in. */
public class UserDAO5 extends DAO5 {

    public UserDAO5() {
        super();
    }

    /**
     * Checks username/password and returns the account with its concrete type.
     *
     * @return a {@link Reader5}, a {@link Librarian5}, another {@link Employee5},
     *         or null if the credentials are wrong
     */
    public User5 checkLogin(String username, String password) {
        String sql = "SELECT u.*, r.studentid, e.role FROM tblUser5 u "
                + "LEFT JOIN tblReader5 r ON r.tblUser5id = u.id "
                + "LEFT JOIN tblEmployee5 e ON e.tblUser5id = u.id "
                + "WHERE u.username = ? AND u.password = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                User5 user;
                String studentid = rs.getString("studentid");
                String role = rs.getString("role");
                if (studentid != null) {
                    Reader5 reader = new Reader5();
                    reader.setStudentid(studentid);
                    user = reader;
                } else if (Librarian5.ROLE.equalsIgnoreCase(role)) {
                    user = new Librarian5();
                } else if (role != null) {
                    Employee5 employee = new Employee5();
                    employee.setRole(role);
                    user = employee;
                } else {
                    user = new User5();
                }
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setName(rs.getString("name"));
                user.setBirthday(rs.getDate("birthday"));
                user.setAddress(rs.getString("address"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setNote(rs.getString("note"));
                return user;
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Login failed: " + e.getMessage(), e);
        }
    }
}
