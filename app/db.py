# db.py

import pymysql
from datetime import datetime, timedelta, date
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
    
    def advancedSearch(self, title, author, genre, minrating, start=0,
                       size=20):
        cmd = """
        SELECT DISTINCT BD.ISBN, BD.title, A.name as author
        FROM BookDescription as BD
             JOIN Book_Author AS BA ON BA.bISBN = BD.ISBN
             JOIN Author as A ON A.id = BA.authorId
             JOIN Book_Genre as BG ON BG.bISBN = BD.ISBN
             JOIN Genre as G ON BG.gId=G.id
             LEFT JOIN (select bISBN, sum(stars)/count(*) as avRating from
                 Rating) as R on BD.ISBN=R.bISBN
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
            if minrating:
                cmd += "R.avRating >= %s " % minrating
        elif minrating:
            cmd += "WHERE "
            cmd += "R.avRating >= %s " % minrating
        cmd += "LIMIT %s, %s" % (start, start+size)
        
        self.__cursor.execute(cmd, params)
        curr = self.__cursor.fetchone()
        n = self.__cursor.fetchone()
        res = []
        while n is not None:
            if n['ISBN'] != curr['ISBN']:
                res.append(curr)
                curr = n
            else:
                curr['author'] += ', ' + n['author']
            n = self.__cursor.fetchone()
        res.append(curr)
        return res
    
    def bookDetails(self, isbn):
        isbn = int(isbn)
        cmd = """
        SELECT BD.title, BD.pubYear as year, BD.synopsis,
               GROUP_CONCAT(DISTINCT A.name) as author,
               GROUP_CONCAT(DISTINCT G.genreName) AS genres, S.name as series,
               BD.totalStock
        FROM BookDescription as BD
             JOIN Book_Author AS BA ON BA.bISBN = BD.ISBN
             JOIN Author as A ON A.id = BA.authorId
             LEFT JOIN Book_Genre as BG ON BG.bISBN = BD.ISBN
             LEFT JOIN Genre as G ON G.id=BG.gId
             LEFT JOIN Book_Series as BS ON BD.ISBN = BS.bISBN
             LEFT JOIN Series as S ON BS.seriesId = S.id
        WHERE BD.ISBN = %s
        GROUP BY BD.ISBN;
        """
        self.__cursor.execute(cmd, isbn)
        ret = self.__cursor.fetchone()
        if ret is not None:
            ret['ISBN'] = isbn # cheeky putting isbn into the book w/out query
            ret['genres'] = ret['genres'].split(',')
        return ret

    def numTotalCheckouts(self, isbn):
        self.__conn.commit()
        cmd = """select count(*) as n
        from Checkout
        where bISBN=%s and not returned"""
        
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
            ret.append(curr)
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

    def isOnHold(self, user, isbn):
        cmd = """
        select Hold.id from Hold join User on Hold.uId = User.id
        where User.username = %s and Hold.bISBN = %s
        """
        self.__cursor.execute(cmd, (user, isbn))
        return self.__cursor.fetchone() is not None
        
    def getUserHolds(self, user):
        if isinstance(user, int):
            cmd = """
            select BD.title, GROUP_CONCAT(A.name) as authors, H.end, BD.ISBN
            from Hold as H
            join BookDescription as BD on H.bISBN=BD.ISBN
            join Book_Author as BA on H.bISBN = BA.bISBN
            join Author as A on A.id = BA.authorID
            where uId=%s
            GROUP BY BD.ISBN
            """
        else:
            cmd = """
            select BD.title, GROUP_CONCAT(A.name) as authors, H.end, BD.ISBN
            from Hold as H
            join BookDescription as BD on H.bISBN=BD.ISBN
            join Book_Author as BA on H.bISBN = BA.bISBN
            join Author as A on A.id = BA.authorID
            where uId=(select id from User where username=%s)
            GROUP BY BD.ISBN
            """
        self.__cursor.execute(cmd, user)
        ret = []
        curr = self.__cursor.fetchone()
        while curr is not None:
            #curr['authors'] = curr['authors'].split(',')
            ret.append(curr)
            curr = self.__cursor.fetchone()
        return ret
    
    def newBook(self, isbn, title, authors, series, pubyear, genres, synopsis,
                amount):
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

        if series is not None:
            cmd = """
            insert Series(name) values(%s)
            """
            cmd1 = """
            insert into Book_Series(bISBN, seriesId)
            select %s, id from Series where name=%s
            """
            try:
                self.__cursor.execute(cmd, series)
            except:
                pass
            self.__cursor.execute(cmd1, (isbn, series))

        if genres is not None:
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

    def changeBookAuthors(self, isbn, authors):
        cmd = """
        delete from Book_Author where isbn=%s
        """
        self.__cursor.execute(cmd, isbn)
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
        self.__conn.commit()
    
    def changeBookGenres(self, isbn, genres):
        cmd = """
        delete from Book_Genre where bISBN=%s
        """
        self.__cursor.execute(cmd, isbn)
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

    def changeBookSeries(self, isbn, series):
        cmd = """
        delete from Book_Series where bISBN=%s
        """
        self.__cursor.execute(cmd, isbn)
        cmd = """
        insert Series(name) values(%s)
        """
        try:
            self.__cursor.execute(cmd, series)
        except:
            pass
        cmd = """
        insert into Book_Series(bISBN, seriesId)
        select %s, id from Series where name=%s
        """
        self.__cursor.execute(cmd, (isbn, series))
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
        self.__cursor.execute(cmd, (synopsis, isbn))
        self.__conn.commit()
        
    def addWaitlist(self, isbn, user):
        cmd = """
        insert into Waitlist(bISBN, uId)
        select %s, id from User where username=%s
        """
        self.__cursor.execute(cmd, (isbn, user))
        self.__conn.commit()

    def onWaitlist(self, user, isbn):
        cmd = """
        select W.id from Waitlist as W
        Join User as U on W.uId = U.id
        where U.username = %s and W.bISBN = %s
        """
        self.__cursor.execute(cmd, (user, isbn))
        return self.__cursor.fetchone() is not None
        
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

    def getUserWaitlists(self, user):
        if isinstance(user, int):
            pass
        elif isinstance(user, str):
            cmd = """
            select BD.ISBN, BD.title, GROUP_CONCAT(A.name) as authors
            from Waitlist as W
            join BookDescription as BD on W.bISBN = BD.ISBN
            join User as U on U.id = W.uId
            join Book_Author as BA on BA.bISBN = BD.ISBN
            join Author as A on A.id = BA.authorId
            where U.username = %s
            group by BD.ISBN
            """
            self.__cursor.execute(cmd, user)
            curr = self.__cursor.fetchone()
            ret = []
            while curr is not None:
                curr['authors'] = curr['authors'].split(',')
                ret.append(curr)
                curr = self.__cursor.fetchone()
            return ret
        
    def userId(self, user):
        self.__cursor.execute("SELECT id FROM User WHERE username=%s", user)
        q = self.__cursor.fetchone()
        return None if q is None else q['id']
    
    def friends(self, user):
        cmd = """
        SELECT u1.username as un1, u2.username as un2
        FROM Friends
             JOIN User AS u1 ON u1.id = Friends.user1_id
             JOIN User AS u2 on u2.id = Friends.user2_id
        WHERE u1.username = %s OR u2.username = %s
        """
        self.__cursor.execute(cmd, (user, user))
        query = self.__cursor.fetchall()
        return {row['un1'] if row['un1'] != user else row['un2'] for row in query}

    def friendRequests(self, user):
        cmd = """
        SELECT u_from.username
        FROM FriendRequests
             JOIN User AS u_from ON u_from.id = FriendRequests.from_id
             JOIN User AS u_to ON u_to.id = FriendRequests.to_id
        WHERE u_to.username = %s
        """
        self.__cursor.execute(cmd, user)
        query = self.__cursor.fetchall()
        return {row['username'] for row in query}
    
    
    def addFriend(self, sender, reciever):
        cmd = "select * from User where username=%s"
        self.__cursor.execute(cmd, reciever)
        if self.__cursor.fetchone() is not None:
            senderId = self.userId(sender)
            recieverId = self.userId(reciever)
            if reciever in self.friends(sender): return "Friends"
            elif sender in self.friendRequests(reciever): return "Requested"
            elif reciever in self.friendRequests(sender):
                cmd = """DELETE FROM FriendRequests
                WHERE from_id = %s and to_id = %s """
                self.__cursor.execute(cmd, (recieverId, senderId))
                cmd = """ INSERT INTO Friends (user1_id, user2_id)
                VALUES (%s, %s)"""
                self.__cursor.execute(cmd, (senderId, recieverId))
                self.__cursor.execute('commit')
                return "Added"
            else:
                cmd = """INSERT INTO FriendRequests (from_id, to_id)
                VALUES (%s, %s) """
                self.__cursor.execute(cmd, (senderId, recieverId))
                self.__cursor.execute('commit')
                return "Sent"
            
        return "DNE"

    def removeFriendship(self, u1, u2):
        u1id, u2id = self.userId(u1), self.userId(u2)
        if None in [u1id, u2id]:
            return "DNE"
        elif u2 not in self.friends(u1):
            return "Not Friends"
        else:
            cmd = """DELETE FROM Friends
            WHERE (user1_id = %s AND user2_id = %s)
            OR (user1_id = %s and user2_id = %s)
            """
            self.__cursor.execute(cmd, (u1id, u2id, u2id, u1id) )
            self.__cursor.execute('commit')
            return "Removed"
        
    
    def userHandleFR(self, user, other, accepted):
        user_id, other_id = self.userId(user), self.userId(other)
        if None in [user_id, other_id]:
            return "DNE"
        else:
            cmd = """DELETE FROM FriendRequests
            WHERE from_id = %s and to_id = %s """
            self.__cursor.execute(cmd, (other_id, user_id))
        
            if accepted:
                cmd = """ INSERT INTO Friends (user1_id, user2_id)
                VALUES (%s, %s)"""
                self.__cursor.execute(cmd, (user_id, other_id))

            self.__cursor.execute('commit')
            return "Added" if accepted else "Rejected"

    def addRating(self, isbn, user, stars, comment):
        cmd = """
        insert into Rating(bISBN, uId, stars, comment)
        select %s, id, %s, %s from User where username=%s
        """
        self.__cursor.execute(cmd, (isbn, stars, comment, user))
        self.__conn.commit()

    def getBookRatings(self, isbn):
        cmd = """
        select U.username, R.stars, R.comment
        from Rating as R
        join User as U on R.uId = U.id
        where R.bISBN = %s
        """
        self.__cursor.execute(cmd, isbn)
        return self.__cursor.fetchall()
        
        
    def getRating(self, isbn, user):
        cmd = """
        select stars, comment from Rating where bISBN=%s and
        uId=(select id from User where username=%s)
        """
        self.__cursor.execute(cmd, (isbn, user))
        return self.__cursor.fetchone()

    def modifyRating(self, isbn, user, stars):
        cmd = """
        update Rating set stars=%s where bISBN=%s and
        uId=(select id from User where username=%s)
        """
        self.__cursor.execute(cmd, (stars, isbn, user))
        self.__conn.commit()

    def modifyComment(self, isbn, user, comment):
        cmd = """
        update Rating set comment=%s where bISBN=%s and
        uId=(select id from User where username=%s)
        """
        self.__cursor.execute(cmd, (comment, isbn, user))
        self.__conn.commit()

    def averageRating(self, isbn):
        cmd = """
        select sum(stars)/count(*) as avg from Rating where bISBN=%s
        """
        self.__cursor.execute(cmd, isbn)
        ret = self.__cursor.fetchone()
        
        return ret['avg'] if ret is not None else None
        
    def getFriendRecents(self, user):
        cmd = """
        select DISTINCT bISBN from Checkout where uId in
        (select user1_id from Friends where
            user2_id=(select id from User where username=%s) union
            select user2_id from Friends where
            user1_id=(select id from User where username=%s)) limit 10
        """
        self.__cursor.execute(cmd, (user, user))
        return self.__cursor.fetchall()

    def getFriendLikes(self, user):
        cmd = """
        select DISTINCT bISBN from Rating where uId in
        (select user1_id from Friends where
            user2_id=(select id from User where username=%s) union
            select user2_id from Friends where
            user1_id=(select id from User where username=%s))
        and stars > 3 limit 10
        """
        self.__cursor.execute(cmd, (user, user))
        return self.__cursor.fetchall()

    def getPopular(self):
        cmd = """
        SELECT BD.ISBN, BD.title, GROUP_CONCAT(DISTINCT A.name) as author
        FROM BookDescription as BD
             JOIN Book_Author AS BA ON BA.bISBN = BD.ISBN
             JOIN Author as A ON A.id = BA.authorId
             LEFT JOIN (select bISBN, sum(stars)/count(*) as avRating
                        from Rating) as R on BD.ISBN=R.bISBN
        group by BD.ISBN order by R.avRating desc LIMIT 10
        """
        self.__cursor.execute(cmd)
        return self.__cursor.fetchall()

    def getStartedSeriesBooks(self, user):
        cmd = """
        select DISTINCT bISBN from Book_Series where seriesId in
        (select seriesId from Checkout join Book_Series
            on Checkout.bISBN=Book_Series.bISBN
            where uId=(select id from User where username=%s)) and
        bISBN not in (select bISBN from Checkout where
            uId=(select id from User where username=%s)) limit 10
        """
        self.__cursor.execute(cmd, (user, user))
        return self.__cursor.fetchall()
    

    
