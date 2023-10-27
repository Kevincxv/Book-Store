import java.util.Properties;
import java.io.InputStream;

public class DatabaseConnection {

    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;

    static {
        Properties props = new Properties();
        try (InputStream is = DatabaseConnection.class.getResourceAsStream("/config.properties")) {
            props.load(is);
            URL = props.getProperty("database.url");
            USER = props.getProperty("database.user");
            PASSWORD = props.getProperty("database.password");
        } catch (IOException e) {
            throw new ExceptionInInitializerError("Failed to read from properties file.");
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

public String getUserRole(String username) {
    String query = "SELECT role FROM Users WHERE username = ?";
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            return rs.getString("role");
        }
        return null;
    } catch (SQLException e) {
        throw new RuntimeException("Error fetching user role", e);
    }
}
