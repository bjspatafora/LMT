# file : routes.py
from flask import render_template, request, session, redirect, url_for
from app import app

@app.route('/')
@app.route('/index')
def index():
    if session.get('User', None):
        return render_template('index.html', user=session['User'])
    else:
        return redirect(url_for('login'))

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/loginRequest', methods = ["POST"])
def loginRequest():
    username = request.form.get("username", None)
    password = request.form.get("password", None)
    
    if True: # valid login Information
        session['User'] = username
        return redirect(url_for('index'))

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))

@app.route('/register')
def register():
    return render_template('register.html')

