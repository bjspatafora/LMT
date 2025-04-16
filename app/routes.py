# file : routes.py
from flask import render_template, request, session, redirect, url_for, flash
from app import app
from app.db import db

database = db('root', 'root') #CHANGE TO USER/PASSWORD OF MYSQL

errors = {"emptyField" : "You must enter a %s." }

@app.route('/')
@app.route('/index')
def index():
    #if session.get('LoggedIn',None) and database.isLibrarian(session['User']):
    #    return render_template('LibrarianIndex.html',user=session['User'])
    #el
    if session.get('LoggedIn',False):
        return render_template('index.html', user=session['User'])
    else:
        return redirect(url_for('login'))

@app.route('/login', methods = ["GET", "POST"])
def login():
    if request.method == "POST":
        form = dict(request.form)
        empty = [key for key,value in form.items() if value.strip() == ""]
        if len(empty) != 0:
            flash(errors["emptyField"] % ', '.join(empty), "Error")
        elif database.login(form['username'],form['password']):
            session['User'] = form['username']
            session['LoggedIn'] = True
            return redirect(url_for('index'))
        else:
            flash("Invalid login information, please try again.", "Error")
            
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

@app.route('/register', methods = ["GET", "POST"])
def register():
    if request.method == "POST":
        form = dict(request.form)
        empty = [key for key,value in form.items() if value.strip() == ""]
        if len(empty) != 0:
            flash(errors["emptyField"] % ', '.join(empty), "Error")
        elif form["password"] != form["password2"]:
            flash("Passwords do not match, please try again.", "Error")
        elif not database.availUsername(form["username"]):
            flash("Username is already taken, please choose another and " \
                  "try again.", "Error")
        else:
            session['User'] = form["username"]
            code = database.insertReg(form["username"], form["email"],
                                      form["password"])
            if not code:
                flash("Could not send validation email, please try again.",
                      "Error")
            else:
                return redirect(url_for('validate'))
    
    return render_template('register.html')

@app.route('/validate', methods = ["GET", "POST"])
def validate():
    if request.method == "POST":
        code = request.form.get("valcode", None)
        if not code:
            session['User'] = None
            return redirect(url_for('index'))
        elif database.validate(session['User'], code): #codes match
            return redirect(url_for('index'))
        else:
            flash("Incorrect code, please try again.", "Error")
    
    return render_template('validate.html')

@app.route('/browse', methods = ["GET"])
def browse():
    if not session.get('LoggedIn', False): return redirect(url_for('login'))
    form = dict(request.args)
    title = form.get('title','')
    author = form.get('author','')
    genres = form.get('genres')
    
    books = database.advancedSearch(title,author,genres)
        
    return render_template('browse.html',books=books,
                           genres=database.getGenres())

@app.route('/book/<isbn>')
def book(isbn):
    if not session.get('LoggedIn', False): return redirect(url_for('login'))
    isbn = int(isbn)
    book = database.bookDetails(isbn)
    avail = database.availableCopies(isbn)
    return render_template('book.html', book=book, available=avail)

@app.route('/checkout/<isbn>')
def checkout(isbn):
    if not session.get('LoggedIn', False): return redirect(url_for('login'))
    return "WIP"

@app.route('/inventory')
def inventory():
    if not database.isLibrarian(session['User']):
        return redirect(url_for('index'))

    return render_template('inventory.html')

@app.route('/newBook')
def newBook():
    if not database.isLibrarian(session['User']):
        return redirect(url_for('index'))
    return render_template('newBook.html')
