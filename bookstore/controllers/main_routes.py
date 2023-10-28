from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from bookstore.models import db
from bookstore.models.user import User
from bookstore.models.book import Book
from bookstore.models.order import Order
from werkzeug.security import check_password_hash, generate_password_hash

main = Blueprint('main', __name__)

@main.route('/')
def index():
    books = Book.query.all()
    return render_template('index.html', books=books)

@main.route('/all_users')
def all_users():
    if 'user_id' not in session:
        flash('Please login to view users', 'danger')
        return redirect(url_for('login'))

    user = User.query.get(session['user_id'])
    if user.UserType != 'Admin':
        flash('Only admins can view all users!', 'danger')
        return redirect(url_for('dashboard'))

    users = User.query.all()
    return render_template('all_users.html', users=users)

@main.route('/dashboard')
def dashboard():
    if 'user_id' in session:
        user = User.query.filter_by(UserID=session['user_id']).first()
        return render_template('dashboard.html', user=user)
    return redirect(url_for('login'))

# You can add other non-user and non-admin specific routes here
