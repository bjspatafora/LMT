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
        cmd = "SELECT genre FROM BookGenre";
        self.__cursor.execute(cmd)
        rows = list(self.__cursor.fetchall());
        return set([row['genre'] for row in rows])
    
    def advancedSearch(self, title, author, genre, start=0, size=10):
        cmd = """
        SELECT DISTINCT BD.ISBN, BD.title, A.name as author
        FROM BookDescription as BD
             JOIN Book_Author AS BA ON BA.bISBN = BD.ISBN
             JOIN Author as A ON A.id = BA.authorId
             JOIN BookGenre as BG ON BG.bISBN = BD.ISBN 
        """
        conditions = []
        params = []
        param_names = ["BD.title", "A.name", "BG.genre"]
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
               GROUP_CONCAT(DISTINCT BG.genre) AS genres
        FROM BookDescription as BD
             JOIN Book_Author AS BA ON BA.bISBN = BD.ISBN
             JOIN Author as A ON A.id = BA.authorId
             JOIN BookGenre as BG ON BG.bISBN = BD.ISBN 
        WHERE BD.ISBN = %s
        GROUP BY BD.ISBN;
        """
        self.__cursor.execute(cmd, isbn)
        ret = self.__cursor.fetchone()
        ret['ISBN'] = isbn # cheeky putting isbn into the book w/out query
        ret['genres'] = ret['genres'].split(',')
        return ret
