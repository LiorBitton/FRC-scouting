import firebase_admin
import matplotlib.pyplot as plt
from firebase_admin import credentials
from firebase_admin import db


def find_team_db_id(team_id):
    i = 0
    while True:
        ref = db.reference('teams/m_teams/' + str(i) + '/id')
        res = ref.get()
        if res is None:
            return -1
        if res == team_id:
            return i
        i = i + 1


def graph_total_points(db_id):
    game_results = []
    i = 0
    while True:
        ref_main = db.reference(
            'teams/m_teams/'+str(db_id)+'/games/' + str(i) + '/totalGamePoints')
        i = i + 1
        res = ref_main.get()
        if res is None:
            break
        game_results.append(res)
    x_axis = []
    for j in range(len(game_results)):
        x_axis.append(j)

    plt.plot(x_axis, game_results)
    plt.plot()
    plt.xlabel('game number')
    plt.ylabel('points')
    plt.axis([0, len(game_results), 0, 100])
    plt.title(
        'team ' + str(db.reference('teams/m_teams/' + str(db_id) + '/id').get()))
    plt.show()
