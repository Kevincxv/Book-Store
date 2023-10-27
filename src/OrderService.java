import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;

public class OrderService {

    public void placeOrder(int userID, int bookID, int quantity) {
        // Fetch the book price first
        String priceQuery = "SELECT price FROM Books WHERE bookID = ?";
        BigDecimal bookPrice = null;

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement priceStmt = conn.prepareStatement(priceQuery)) {
            priceStmt.setInt(1, bookID);
            try (ResultSet rs = priceStmt.executeQuery()) {
                if (rs.next()) {
                    bookPrice = rs.getBigDecimal("price");
                } else {
                    throw new SQLException("Book not found for given bookID");
                }
            }

            BigDecimal totalPrice = bookPrice.multiply(new BigDecimal(quantity));

            String insertQuery = "INSERT INTO Orders (userID, bookID, quantity, totalPrice) VALUES (?, ?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                insertStmt.setInt(1, userID);
                insertStmt.setInt(2, bookID);
                insertStmt.setInt(3, quantity);
                insertStmt.setBigDecimal(4, totalPrice);
                insertStmt.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}