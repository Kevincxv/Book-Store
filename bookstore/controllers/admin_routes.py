from flask import Blueprint, render_template, request, flash, redirect, url_for
from bookstore.models.book import Book
from bookstore.models import db

admin = Blueprint('admin', __name__)

@admin.route('/admin/books')
def admin_books():
    books = Book.query.all()
    return render_template('admin_books.html', books=books)

@admin.route('/admin/edit_book/<int:book_id>', methods=['GET', 'POST'])
def edit_book(book_id):
    book = Book.query.get(book_id)
    if not book:
        flash('Book not found!', 'danger')
        return redirect(url_for('admin.admin_books'))

    if request.method == 'POST':
        book.Title = request.form['title']
        book.Author = request.form['author']
        book.Price = float(request.form['price'])
        book.Stock = int(request.form['stock'])
        db.session.commit()
        flash('Book updated successfully!', 'success')
        return redirect(url_for('admin.admin_books'))

    return render_template('edit_book.html', book=book)

@admin.route('/admin/delete_book/<int:book_id>')
def delete_book(book_id):
    book = Book.query.get(book_id)
    if not book:
        flash('Book not found!', 'danger')
        return redirect(url_for('admin.admin_books'))

    db.session.delete(book)
    db.session.commit()
    flash('Book deleted successfully!', 'success')
    return redirect(url_for('admin.admin_books'))

# Add other admin-related routes as necessary
