from flask import Blueprint

# Create the blueprints
main = Blueprint('main', __name__)
user = Blueprint('user', __name__)
admin = Blueprint('admin', __name__)

# Import the routes to ensure they get registered with the application
from . import main_routes, user_routes, admin_routes
