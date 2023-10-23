import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OrderService {

    public void placeOrder(int userID, int bookID, int quantity) {
        String query = "INSERT INTO Orders (userID, bookID, quantity, totalPrice) VALUES (?, ?, ?, calculateTotalPrice(?))";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userID);
            stmt.setInt(2, bookID);
            stmt.setInt(3, quantity);
            stmt.setInt(4, bookID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
