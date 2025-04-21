# db.py

import pymysql
from datetime import datetime, timedelta
import random
from app import myemail
import bcrypt

class db:
    def __init__(self, usr, pwd):
        print("INITIALIZING!!!")
        self.__conn = pymysql.connect(user=usr, passwd=pwd)
        self.__cursor = self.__conn.cursor(pymysql.cursors.DictCursor)
        self.__cursor.execute('use LMT')

    def __del__(self):
        self.__conn.commit()
        self.__cursor.close()
        self.__conn.close()
    
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
        self.__conn.commit()
        return code

    def insertUser(self, username, email, password, salt):
        self.__cursor.execute('delete from Register where username=%s', (username))
        self.__cursor.execute('insert User(username, email, password, salt) values(%s, %s, %s, %s)', (username, email, password, salt))
        self.__conn.commit()
        
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

    def numTotalCheckouts(self, isbn):
        self.__conn.commit()
        cmd = 'select count(*) as n from Checkout where bISBN=%s'
        self.__cursor.execute(cmd, isbn)    
        return self.__cursor.fetchone()['n']

    def numHolds(self, isbn):
        cmd = """
        SELECT count(*) as n from Hold where bISBN=%s
        """
        self.__cursor.execute(cmd, (isbn,))
        return self.__cursor.fetchone()['n']
    
    def availableCopies(self,isbn):
        unavailable = self.numTotalCheckouts(isbn) + self.numHolds(isbn)
        cmd = 'select totalStock-%s as n from BookDescription where ISBN=%s'
        self.__cursor.execute(cmd, (unavailable,isbn))
        return self.__cursor.fetchone()['n']
    
    def addCheckout(self, isbn, user):
        if(isinstance(user, str)):
            cmd0 = """
            delete from Hold where bISBN=%s and
            uId=(select id from User where username=%s)
            """
            cmd= """
            INSERT INTO Checkout(bISBN, uId, dueDate)
            SELECT ISBN, id, %s from BookDescription join User
            WHERE ISBN=%s and username=%s
            """
        else:
            cmd0 = """
            delete from Hold where bISBN=%s and uId=%s
            """
            cmd = """
            insert Checkout(dueDate, bISBN, uId) values(%s, %s, %s)
            """
        dueDate= datetime.date(datetime.today() + timedelta(days=7))
        self.__cursor.execute(cmd0, (isbn, user))
        self.__cursor.execute(cmd, (dueDate, isbn, user))
        self.__conn.commit()
        return dueDate
        
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

    def numCheckouts(self, user):
        if isinstance(user, str):
            cmd = """
            select count(*) as n from Checkout
            where uId=(select id from User where username=%s)
            and not returned
            """
        else:
            cmd = """
            select count(*) as n from Checkout where uId=%s and not returned
            """
        self.__cursor.execute(cmd, user)
        return int(self.__cursor.fetchone()['n'])

    def isCheckedOut(self, ISBN, user):
        if isinstance(user, str):
            cmd = """
            select * from Checkout where bISBN=%s and
            uId=(select id from User where username=%s) and not returned
            """
        else:
            cmd = """
            select * from Checkout where bISBN=%s and uid=%s and not returned
            """
        self.__cursor.execute(cmd, (ISBN, user))
        return self.__cursor.fetchone() is not None
    
    def checkoutReturned(self, user, ISBN):
        cmd = """
        update Checkout set returned=1
        where uId=(select id from User where username=%s) and
        bISBN=%s
        """
        self.__cursor.execute(cmd, (user, ISBN))
        cmd = """
        select * from Waitlist where bISBN=%s order by submit asc limit 1
        """
        self.__cursor.execute(cmd, (ISBN))
        res = self.__cursor.fetchone()
        if res is not None:
            cmd = """
            delete from Waitlist where id=%s
            """
            self.__cursor.execute(cmd, res['id'])
            self.addHold(int(res['bISBN']), int(res['uId']))

    def addHold(self, isbn, uId):
        cmd = """
        insert Hold(bISBN, uId, end) values(%s, %s, %s)
        """
        end = datetime.today() + timedelta(days=2)
        self.__cursor.execute(cmd, (isbn, uId, end))
        self.__conn.commit()

    def removeHold(self, isbn, uId):
        cmd = """
        delete from Hold where bISBN=%s and uId=%s
        """
        self.__cursor.execute(cmd, (isbn, uId))
        self.__conn.commit()
        
    def holdToCheckout(self, isbn, uId):
        self.removeHold(isbn, uId)
        self.addCheckout(isbn, uId)

    def updateHolds(self):
        cmd = """
        select * from Hold where end < NOW()
        """
        self.__cursor.execute(cmd)
        noResponse = self.__cursor.fetchall()

        cmd = """
        delete from Hold where end < NOW()
        """
        self.__cursor.execute(cmd)
        self.__conn.commit()

        date = datetime.date(datetime.today() + datetime.timedelta(days=2))
        for hold in noResponse:
            cmd = """
            select * from Waitlist join User on uId=User.id
            join BookDescription on bISBN=ISBN
            where bISBN=%s order by submit asc limit 1
            """
            self.__cursor.execute(cmd, int(hold['bISBN']))
            res = self.__cursor.fetchone()
            if res is not None:
                self.deleteWaitlist(res['bISBN'], res['uId'])
                self.addHold(res['bISBN'], res['uId'])
                myemail.verifemail(res['email'], {'User':res['username'],
                                                  'Book':res['title'],
                                                  'Date':date}, 1)
        self.__conn.commit()

    def getUserHolds(self, user):
        if isinstance(user, int):
            cmd = """
            select * from Hold join BookDescription on bISBN=ISBN where uId=%s
            """
        else:
            cmd = """
            select * from Hold join BookDescription on bISBN=ISBN where
            uId=(select id from User where username=%s)
            """
        self.__cursor.execute(cmd, user)
        ret = []
        curr = self.__cursor.fetchone()
        while curr is not None:
            ret.insert(curr)
            curr = self.__cursor.fetchone()
        return ret
    
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
        self.__conn.commit()

    def changeStock(self, isbn, amount):
        cmd = """
        update BookDescription set totalStock=%s where ISBN=%s
        """
        self.__cursor.execute(cmd, (amount, isbn))
        self.__conn.commit()
        
    def modifyBookTitle(self, isbn, title):
        cmd = """
        update BookDescription set title=%s where ISBN=%s
        """
        self.__cursor.execute(cmd, (title, isbn))
        self.__conn.commit()
        
    def modifyBookYear(self, isbn, year):
        cmd = """
        update BookDescription set pubYear=%s where ISBN=%s
        """
        self.__cursor.execute(cmd, (year, isbn))
        self.__conn.commit()
        
    def modifyBookSynopsis(self, isbn, synopsis):
        cmd = """
        update BookDescription set synopsis=%s where ISBN=%s
        """
        self.__cursor.execute(cmd, (synopsis, ISBN))
        self.__conn.commit()
        
    def addWaitlist(self, isbn, user):
        cmd = """
        insert into Waitlist(bISBN, uId)
        select %s, id from User where username=%s
        """
        self.__cursor.execute(cmd, (isbn, user))
        self.__conn.commit()
        
    def deleteWaitlist(self, isbn, user):
        if isinstance(user, int):
            cmd = """
            delete from Waitlist where bISBN=%s and
            uId=(select id from User where username=%s)
            """
        else:
            cmd = """
            delete from Waitlist where bISBN=%s and uId=%s
            """
        self.__cursor.execute(cmd, (isbn, user))
        self.__conn.commit()
