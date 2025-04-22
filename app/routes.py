# file : routes.py

from flask import render_template, request, session, redirect, url_for, flash
from app import app
from app.db import db
from apscheduler.schedulers.background import BackgroundScheduler
import atexit

from datetime import datetime, timedelta, date


database = db('root', 'root') #CHANGE TO USER/PASSWORD OF MYSQL

errors = {"emptyField" : "You must enter a %s." }

dailyUpdates = BackgroundScheduler()
dailyUpdates.add_job(func=database.updateHolds, trigger="interval", hours=24)
dailyUpdates.start()

atexit.register(lambda: dailyUpdates.shutdown())

@app.route('/')
@app.route('/index')
def index():
    if session.get('LoggedIn',False):
        return render_template('index.html', user=session['User'],
                               librarian=database.isLibrarian(session['User']))
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
    return render_template('book.html', book=book, available=avail,
                           librarian=database.isLibrarian(session['User']))

@app.route('/checkout/<isbn>')
def checkout(isbn):
    if not session.get('LoggedIn', False): return redirect(url_for('login'))
    if database.numCheckouts(session['User']) > 2:
        return "You've reached the checkout limit"
    if database.isCheckedOut(isbn, session['User']):
        return "You already have this book"
    avail = database.availableCopies(isbn)
    if avail < 1:
        database.addWaitlist(isbn, session['User'])
        return "You've been added to the waitlist!"
    dueDate = database.addCheckout(isbn, session['User'])
    book = database.bookDetails(isbn)
    return render_template('pendingCheckout.html', book=book, dueDate=dueDate)

"""
    book = database.bookDetails(isbn)
    today = date.today()
    due = today + timedelta(days=7)
    
    return render_template('checkout.html', book=book, date=today, due=due,
                           renews=2, renew_len="7 Days")
"""

@app.route('/newBook', methods = ["GET", "POST"])
def newBook():
    if not session.get('LoggedIn', False): return redirect(url_for('login'))
    if not database.isLibrarian(session['User']):
        return redirect(url_for('index'))

    if request.method == "POST":
        authors = request.form.get('authors').split(',')
        genres = request.form.get('genres', None)
        if genres is not None:
            genres = genres.split(',')
        try:
            database.newBook(request.form.get('ISBN'),
                             request.form.get('title'),
                             authors, request.form.get('series', None),
                             request.form.get('pubYear'), genres,
                             request.form.get('synopsis'),
                             request.form.get('amount'))
            flash('New book added', 'success')
        except:
            flash('Could not add new book(does it already exist?)', 'error')
    return render_template('newBook.html')

@app.route('/editBook/<isbn>', methods = ["GET", "POST"])
def editBook(isbn):
    if not session.get('LoggedIn', False): return redirect(url_for('login'))
    if not database.isLibrarian(session['User']):
        return redirect(url_for('index'))
    
    book = database.bookDetails(isbn)
    
    if request.method == "POST":
        title = request.form.get('title', None)
        if title is not None and title != '':
            database.modifyBookTitle(isbn, title)
        series = request.form.get('series', None)
        if series is not None and series != '':
            database.changeBookSeries(isbn, series)
        pubYear = request.form.get('pubYear', None)
        if pubYear is not None and isinstance(pubYear, int):
            database.modifyBookYear(isbn, pubYear)
        synopsis = request.form.get('synopsis', None)
        if synopsis is not None and synopsis != '':
            database.modifyBookSynopsis(isbn, synopsis)
        amount = request.form.get('amount', None)
        if amount is not None and isinstance(amount, int):
            database.changeStock(isbn, amount)
        authors = request.form.get('authors', None)
        if authors is not None and authors != '':
            authors = authors.split(',')
            database.changeBookAuthors(isbn, authors)
        genres = request.form.get('genres', None)
        if genres is not None and genres != '':
            genres = genres.split(',')
            database.changeBookGenres(isbn, genres)
        return redirect(url_for('book', isbn=isbn))

    return render_template('editBook.html', book=book)

@app.route('/waitlist/<isbn>')
def waitlist(isbn):
    return ""

@app.route('/friends', methods=["POST", "GET"])
def friends():
    if request.method == "POST":
        other = request.form.get('friend', None)
        if other and other == session['User']:
            flash('You cannot add yourself as a friend', "Error")
        elif other:
            status = database.addFriend(session['User'], other)
            if status == "DNE":
                flash("User '%s' does not exist." % other, "Error")
            elif status == "Friends":
                flash("You are already friends with User '%s'." % other,
                      "Error")
            elif status == "Requested":
                flash("You have already friend requested User '%s'." \
                      % other, "Error")
            elif status == "Sent":
                flash("Sent User '%s' a friend request." % other,"Update")
            elif status == "Added":
                flash("Added User '%s' as a friend." % other, "Update")
            
    fs = database.friends(session['User'])
    rs = database.friendRequests(session['User'])
    return render_template('friends.html',friends=fs, friendRequests=rs)

@app.route('/unfriend/<name>', methods=['POST'])
def unfriend(name):
    status = database.removeFriendship(session['User'],name)
    if status == "DNE": flash("User '%s' does not exist." % name, "Error")
    elif status == "Not Friends":
        flash("You are not friends with User '%s.'" % name, "Error")
    else:
        flash("Removed User '%s' as a friend." % name, "Update")
    return redirect(url_for('friends'))

@app.route('/history/<name>')
def viewHistory(name):
    return "WIP"

@app.route('/updateFR/<name>/<accepted>', methods=['POST'])
def updateFR(name, accepted):
    status = database.userHandleFR(session['User'], name, accepted=='Y')
    if status == "DNE": flash("User '%s' does not exist." % name, "Error")
    else: flash("%s User '%s'." % (status, name), "Update")
    return redirect(url_for('friends'))
