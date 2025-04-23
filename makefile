# file : makefile

.ONESHELL:
r:
	python3 -m venv venv
	source venv/bin/activate	
	firefox localhost:5000 
	export FLASK_APP=flask_app.py
	export FLASK_ENV=development
	flask --app flask_app.py --debug run

db:
	mysql --user=root --password=root --database=LMT < LMT.sql
dump:
	mysql --user='root' --password='root' < cleardb.sql
	mysqldump -u root -p LMT > LMT.sql
