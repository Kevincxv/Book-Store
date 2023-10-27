import java.awt.print.Book;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import your.package.name.Book;


public class BookService {

    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String query = "SELECT * FROM Books";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Book book = new Book(rs.getInt("bookID"), rs.getString("title"), rs.getString("author"), rs.getBigDecimal("price"), rs.getInt("stock"));
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
   public class Book {
        private int bookID;
        private String title;
        private String author;
        private BigDecimal price;
        private int stock;

        public Book(int bookID, String title, String author, BigDecimal price, int stock) {
            this.bookID = bookID;
            this.title = title;
            this.author = author;
            this.price = price;
            this.stock = stock;
        }
    }
}
