# file : routes.py
from flask import render_template, request, session, redirect, url_for
from app import app
from db import db

database = db('root', 'root') #CHANGE TO USER/PASSWORD OF MYSQL

@app.route('/')
@app.route('/index')
def index():
    if session.get('LoggedIn', None):
        return render_template('index.html', user=session['User'])
    else:
        return redirect(url_for('login'))

@app.route('/login')
def login():
    return render_template('login.html', error='')

@app.route('/loginErr')
def loginErr():
    return render_template('login.html', error='Invalid username/password')

@app.route('/loginRequest', methods = ["POST"])
def loginRequest():
    username = request.form.get("username", None)
    password = request.form.get("password", None)
    
    if database.login(username, password): # valid login Information
        session['User'] = username
        session['LoggedIn'] = 1
        return redirect(url_for('index'))
    else:
        return redirect(url_for('loginErr'))

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))

@app.route('/register')
def register():
    return render_template('register.html', error='')

@app.route('/registerNMPass')
def registerNMPass():
    return render_template('register.html', error='Passwords did not match')

@app.route('/registerUsedUser')
def registerUsedUser():
    return render_template('register.html', error='Username already taken')

@app.route('/registerEError')
def registerEError():
    return render_template('register.html', error='Could not send email')

@app.route('/registerRequest', methods = ["POST"])
def registerRequest():
    username = request.form.get("username", None)
    email = request.form.get("email", None)
    password = request.form.get("password", None)
    password2 = request.form.get("password2", None)

    if password != password2:
        return redirect(url_for('registerNMPass'))
    elif database.availUsername(username):
        session['User'] = username
        code = database.insertReg(username, email, password)
        if code is None:
            return redirect(url_for('registerEError'))
        else:
            return redirect(url_for('validate'))
    else:
        return redirect(url_for('registerUsedUser'))

@app.route('/validate')
def validate():
    return render_template('validate.html')

@app.route('/validateRequest', methods = ["POST"])
def validateRequest():
    code = request.form.get("valcode", None)

    if code is None:
        session['User'] = None
        return redirect(url_for('index'))
    elif database.validate(session['User'], code): #codes match
        return redirect(url_for('index'))
    else:
        return render_template('validateRetry.html')
