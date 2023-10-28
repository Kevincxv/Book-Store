from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from werkzeug.security import check_password_hash
from bookstore.models import db
from bookstore.models.user import User
from bookstore.models.book import Book
from bookstore.models.order import Order

book_routes = Blueprint('book', __name__)

@book_routes.route('/add_book', methods=['POST', 'GET'])
def add_book():
    if 'user_id' in session:
        if request.method == 'POST':
            new_book = Book(
                Title=request.form['title'], 
                Author=request.form['author'], 
                Price=request.form['price'], 
                Stock=request.form['stock']
            )
            db.session.add(new_book)
            db.session.commit()
            return redirect(url_for('book.dashboard'))
        return render_template('add_book.html')
    return redirect(url_for('user.login'))

@book_routes.route('/order_book/<int:book_id>', methods=['GET', 'POST'])
def order_book(book_id):
    if 'user_id' not in session:
        flash('Please login to order books', 'danger')
        return redirect(url_for('user.login'))

    book = Book.query.get(book_id)
    if not book:
        flash('Book not found!', 'danger')
        return redirect(url_for('book.index'))

    if request.method == 'POST':
        quantity = int(request.form['quantity'])
        if quantity > book.Stock:
            flash('Not enough stock available!', 'danger')
            return redirect(url_for('book.order_book', book_id=book_id))
        
        new_order = Order(UserID=session['user_id'], BookID=book_id, Quantity=quantity)
        book.Stock -= quantity
        db.session.add(new_order)
        db.session.commit()
        flash('Book ordered successfully!', 'success')
        return redirect(url_for('book.dashboard'))

    return render_template('order_book.html', book=book)
