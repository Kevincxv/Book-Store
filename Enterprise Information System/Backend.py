from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://username:password@localhost/bookstore'
app.config['SECRET_KEY'] = 'mysecret'
db = SQLAlchemy(app)

class User(db.Model):
    UserID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    Password = db.Column(db.String(255))
    Name = db.Column(db.String(255))
    Email = db.Column(db.String(255), unique=True)
    UserType = db.Column(db.Enum('Admin', 'Customer'), default='Customer')

class Book(db.Model):
    BookID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    Title = db.Column(db.String(255))
    Author = db.Column(db.String(255))
    Price = db.Column(db.Float)
    Stock = db.Column(db.Integer)

class Order(db.Model):
    OrderID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    UserID = db.Column(db.Integer, db.ForeignKey('user.UserID'))
    BookID = db.Column(db.Integer, db.ForeignKey('book.BookID'))
    Quantity = db.Column(db.Integer)

@app.route('/')
def index():
    books = Book.query.all()
    return render_template('index.html', books=books)

@app.route('/register', methods=['POST', 'GET'])
def register():
    if request.method == 'POST':
        hashed_pw = generate_password_hash(request.form['password'], method='sha256')
        new_user = User(Name=request.form['name'], Email=request.form['email'], Password=hashed_pw)
        db.session.add(new_user)
        db.session.commit()
        return redirect(url_for('login'))
    return render_template('register.html')

@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        user = User.query.filter_by(Email=request.form['email']).first()
        if user and check_password_hash(user.Password, request.form['password']):
            session['user_id'] = user.UserID
            return redirect(url_for('dashboard'))
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    if 'user_id' in session:
        user = User.query.filter_by(UserID=session['user_id']).first()
        return render_template('dashboard.html', user=user)
    return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('index'))

@app.route('/add_book', methods=['POST', 'GET'])
def add_book():
    if 'user_id' in session:
        if request.method == 'POST':
            new_book = Book(Title=request.form['title'], Author=request.form['author'], Price=request.form['price'], Stock=request.form['stock'])
            db.session.add(new_book)
            db.session.commit()
            return redirect(url_for('dashboard'))
        return render_template('add_book.html')
    return redirect(url_for('login'))

@app.route('/order_book/<int:book_id>', methods=['GET', 'POST'])
def order_book(book_id):
    if 'user_id' not in session:
        flash('Please login to order books', 'danger')
        return redirect(url_for('login'))

    book = Book.query.get(book_id)
    if not book:
        flash('Book not found!', 'danger')
        return redirect(url_for('index'))

    if request.method == 'POST':
        quantity = int(request.form['quantity'])
        if quantity > book.Stock:
            flash('Not enough stock available!', 'danger')
            return redirect(url_for('order_book', book_id=book_id))
        
        new_order = Order(UserID=session['user_id'], BookID=book_id, Quantity=quantity)
        book.Stock -= quantity
        db.session.add(new_order)
        db.session.commit()
        flash('Book ordered successfully!', 'success')
        return redirect(url_for('dashboard'))

    return render_template('order_book.html', book=book)

@app.route('/all_users')
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

@app.route('/profile', methods=['GET', 'POST'])
def profile():
    if 'user_id' not in session:
        flash('Please login to view profile', 'danger')
        return redirect(url_for('login'))

    user = User.query.get(session['user_id'])

    if request.method == 'POST':
        user.Name = request.form['name']
        user.Email = request.form['email']
        db.session.commit()
        flash('Profile updated successfully!', 'success')
        return redirect(url_for('profile'))

    return render_template('profile.html', user=user)

@app.route('/my_orders')
def my_orders():
    if 'user_id' not in session:
        flash('Please login to view your orders', 'danger')
        return redirect(url_for('login'))

    orders = Order.query.filter_by(UserID=session['user_id']).all()
    return render_template('my_orders.html', orders=orders)

@app.route('/admin/books')
def admin_books():
    if 'user_id' not in session or User.query.get(session['user_id']).UserType != 'Admin':
        flash('Only admins can manage books!', 'danger')
        return redirect(url_for('dashboard'))
    
    books = Book.query.all()
    return render_template('admin_books.html', books=books)

@app.route('/admin/edit_book/<int:book_id>', methods=['GET', 'POST'])
def edit_book(book_id):
    if 'user_id' not in session or User.query.get(session['user_id']).UserType != 'Admin':
        flash('Only admins can manage books!', 'danger')
        return redirect(url_for('dashboard'))

    book = Book.query.get(book_id)
    if request.method == 'POST':
        book.Title = request.form['title']
        book.Author = request.form['author']
        book.Price = float(request.form['price'])
        book.Stock = int(request.form['stock'])
        db.session.commit()
        flash('Book updated successfully!', 'success')
        return redirect(url_for('admin_books'))

    return render_template('edit_book.html', book=book)

@app.route('/admin/delete_book/<int:book_id>')
def delete_book(book_id):
    if 'user_id' not in session or User.query.get(session['user_id']).UserType != 'Admin':
        flash('Only admins can manage books!', 'danger')
        return redirect(url_for('dashboard'))

    book = Book.query.get(book_id)
    db.session.delete(book)
    db.session.commit()
    flash('Book deleted successfully!', 'success')
    return redirect(url_for('admin_books'))


if __name__ == '__main__':
    db.create_all()
    app.run(debug=True)
