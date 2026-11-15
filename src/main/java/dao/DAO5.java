package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Base class of every DAO (see the detail class diagrams): it owns the JDBC connection {@code con}.
 *
 * Each DAO instance opens its own connection in the constructor and releases it in {@link #close()},
 * so the JSP views use DAOs with try-with-resources:
 * <pre>try (DocumentDAO5 dao = new DocumentDAO5()) { ... }</pre>
 *
 * Connection settings can be overridden with the environment variables
 * LIBMAN_DB_URL, LIBMAN_DB_USER and LIBMAN_DB_PASSWORD.
 */
public class DAO5 implements AutoCloseable {
    private static final String DEFAULT_URL =
            "jdbc:mysql://localhost:3306/libman?useSSL=false&allowPublicKeyRetrieval=true"
            + "&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8";

    protected Connection con;

    public DAO5() {
        String url = env("LIBMAN_DB_URL", DEFAULT_URL);
        String user = env("LIBMAN_DB_USER", "root");
        String password = env("LIBMAN_DB_PASSWORD", "root");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException e) {
            throw new IllegalStateException("Cannot connect to the database: " + e.getMessage(), e);
        }
    }

    private static String env(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value == null || value.isEmpty()) ? defaultValue : value;
    }

    @Override
    public void close() {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException ignored) {
                // nothing useful to do when closing fails
            }
        }
    }
}
