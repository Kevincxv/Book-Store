from flask import Flask, render_template, request, redirect, url_for, flash, session
from werkzeug.security import check_password_hash

from bookstore.models import db
from bookstore.config import Config

# Importing Blueprints
from bookstore.controllers.main_routes import main
from bookstore.controllers.user_routes import user
from bookstore.controllers.admin_routes import admin

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)

    # Register blueprints
    app.register_blueprint(main)
    app.register_blueprint(user, url_prefix='/user')
    app.register_blueprint(admin, url_prefix='/admin')

    return app

app = create_app()

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
