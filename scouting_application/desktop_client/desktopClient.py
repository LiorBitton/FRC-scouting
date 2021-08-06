import graphFunctions as gf
import firebase_admin
import matplotlib.pyplot as plt
from firebase_admin import credentials
from firebase_admin import db
cred = credentials.Certificate('./credentials.json')
app = firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://everscout-3c93c.firebaseio.com/'})
print("Connection OK")
# End of Initiation

print("Enter team id to show stats for:")
team_id = int(input())
team_db_num = gf.find_team_db_id(team_id)

if team_db_num == -1:
    print("Could not find any data related to the team")
    quit()

gf.graph_total_points(team_db_num)
# listener example

# def data_change(event):
#     if event.data is not None:
#         current_data = event.data  #do something with event.data(the updated values)

# ref_main.listen(data_change)
