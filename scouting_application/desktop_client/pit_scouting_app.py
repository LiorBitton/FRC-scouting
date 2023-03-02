import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json
from os.path import abspath
from game import Game
import csv
cred = credentials.Certificate('./credentials.json')
app = firebase_admin.initialize_app(cred, {
	'databaseURL': 'https://everscout-3c93c.firebaseio.com/'})
print("Connection OK")

with open(f"C:/Users/USER/AppData/Local/Programs/Python/Python310/desktop_client/pit scouting/data.csv", encoding="utf-8") as file:
	handle = csv.reader(file)
	data = list(handle)


quest = data[0]
excluded_questions = []

for row in data:
	if row[1] == "מספר קבוצה":
		continue
	row_data = {}
	teamKey = ""
	for i, col in enumerate(row):
		if quest[i] in excluded_questions:
			continue
		if i == 1:
			teamKey = col
		row_data[quest[i]] = col
	
	db.reference(f"teams/{teamKey}/events/2023isde2/custom").set(row_data)