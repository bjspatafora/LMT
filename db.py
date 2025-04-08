# db.py

import pymysql
from datetime import datetime, timedelta
import random
import myemail

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
        
        timestamp = datetime.now() + timedelta(minutes=30)
        self.__cursor.execute('insert Register(username, email, password, ' \
                              'validTimeout, valcode) ' \
                              'values(%s, %s, %s, %s, %s)',
                              (username, email, password, timestamp, code))
        self.__cursor.execute('commit')
        return code

    def insertUser(self, username, email, password):
        self.__cursor.execute('delete from Register where username=%s', (username))
        self.__cursor.execute('insert User(username, email, password) values(%s, %s, %s)', (username, email, password))
        self.__cursor.execute('commit')
        
    def validate(self, username, code):
        self.__cursor.execute('select * from Register where username=%s and valcode=%s and validTimeout > NOW()', (username, code))
        res = self.__cursor.fetchone()
        if res is None:
            return False
        email = res['email']
        password = res['password']
        self.insertUser(username, email, password)
        return True

    def availUsername(self, username):
        self.__cursor.execute('(select username from User where username=%s) union (select username from Register where username=%s)', (username, username))
        return self.__cursor.fetchone() is None
