class Game:
    # def __init__(self, alliance: str, auto_inner: int, auto_lower: int, auto_moved: bool, auto_outer: int, come_to_climb_from: str,
    #              climbed: bool, cycle_trough: str, fouls: int, game_id: int, inner: int, reveled_climb: bool, lower: int, outer: int,
    #              playoff_game: bool, position_control_done: bool, recorder_name: str, rotation_control_done: bool, stage_reached: int,
    #              tech_fouls: int, total_game_points: int, tried_to_climb: bool, went_to_climb: int):
    #     self.alliance = alliance
    #     self.auto_inner = auto_inner
    #     self.auto_lower = auto_lower
    #     self.auto_moved = auto_moved
    #     self.auto_outer = auto_outer
    #     self.come_to_climb_from = come_to_climb_from
    #     self.climbed = climbed
    #     self.cycle_trough = cycle_trough
    #     self.fouls = fouls
    #     self.game_id = game_id
    #     self.inner = inner
    #     self.reveled_climb = reveled_climb
    #     self.lower = lower
	#     self.outer = outer
	def __init__(self, auto_inner: int, auto_lower: int, auto_outer: int, auto_moved: bool, tele_inner: int, tele_outer: int, tele_lower: int, end_climbed: bool, inactive_time: int):
		self.auto_inner = auto_inner
		self.auto_outer = auto_outer
		self.auto_lower = auto_lower
		self.auto_moved = auto_moved
		self.tele_inner = tele_inner 
		self.tele_outer = tele_outer
		self.tele_lower = tele_lower
		self.climbed = end_climbed
		self.inactive_time = inactive_time
	def __init__(self, game: dict):
		self.auto_inner = game['auto_inner']
		self.auto_outer = game['auto_outer']
		self.auto_lower = game['auto_lower']
		self.auto_moved = game['auto_moved']
		self.tele_inner = game['tele_inner']
		self.tele_outer = game['tele_outer']
		self.tele_lower = game['tele_lower']
		self.climbed = game['climbed']
		self.inactive_time = game['inactive_time']

	def score(self):
		sum = 0
		sum += self.auto_inner*6
		sum+= self.auto_outer*4
		sum+= self.auto_lower*2
		sum+= 5 if self.auto_moved else 0
		sum+= self.tele_inner*3
		sum+= self.tele_outer*2
		sum += self.tele_lower
		sum += 25 if self.climbed else 0
		return sum