from flask import Flask, render_template, request, redirect, url_for, flash, session
from werkzeug.security import check_password_hash

# Working Before Combination

from models import db
from config import Config

# Importing Blueprints
from controllers.main_routes import main
from controllers.user_routes import user
from controllers.admin_routes import admin
from controllers.main_routes import main

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)

    # Register blueprints
    app.register_blueprint(user, url_prefix='/user')
    app.register_blueprint(admin, url_prefix='/admin')
    app.register_blueprint(main)

    return app

app = create_app()

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
