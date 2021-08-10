import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json
from os.path import abspath
from game import Game
cred = credentials.Certificate('./credentials.json')
app = firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://everscout-3c93c.firebaseio.com/'})
print("Connection OK")
update_team_analytics_ref = db.reference('listeners/update_team_analytics')


def update_games_analytics(teamID,data =None):
	games_ref = db.reference(f'teams/{teamID}/games')
	if data is None:
		data = games_ref.get()
		if data is None:
			print('No information on this team')
			return
	for key in data.keys():
		if (key is None):
			continue
		game_data = data[key]
		try:
			game_data['points']
		except Exception as err:
			print(f'updating game #{key[1:]}')
			#load the  game_data into the dataclass and get a
			#reference to the game in order to add statistics
			game_object= Game(game_data)
			game_ref = games_ref.child(f'{key}')
			#
			game_ref.child('points').set(game_object.points())
			game_ref.child('score_percentage').set(game_object.score_percentage())
		
def update_last_game(teamID,data=None):
	if data is None:
		games_ref = db.reference(f'teams/{teamID}/games')
		data = games_ref.get()
		if data is None:
			print('No information on this team')
			return
	lastgame = 0
	#find the team's last game
	for key in data.keys():
		if (key is None):
			continue
		game_number = int(key[1:])  #remove the G
		if (game_number> lastgame):
			lastgame = game_number
		
	game_data = data[f'G{lastgame}']
	print(f'updating last game of team #{teamID} to be game #{lastgame}')
	#load the  game_data into the dataclass and get a
	#reference to the game in order to add statistics
	game_object= Game(game_data)
	last_game_ref = db.reference(f'teams/{teamID}/last_game')
	#
	last_game_ref.child('comment').set(game_object.comment)
	last_game_ref.child('climbed').set(game_object.climbed)
	last_game_ref.child('points').set(game_object.points())
	last_game_ref.child('score_percentage').set(game_object.score_percentage())
	
def update_team_stats(teamID, data=None):
	if data is None:
		games_ref = db.reference(f'teams/{teamID}/games')
		data = games_ref.get()
		if data is None:
			print('No information on this team')
			return
	team_stats_ref = db.reference(f'teams/{teamID}/stats')
	sum_percentage = 0
	sum_points = 0
	count = 0
	for key in data.keys():
		if key is None:
			continue
		count += 1
		sum_points += int(data[key]['points'])
		sum_percentage += int(data[key]['score_percentage'])
	avg_points = sum_points/count
	avg_percentage = sum_percentage / count
	team_stats_ref.child('avg_points').set(avg_points)
	team_stats_ref.child('score_percentage').set(avg_percentage)

def update_team_analytics(teamID):
	games_ref = db.reference(f'teams/{teamID}/games')
	games = games_ref.get()
	if games is None:
		print(f'No information on team #{teamID}')
	print(f'Updating team #{teamID}')
	update_games_analytics(teamID, games)
	update_last_game(teamID,games)
	games = games_ref.get()
	if games is None:
		print(f'error fetching data#{teamID}')
	update_team_stats(teamID, games)
	
def update_team_analytics_listener(event):
	if (event.data == '0'):
		return
	if (event.data == '-1'):
		ref = db.reference('teams')
		data = ref.get()
		for team in data.keys():
			update_team_analytics(int(team))
	else:
		print(f'Updating analytics for team #{event.data}:...')
		update_team_analytics(int(event.data))
	print('Update completed')
	update_team_analytics_ref.set('0')

update_team_analytics_ref.listen(update_team_analytics_listener)