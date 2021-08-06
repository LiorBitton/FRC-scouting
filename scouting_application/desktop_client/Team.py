class team:
    __init__()


class game:
    def __init__(self, alliance: str, auto_inner: int, auto_lower: int, auto_moved: bool, auto_outer: int, come_to_climb_from: str,
                 climbed: bool, cycle_trough: str, fouls: int, game_id: int, inner: int, reveled_climb: bool, lower: int, outer: int,
                 playoff_game: bool, position_control_done: bool, recorder_name: str, rotation_control_done: bool, stage_reached: int,
                 tech_fouls: int, total_game_points: int, tried_to_climb: bool, went_to_climb: int):
        self.alliance = alliance
        self.auto_inner = auto_inner
        self.auto_lower = auto_lower
        self.auto_moved = auto_moved
        self.auto_outer = auto_outer
        self.come_to_climb_from = come_to_climb_from
        self.climbed = climbed
        self.cycle_trough = cycle_trough
        self.fouls = fouls
        self.game_id = game_id
        self.inner = inner
        self.reveled_climb = reveled_climb
        self.lower = lower
        self.outer = outer
