# file : __init__.py
from flask import Flask, session
app = Flask(__name__)
app.secret_key = 'secret secret'
from app import routes
