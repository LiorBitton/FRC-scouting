import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json
from os.path import abspath
cred = credentials.Certificate(
    {
        "type": "service_account",
        "project_id": "everscout-3c93c",
                "private_key_id": "781ac889c76e95900a6fcd5db1300f0f1e3aab30",
                "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCrRYBS/aGGDxnp\ngwOaPld8xekv/fAuDulJ3WeAAMXy8rKZZwYK+hICBIG7B8DBx8VV7LN0+b3thMK5\n9K/BIE+EbRKfC+aGeI5izlV7rLbomwaRgkUfJ5gfIn6kr+VrhrQPR7hry7bZxAY7\nzfHQBj/egHGC4rV75hflVIg0aNjWC5l1UVbFHyuEM4sjqlI+5LoRnlRWSekYYYOY\nlVQB+8wkATpbChI060WUUT+wf7SbpZ3Xe9GI7xpo7gKPnL+QoRO/4ETGSbNba33J\nDxBvfnVK0AWrcVTNhuE7dhDLk+Y4yyA6R9rCAIJc5aolQz3GW6bu1TwONhf/CKmv\n8yonlt9PAgMBAAECggEANce+MtEnvjPRvCyCnhWDXU+8GHDR0XSnNqWKUXxsrAwf\nnuHl2N6Ldwy5O+SEV5UGVyPbehjN1d6BUukNo0QlE/04Aq829PS4KTiHSS2Dxeig\nGGLil5TURLqNL+N309rZgY7QzzCJuzm9h1v02ZCMz65fdmz/9ebbjAyONH7Tz+oS\nV9LW0UxdRpSc/qOu2pqsStHD/EB22+vAF3HqUk8o0t1HU98c/3Jdk75rLonoCSSA\n+iaePEibDI4yDBmoKDt1WGNcTiseDQAkPW+Bf/Xj3U5DXldVu7YF7PIGEWIDh9fg\nNcM2rVfNgfKopIJangnlVb2SFv0FBrQf7ZIFZVMDCQKBgQDnzzFBUvFkmlpkZJn6\naZQpclitmLnFv6kZkvNe4yMOCgHJ3i/bNRE3CNwTLr+7dSUwPh8ZtWbfwaVMCHZU\nJ8bbhoVlhXzQ5f8eV3K4y+K/KgCKICGIsmcp/YwKYfHdiNJ9r5xaOz61uwxUqCeK\nW78kdoL7AHFK0MCLzzmYhlYQXQKBgQC9JQjZvtGNmouk0jzYyAW6XT2UjZ08YhrZ\nxFLBetVepnFPwa074Z5OzshF6Nm0RS8h0dgd4lmZsSiC2Vs8bPMt42+80CCQmler\nfnOqLyqPgyvAzUWFYn6TBHFO9PVbc5uiQpNc/cA1en/lemJId05blmbuaKculqAb\nxFAXd1NjmwKBgBylkz2yZVh8Zr1PXWP/1iqFEgZqAFM6y0f4zBCm2zcp72ymA54A\nYd8+Pgw008bzxCPBGZDQxSTTxnyt8wmVXNLWPff81h7uvWdfgTLrJ1tecnCfZeWB\nvpQG3F6QGha5iOG1aQoRlj9ZHT39Bd3oVqfH6YnhVR7cy167vi9mMo6VAoGAIWOV\nQWL2+QlMF2dpiFce87wb78pj9FHZLZIDjdYSLmgxXoPxAb4dRQopvnWRYMpJvK2f\nef8IFCJ65UZbXbpZ30Lj6a/P39bvHP3wix1SZQ0hvyI9YIN3lppVKjwByAgLdERO\nYT8GHCqowyisiuBMu8w8FV/yCz5Zuy0Xelz9InsCgYBGiySMOZECgCEEki6IHLl9\nIYyRBx5ouVR60d3kcZOk2vXs+nYxELDg5ne+6YCvLGiHK/axFtyuwJUubP7hyvsj\nJ6lEYabJFshoNTgC/NUpOiqL5sOY74qH7N1hhmHhfYbovAc32Qe3+lPdCfJm3PY9\nFd+Yy54kHaujIGNPUVGVRA==\n-----END PRIVATE KEY-----\n",
                "client_email": "firebase-adminsdk-kasna@everscout-3c93c.iam.gserviceaccount.com",
                "client_id": "113143891953693834243",
                "auth_uri": "https://accounts.google.com/o/oauth2/auth",
                "token_uri": "https://oauth2.googleapis.com/token",
                "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
                "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-kasna%40everscout-3c93c.iam.gserviceaccount.com"
    })
app = firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://everscout-3c93c.firebaseio.com/'})
print("Connection OK")
download_database_ref = db.reference('listeners/download_database')
update_team_analytics_ref = db.reference('listeners/update_team_analytics')
update_team_analytics_ref.set(7112)
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
	for game in data:
		if (game is None):
			continue
		print(f'{game["match_number"]}:',game['tele_inner'])

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