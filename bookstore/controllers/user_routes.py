from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from werkzeug.security import generate_password_hash, check_password_hash
from models.user import User
from models.order import Order
from models import db

user = Blueprint('user', __name__)

@user.route('/register', methods=['POST', 'GET'])
def register():
    if request.method == 'POST':
        hashed_pw = generate_password_hash(request.form['password'], method='sha256')
        new_user = User(Name=request.form['name'], Email=request.form['email'], Password=hashed_pw)
        db.session.add(new_user)
        db.session.commit()
        flash('Registration successful. Please log in.', 'success')
        return redirect(url_for('user.login'))
    return render_template('register.html')

@user.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        user = User.query.filter_by(Email=request.form['email']).first()
        if user and check_password_hash(user.Password, request.form['password']):
            session['user_id'] = user.UserID
            flash('Logged in successfully!', 'success')
            return redirect(url_for('dashboard'))  # You might need to adjust the endpoint if 'dashboard' is in another blueprint
        flash('Invalid email or password. Please try again.', 'danger')
    return render_template('login.html')

@user.route('/logout')
def logout():
    session.pop('user_id', None)
    flash('Logged out successfully.', 'success')
    return redirect(url_for('main.index'))  # Assuming 'index' is in 'main_routes.py'

@user.route('/profile', methods=['GET', 'POST'])
def profile():
    if 'user_id' not in session:
        flash('Please login to view profile', 'danger')
        return redirect(url_for('user.login'))

    user = User.query.get(session['user_id'])

    if request.method == 'POST':
        user.Name = request.form['name']
        user.Email = request.form['email']
        db.session.commit()
        flash('Profile updated successfully!', 'success')
        return redirect(url_for('user.profile'))

    return render_template('profile.html', user=user)

@user.route('/my_orders')
def my_orders():
    if 'user_id' not in session:
        flash('Please login to view your orders', 'danger')
        return redirect(url_for('user.login'))

    orders = Order.query.filter_by(UserID=session['user_id']).all()
    return render_template('my_orders.html', orders=orders)
