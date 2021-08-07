import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json
from os.path import abspath
cred = credentials.Certificate('./credentials.json')
app = firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://everscout-3c93c.firebaseio.com/'})
print("Connection OK")
download_database_ref = db.reference('listeners/download_database')
update_team_analytics_ref = db.reference('listeners/update_team_analytics')
teams_ref = db.reference('teams')

teams_data ={}
with open('teams.json','r') as json_file:
    teams_data = json.load(json_file)

def update_teams_file_offline():
	with open('teams.json', 'w') as outfile:
		json.dump(teams_data, outfile)
def update_teams_file_online():
	global teams_data
	with open('teams.json', 'w') as outfile:
			teams_data = db.reference('teams').get()
			json.dump(teams_data, outfile)
def teams_listener(event):
	print('new game arrived')


def download_database_listener(event):
	if (str(event.data) == '1'):
		print('downloading database:...')
		update_teams_file_online()
		print('download completed')
		download_database_ref.set('0')


def update_analytics(teamID):
	games_ref = db.reference(f'teams/{teamID}/games')
	data = games_ref.get()
	if data is None:
		print('No information on this team')
		return
	print(str(data))
	for key in data.keys():
		if (key is None):
			continue
		print(f'{key}:',data[key]['tele_inner'])

def update_team_analytics_listener(event):
	if (event.data == '0'):
		return
	print(f'Updating analytics for team {event.data}:...')
	update_analytics(int(event.data))
	update_team_analytics_ref.set('0')
	print('Update completed')

update_team_analytics_ref.listen(update_team_analytics_listener)
teams_ref.listen(teams_listener)
download_database_ref.listen(download_database_listener)