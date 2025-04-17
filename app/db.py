# db.py

import pymysql
from datetime import datetime, timedelta
import random
from app import myemail
import bcrypt

class db:
    def __init__(self, usr, pwd):
        self.__conn = pymysql.connect(user=usr, passwd=pwd)
        self.__cursor = self.__conn.cursor(pymysql.cursors.DictCursor)
        self.__cursor.execute('use LMT')

    def insertReg(self, username, email, password):
        code = 0
        for i in range(1, 6):
            code *= 10
            code += random.randint(0, 10)

        try:
            myemail.verifemail(email, code)
        except Exception as e:
            raise Exception("Error: %s" % e)

        salt = bcrypt.gensalt()
        pwd = bcrypt.hashpw(password.encode('utf-8'), salt)
        
        timestamp = datetime.now() + timedelta(minutes=30)
        self.__cursor.execute('insert Register(username, email, password, salt, validTimeout, valcode) values(%s, %s, %s, %s, %s, %s)',
                              (username, email, pwd, salt, timestamp, code))
        self.__cursor.execute('commit')
        return code

    def insertUser(self, username, email, password, salt):
        self.__cursor.execute('delete from Register where username=%s', (username))
        self.__cursor.execute('insert User(username, email, password, salt) values(%s, %s, %s, %s)', (username, email, password, salt))
        self.__cursor.execute('commit')
        
    def validate(self, username, code):
        self.__cursor.execute('delete from Register where validTimeout < NOW()')
        self.__cursor.execute('select * from Register where username=%s and valcode=%s and validTimeout > NOW()', (username, code))
        res = self.__cursor.fetchone()
        if res is None:
            return False
        email = res['email']
        password = res['password']
        salt = res['salt']
        self.insertUser(username, email, password, salt)
        return True

    def availUsername(self, username):
        self.__cursor.execute('(select username from User where username=%s) union (select username from Register where username=%s)', (username, username))
        return self.__cursor.fetchone() is None

    def login(self, username, password):
        self.__cursor.execute('select password, salt from User where username=%s', (username))
        res = self.__cursor.fetchone()
        if res is None: return False;
        else: return bcrypt.checkpw(password.encode('utf-8'), res["password"])

    def isLibrarian(self, username):
        self.__cursor.execute('select * from User where username=%s and librarian', (username));
        return self.__cursor.fetchone() is not None;
    
    def getBooks(self, start=0, size=10):
        cmd = """
        SELECT BD.title, A.name as author
        FROM BookDescription as BD
             JOIN Book_Author AS BA ON BA.bISBN = BD.ISBN
             JOIN Author as A ON A.id = BA.authorId
        LIMIT %s,%s;
        """ % (start,start+size)
        self.__cursor.execute(cmd)
        return self.__cursor.fetchall();

    def getGenres(self):
        # we need a genere table please!!!
        cmd = "SELECT genreName FROM Genre";
        self.__cursor.execute(cmd)
        rows = list(self.__cursor.fetchall());
        return set([row['genreName'] for row in rows])
    
    def advancedSearch(self, title, author, genre, start=0, size=10):
        cmd = """
        SELECT DISTINCT BD.ISBN, BD.title, A.name as author
        FROM BookDescription as BD
             JOIN Book_Author AS BA ON BA.bISBN = BD.ISBN
             JOIN Author as A ON A.id = BA.authorId
             JOIN Book_Genre as BG ON BG.bISBN = BD.ISBN
             JOIN Genre as G ON BG.gId=G.id
        """
        conditions = []
        params = []
        param_names = ["BD.title", "A.name", "G.genreName"]
        for p,v in zip(param_names, [title, author, genre]):
            if v:
                conditions.append(p + " = %s")
                params.append(v)
        
        if conditions:
            cmd += "WHERE " + " AND ".join(conditions)
        cmd += "LIMIT %s, %s" % (start, start+size)
        
        self.__cursor.execute(cmd, params)
        return self.__cursor.fetchall()
    
    def bookDetails(self, isbn):
        cmd = """
        SELECT BD.title, BD.pubYear as year, BD.synopsis, A.name as author,
               GROUP_CONCAT(DISTINCT G.genreName) AS genres
        FROM BookDescription as BD
             JOIN Book_Author AS BA ON BA.bISBN = BD.ISBN
             JOIN Author as A ON A.id = BA.authorId
             JOIN Book_Genre as BG ON BG.bISBN = BD.ISBN
             JOIN Genre as G ON G.id=BG.gId
        WHERE BD.ISBN = %s
        GROUP BY BD.ISBN;
        """
        self.__cursor.execute(cmd, isbn)
        ret = self.__cursor.fetchone()
        ret['ISBN'] = isbn # cheeky putting isbn into the book w/out query
        ret['genres'] = ret['genres'].split(',')
        return ret

    def checkouts(self, isbn):
        cmd = 'select count(*) as n from Checkout join BookDescription on bISBN=ISBN where bISBN=%s and not returned'
        self.__cursor.execute(cmd, isbn)
        return int(self.__cursor.fetchone()['n'])
    
    def availableCopies(self,isbn):
        checkedout = self.checkouts(isbn)
        cmd = 'select totalStock from BookDescription where ISBN=%s'
        self.__cursor.execute(cmd, isbn)
        return int(self.__cursor.fetchone()['totalStock'])-checkedout
    
    def addCheckout(self, isbn, user):
        cmd= """
        INSERT INTO Checkout(bISBN, uId, dueDate)
        SELECT ISBN, id, %s from BookDescription join User
        WHERE ISBN=%s and username=%s
        """
        dueDate= date.today() + timedelta(days=7)
        self.__cursor.execute(cmd, (dueDate, isbn, user))

    def getCheckouts(self, user):
        cmd = """
        SELECT B.ISBN, B.title, GROUP_CONCAT(A.name) as authors, C.dueDate from
        (select * from Checkout where uId=(select id from User where username=%s))as C
        JOIN BookDescription as B on C.bISBN=B.ISBN
        JOIN Book_Author on ISBN=Book_Author.bISBN
        JOIN Author as A on authorId=A.id
        WHERE not returned GROUP BY B.ISBN
        """
        self.__cursor.execute(cmd, user)
        curr = self.__cursor.fetchone()
        ret = []
        while curr is not None:
            curr['authors'] = curr['authors'].split(',')
            ret.insert(curr)
            curr = self.__cursor.fetchone()
        return ret

    def checkoutReturned(self, user, ISBN):
        cmd = """
        update Checkout set returned=1
        where uId=(select id from User where username=%s) and
        bISBN=%s
        """
        self.__cursor.execute(cmd, (user, ISBN))

    def newBook(self, isbn, title, authors, pubyear, genres, synopsis, amount):
        cmd = """
        insert BookDescription(ISBN, title, pubYear, synopsis, totalStock)
        values(%s, %s, %s, %s, %s)
        """
        self.__cursor.execute(cmd, (isbn, title, pubyear, synopsis, amount))

        cmd = """
        insert Author(name) values(%s)
        """
        cmd1 = """
        insert into Book_Author(bISBN, authorId)
        select %s, id from Author where name=%s
        """
        for a in authors:
            try:
                self.__cursor.execute(cmd, a)
            except:
                pass
            self.__cursor.execute(cmd1, (isbn, a))

        cmd = """
        insert Genre(genreName) values(%s)
        """
        cmd1 = """
        insert into Book_Genre(bISBN, gId)
        select %s, id from Genre where genreName=%s
        """
        for g in genres:
            try:
                self.__cursor.execute(cmd, g)
            except:
                pass
            self.__cursor.execute(cmd1, (isbn, g))

    def changeStock(self, isbn, amount):
        cmd = """
        update BookDescription set totalStock=%s where ISBN=%s
        """
        self.__cursor.execute(cmd, (amount, isbn))

    def modifyBookTitle(self, isbn, title):
        cmd = """
        update BookDescription set title=%s where ISBN=%s
        """
        self.__cursor.execute(cmd, (title, isbn))

    def modifyBookYear(self, isbn, year):
        cmd = """
        update BookDescription set pubYear=%s where ISBN=%s
        """
        self.__cursor.execute(cmd, (year, isbn))

    def modifyBookSynopsis(self, isbn, synopsis):
        cmd = """
        update BookDescription set synopsis=%s where ISBN=%s
        """
        self.__cursor.execute(cmd, (synopsis, ISBN))
    
