extends Node2D


# ==========================================
# LEVEL SYSTEM
# ==========================================

var current_level = 1
var levels_screen = false


# ==========================================
# THEME / SKIN SYSTEM
# ==========================================

var current_theme = "classic"
var skins_screen = false

# Wooden background for Level 1
var wood_base_color = Color("#8B5A2B")
var wood_line_color = Color("#70421F")
var themes = {
	"classic": {
		"background": Color(0.82, 0.90, 0.98),
		"board": Color(0.94, 0.97, 1.0),
		"board_background": Color(0.10, 0.38, 0.75),
		"lines": Color(0.10, 0.20, 0.30),
		"title": Color(0.10, 0.20, 0.30)
	},

	"wooden": {
		"background": Color(0.76, 0.62, 0.45),
		"board": Color(0.91, 0.78, 0.60),
		"board_background": Color(0.86, 0.72, 0.54),
		"lines": Color(0.25, 0.15, 0.08),
		"title": Color(0.25, 0.15, 0.08)
	},

	"space": {
		"background": Color(0.05, 0.05, 0.12),
		"board": Color(0.10, 0.10, 0.20),
		"board_background": Color(0.08, 0.08, 0.16),
		"lines": Color(0.70, 0.70, 1.0),
		"title": Color(0.80, 0.80, 1.0)
	}
}


# ==========================================
# PLAYER SYMBOLS
# ==========================================

var player1_symbol = "★"
var player2_symbol = "◆"

var coin_skins_screen = false
var active_coin_player = 1

var player1_coin_skin = "Pirate Coin"
var player2_coin_skin = "Anime Coin"

var coin_skin_names = [
	"Classic Coin",
	"Pirate Coin",
	"Anime Coin"
]

var coin_skin_descriptions = [
	"Simple classic player coin",
	"Skull and crossbones treasure coin",
	"Cute anime-inspired character coin"
]


# ==========================================
# VICTORY EFFECT SYSTEM
# ==========================================

var victory_effects_screen = false
var active_effect_player = 1

var player1_victory_effect = "Thunder Strike"
var player2_victory_effect = "Candy Pop"

var victory_effect_names = [
	"Thunder Strike",
	"Crystal Burst",
	"Fire Line",
	"Ice Freeze",
	"Galaxy Energy",
	"Candy Pop",
	"Electric Chain",
	"Portal Burst",
	"Royal Victory",
	"Ultimate Combo"
]

var victory_effect_descriptions = [
	"Lightning connects the pieces",
	"The pieces turn into crystals",
	"The line catches fire",
	"The pieces freeze and shatter",
	"Cosmic energy fills the line",
	"The pieces bounce and pop",
	"Electricity jumps between pieces",
	"A portal opens and bursts",
	"The pieces glow with a crown",
	"A powerful combination burst"
]


# ==========================================
# GAME VARIABLES
# ==========================================

var player1_pieces = 0
var player1_positions = []

var player2_pieces = 0
var player2_positions = []

var current_player = 1

var occupied_positions = []

var movement_phase = false
var selected_piece = -1

var is_moving = false
var moving_position = Vector2.ZERO
var moving_target = Vector2.ZERO
var moving_player = 0

var game_over = false
var winner_text = ""
var winning_positions = []
var winner_player = 0
var star_celebration_started = false
var star_celebration_time = 0.0


# ==========================================
# BOARD POSITIONS
# ==========================================

var points = [
	Vector2(60, 300),
	Vector2(360, 300),
	Vector2(660, 300),
	Vector2(60, 600),
	Vector2(360, 600),
	Vector2(660, 600),
	Vector2(60, 900),
	Vector2(360, 900),
	Vector2(660, 900)
]


# ==========================================
# BOARD CONNECTIONS
# ==========================================

var connections = {
	0: [1, 3, 4],
	1: [0, 2, 4],
	2: [1, 5, 4],
	3: [0, 6, 4],
	4: [0, 1, 2, 3, 5, 6, 7, 8],
	5: [2, 8, 4],
	6: [3, 7, 4],
	7: [6, 8, 4],
	8: [5, 7, 4]
}


# ==========================================
# WINNING COMBINATIONS
# ==========================================

var winning_lines = [
	[0, 1, 2],
	[3, 4, 5],
	[6, 7, 8],
	[0, 3, 6],
	[1, 4, 7],
	[2, 5, 8],
	[0, 4, 8],
	[2, 4, 6]
]


# ==========================================
# VICTORY ANIMATION LOOP
# ==========================================

func _process(delta):
	if game_over and winning_positions.size() > 0:
		if star_celebration_started:
			star_celebration_time += delta

		queue_redraw()

		queue_redraw()


# ==========================================
# DRAW
# ==========================================

func _draw():
	draw_wooden_background()

	var theme = themes[current_theme]


	# ======================================
	# LEVELS SCREEN
	# ======================================

	if levels_screen:

		draw_rect(
			Rect2(0, 0, 720, 1280),
			theme["background"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(255, 100),
			"LEVELS",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			48,
			theme["title"]
		)

		# Level 1
		draw_rect(
			Rect2(70, 180, 580, 150),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 235),
			"LEVEL 1",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			38,
			theme["board"]
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 285),
			"CLASSIC BOARD",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			theme["board"]
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(500, 260),
			"PLAY",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			28,
			theme["board"]
		)

		# Level 2
		draw_rect(
			Rect2(70, 360, 580, 150),
			Color(0.70, 0.70, 0.70),
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 415),
			"LEVEL 2",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			38,
			Color(0.20, 0.20, 0.20)
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 465),
			"NEW BOARD",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			Color(0.20, 0.20, 0.20)
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(480, 440),
			"LOCKED",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			28,
			Color(0.20, 0.20, 0.20)
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(210, 650),
			"CURRENT LEVEL: " + str(current_level),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			30,
			theme["title"]
		)

		draw_rect(
			Rect2(210, 900, 300, 80),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(315, 952),
			"BACK",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			36,
			theme["board"]
		)

		return


	# ======================================
	# SKINS SCREEN
	# ======================================

	if skins_screen:

		draw_rect(
			Rect2(0, 0, 720, 1280),
			theme["background"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(280, 100),
			"SKINS",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			48,
			theme["title"]
		)

		# Classic
		draw_rect(
			Rect2(70, 180, 580, 150),
			themes["classic"]["board"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 230),
			"CLASSIC",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			36,
			themes["classic"]["title"]
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 280),
			"Blue crystal energy",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			themes["classic"]["title"]
		)

		# Wooden
		draw_rect(
			Rect2(70, 360, 580, 150),
			themes["wooden"]["board"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 410),
			"WOODEN",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			36,
			themes["wooden"]["title"]
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 460),
			"Warm wooden theme",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			themes["wooden"]["title"]
		)

		# Space
		draw_rect(
			Rect2(70, 540, 580, 150),
			themes["space"]["board"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 590),
			"SPACE",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			36,
			themes["space"]["title"]
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(100, 640),
			"Dark futuristic theme",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			themes["space"]["title"]
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(210, 780),
			"CURRENT: " + current_theme.to_upper(),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			30,
			theme["title"]
		)

		draw_rect(
			Rect2(210, 900, 300, 80),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(315, 952),
			"BACK",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			36,
			theme["board"]
		)

		return


	# ======================================
	# COIN SKINS SCREEN
	# ======================================

	if coin_skins_screen:

		draw_rect(
			Rect2(0, 0, 720, 1280),
			theme["background"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(205, 70),
			"PLAYER COINS",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			42,
			theme["title"]
		)

		# Player selector buttons
		draw_rect(
			Rect2(35, 115, 300, 70),
			theme["lines"],
			true
		)

		draw_rect(
			Rect2(385, 115, 300, 70),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(105, 160),
			"PLAYER 1",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			28,
			theme["board"]
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(455, 160),
			"PLAYER 2",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			28,
			theme["board"]
		)

		# Coin skin cards
		var coin_card_positions = [
			Vector2(70, 220),
			Vector2(70, 400),
			Vector2(70, 580)
		]

		for i in range(coin_skin_names.size()):

			var card_rect = Rect2(
				coin_card_positions[i],
				Vector2(580, 150)
			)

			draw_rect(
				card_rect,
				theme["board"],
				true
			)

			draw_circle(
				coin_card_positions[i] + Vector2(75, 75),
				45,
				Color(0.80, 0.65, 0.25)
			)

			draw_circle(
				coin_card_positions[i] + Vector2(75, 75),
				36,
				Color(0.95, 0.82, 0.35)
			)

			if coin_skin_names[i] == "Pirate Coin":
				draw_string(
					ThemeDB.fallback_font,
					coin_card_positions[i] + Vector2(48, 86),
					"☠",
					HORIZONTAL_ALIGNMENT_LEFT,
					-1,
					42,
					Color(0.20, 0.12, 0.05)
				)

			elif coin_skin_names[i] == "Anime Coin":
				draw_circle(
					coin_card_positions[i] + Vector2(62, 68),
					5,
					Color(0.15, 0.10, 0.20)
				)
				draw_circle(
					coin_card_positions[i] + Vector2(88, 68),
					5,
					Color(0.15, 0.10, 0.20)
				)
				draw_string(
					ThemeDB.fallback_font,
					coin_card_positions[i] + Vector2(65, 100),
					"☆",
					HORIZONTAL_ALIGNMENT_LEFT,
					-1,
					24,
					Color(0.80, 0.20, 0.55)
				)

			draw_string(
				ThemeDB.fallback_font,
				coin_card_positions[i] + Vector2(145, 50),
				coin_skin_names[i],
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				30,
				theme["title"]
			)

			draw_string(
				ThemeDB.fallback_font,
				coin_card_positions[i] + Vector2(145, 90),
				coin_skin_descriptions[i],
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				20,
				theme["title"]
			)

			var is_selected = false

			if active_coin_player == 1 and player1_coin_skin == coin_skin_names[i]:
				is_selected = true
			elif active_coin_player == 2 and player2_coin_skin == coin_skin_names[i]:
				is_selected = true

			if is_selected:
				draw_string(
					ThemeDB.fallback_font,
					coin_card_positions[i] + Vector2(145, 125),
					"EQUIPPED",
					HORIZONTAL_ALIGNMENT_LEFT,
					-1,
					18,
					theme["title"]
				)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(190, 800),
			"P1: " + player1_coin_skin + "    P2: " + player2_coin_skin,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			theme["title"]
		)

		draw_rect(
			Rect2(210, 900, 300, 80),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(315, 952),
			"BACK",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			36,
			theme["board"]
		)

		return


	# ======================================
	# VICTORY EFFECTS SCREEN
	# ======================================

	if victory_effects_screen:

		draw_rect(
			Rect2(0, 0, 720, 1280),
			theme["background"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(190, 70),
			"VICTORY EFFECTS",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			42,
			theme["title"]
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(190, 110),
			"CHOOSE YOUR WINNING EFFECT",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			20,
			theme["title"]
		)

		if active_effect_player == 1:
			draw_rect(
				Rect2(35, 135, 300, 75),
				Color(0.75, 0.20, 0.25),
				true
			)
		else:
			draw_rect(
				Rect2(35, 135, 300, 75),
				theme["lines"],
				true
			)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(70, 182),
			"PLAYER 1",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			30,
			theme["board"]
		)

		if active_effect_player == 2:
			draw_rect(
				Rect2(385, 135, 300, 75),
				Color(0.20, 0.35, 0.80),
				true
			)
		else:
			draw_rect(
				Rect2(385, 135, 300, 75),
				theme["lines"],
				true
			)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(420, 182),
			"PLAYER 2",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			30,
			theme["board"]
		)

		var current_effect = ""

		if active_effect_player == 1:
			current_effect = player1_victory_effect
		else:
			current_effect = player2_victory_effect

		draw_string(
			ThemeDB.fallback_font,
			Vector2(190, 245),
			"SELECTED: " + current_effect,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			theme["title"]
		)

		var card_positions = [
			Vector2(25, 285),
			Vector2(370, 285),
			Vector2(25, 455),
			Vector2(370, 455),
			Vector2(25, 625),
			Vector2(370, 625),
			Vector2(25, 795),
			Vector2(370, 795),
			Vector2(25, 965),
			Vector2(370, 965)
		]

		for i in range(victory_effect_names.size()):

			var effect_name = victory_effect_names[i]
			var card_position = card_positions[i]

			var is_selected = false

			if active_effect_player == 1 and player1_victory_effect == effect_name:
				is_selected = true

			if active_effect_player == 2 and player2_victory_effect == effect_name:
				is_selected = true

			if is_selected:
				draw_rect(
					Rect2(card_position, Vector2(325, 150)),
					Color(0.95, 0.70, 0.15),
					true
				)
			else:
				draw_rect(
					Rect2(card_position, Vector2(325, 150)),
					theme["lines"],
					true
				)

			draw_string(
				ThemeDB.fallback_font,
				card_position + Vector2(20, 38),
				effect_name,
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				26,
				theme["board"]
			)

			draw_string(
				ThemeDB.fallback_font,
				card_position + Vector2(20, 72),
				victory_effect_descriptions[i],
				HORIZONTAL_ALIGNMENT_LEFT,
				285,
				17,
				theme["board"]
			)

			draw_rect(
				Rect2(
					card_position + Vector2(190, 105),
					Vector2(115, 35)
				),
				theme["board_background"],
				true
			)

			draw_string(
				ThemeDB.fallback_font,
				card_position + Vector2(212, 130),
				"EQUIP",
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				18,
				theme["title"]
			)

			if is_selected:
				draw_string(
					ThemeDB.fallback_font,
					card_position + Vector2(20, 130),
					"EQUIPPED",
					HORIZONTAL_ALIGNMENT_LEFT,
					-1,
					17,
					theme["board"]
				)

		draw_rect(
			Rect2(210, 1145, 300, 70),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(315, 1190),
			"BACK",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			34,
			theme["board"]
		)

		return


	# ======================================
	# NORMAL GAME SCREEN
	# ======================================

	draw_rect(
		Rect2(0, 0, 720, 1280),
		theme["background"],
		true
	)

	# Game title
	draw_string(
		ThemeDB.fallback_font,
		Vector2(255, 80),
		"MY BOARD GAME",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		38,
		theme["title"]
	)

	if not game_over:

		# LEVELS BUTTON
		draw_rect(
			Rect2(35, 165, 130, 55),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(52, 202),
			"LEVELS",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			25,
			theme["board"]
		)

		# VICTORY BUTTON
		draw_rect(
			Rect2(280, 165, 160, 55),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(305, 202),
			"VICTORY",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			25,
			theme["board"]
		)

		# COINS BUTTON
		draw_rect(
			Rect2(280, 235, 160, 50),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(315, 269),
			"COINS",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			theme["board"]
		)

		# SKINS BUTTON
		draw_rect(
			Rect2(540, 165, 130, 55),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(565, 202),
			"SKINS",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			25,
			theme["board"]
		)

	# Turn indicator
	if not game_over:

		var turn_text = "PLAYER " + str(current_player) + "'S TURN"

		draw_string(
			ThemeDB.fallback_font,
			Vector2(220, 150),
			turn_text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			40,
			theme["title"]
		)

	# ======================================
	# BOARD
	# ======================================

	var start = Vector2(60, 300)
	var size = 600
	var end = start + Vector2(size, size)

	# NEW BLUE CRYSTAL / ENERGY BACKGROUND
	draw_crystal_energy_background()


	# Board outline
	draw_rect(
		Rect2(start, Vector2(size, size)),
		Color(0.20, 0.85, 1.0),
		false,
		5
	)

	# Inner glowing outline
	draw_rect(
		Rect2(42, 282, 636, 636),
		Color(0.10, 0.55, 1.0, 0.45),
		false,
		3
	)

	# Horizontal line
	draw_line(
		Vector2(start.x, start.y + size / 2),
		Vector2(end.x, start.y + size / 2),
		theme["lines"],
		5
	)

	# Vertical line
	draw_line(
		Vector2(start.x + size / 2, start.y),
		Vector2(start.x + size / 2, end.y),
		theme["lines"],
		5
	)

	# Diagonal
	draw_line(
		start,
		end,
		theme["lines"],
		5
	)

	# Other diagonal
	draw_line(
		Vector2(start.x, end.y),
		Vector2(end.x, start.y),
		theme["lines"],
		5
	)

	# Board positions
	for point in points:
		draw_circle(point, 20, Color(0.05, 0.20, 0.45, 0.8))
		draw_circle(point, 14, theme["lines"])
		draw_circle(point, 5, Color(0.30, 0.90, 1.0))


	# Player 1 coins
	for position in player1_positions:
		draw_player_coin(position, 1, player1_coin_skin)

	# Player 2 coins
	for position in player2_positions:
		draw_player_coin(position, 2, player2_coin_skin)


	# Moving coin
	if is_moving:

		if moving_player == 1:
			draw_player_coin(moving_position, 1, player1_coin_skin)

		elif moving_player == 2:
			draw_player_coin(moving_position, 2, player2_coin_skin)


	# Selected piece
	if selected_piece != -1:

		draw_circle(
			points[selected_piece],
			32,
			Color.YELLOW
		)

		if current_player == 1:
			draw_player_coin(points[selected_piece], 1, player1_coin_skin)

		elif current_player == 2:
			draw_player_coin(points[selected_piece], 2, player2_coin_skin)


	# Winning highlight
	if game_over and winning_positions.size() > 0:
		draw_winner_highlight()
		draw_winner_effect()
		draw_star_celebration()
	# Game over
	if game_over:

		# Clean victory banner — no overlap with the menu buttons.
		draw_string(
			ThemeDB.fallback_font,
			Vector2(190, 145),
			winner_text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			42,
			theme["title"]
		)

		draw_rect(
			Rect2(210, 165, 300, 70),
			theme["lines"],
			true
		)

		draw_string(
			ThemeDB.fallback_font,
			Vector2(255, 212),
			"PLAY AGAIN",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			32,
			theme["board"]
		)


# ==========================================
# WINNING EFFECTS
# ==========================================

func draw_winner_effect():
	if winner_player == 1 and player1_victory_effect == "Fire Line":
		draw_fire_line_effect()
	elif winner_player == 2 and player2_victory_effect == "Fire Line":
		draw_fire_line_effect()
	elif winner_player == 1 and player1_victory_effect == "Thunder Strike":
		draw_thunder_strike_effect()
	elif winner_player == 2 and player2_victory_effect == "Thunder Strike":
		draw_thunder_strike_effect()
	elif winner_player == 1 and player1_victory_effect == "Crystal Burst":
		draw_crystal_burst_effect()
	elif winner_player == 2 and player2_victory_effect == "Crystal Burst":
		draw_crystal_burst_effect()
	elif winner_player == 1 and player1_victory_effect == "Ice Freeze":
		draw_ice_freeze_effect()
	elif winner_player == 2 and player2_victory_effect == "Ice Freeze":
		draw_ice_freeze_effect()
	elif winner_player == 1 and player1_victory_effect == "Galaxy Energy":
		draw_galaxy_energy_effect()
	elif winner_player == 2 and player2_victory_effect == "Galaxy Energy":
		draw_galaxy_energy_effect()
	elif winner_player == 1 and player1_victory_effect == "Candy Pop":
		draw_candy_pop_effect()
	elif winner_player == 2 and player2_victory_effect == "Candy Pop":
		draw_candy_pop_effect()
	elif winner_player == 1 and player1_victory_effect == "Electric Chain":
		draw_electric_chain_effect()
	elif winner_player == 2 and player2_victory_effect == "Electric Chain":
		draw_electric_chain_effect()
	elif winner_player == 1 and player1_victory_effect == "Portal Burst":
		draw_portal_burst_effect()
	elif winner_player == 2 and player2_victory_effect == "Portal Burst":
		draw_portal_burst_effect()
	elif winner_player == 1 and player1_victory_effect == "Royal Victory":
		draw_royal_victory_effect()
	elif winner_player == 2 and player2_victory_effect == "Royal Victory":
		draw_royal_victory_effect()
	elif winner_player == 1 and player1_victory_effect == "Ultimate Combo":
		draw_ultimate_combo_effect()
	elif winner_player == 2 and player2_victory_effect == "Ultimate Combo":
		draw_ultimate_combo_effect()
func draw_galaxy_energy_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 3.8) + 1.0) * 0.5

	# Cosmic energy runs directly along the winning line.
	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]
		var direction = (end - start).normalized()
		var perpendicular = Vector2(-direction.y, direction.x)

		draw_line(start, end, Color(0.35, 0.20, 1.0, 0.14 + pulse * 0.06), 24.0 + pulse * 4.0)
		draw_line(start, end, Color(0.45, 0.35, 1.0, 0.82), 8.0)
		draw_line(start, end, Color(0.82, 0.90, 1.0, 0.98), 2.5)

		# Small cosmic particles travel along the line.
		for particle_index in range(6):
			var progress = fmod(time * 0.22 + float(particle_index) * 0.17 + float(i) * 0.08, 1.0)
			var particle_position = start.lerp(end, progress)
			var wave = sin(time * 4.0 + float(particle_index) * 1.7) * 4.0
			particle_position += perpendicular * wave
			draw_circle(particle_position, 2.2 + pulse * 1.2, Color(0.85, 0.90, 1.0, 0.92))

	# Small galaxy orbits around each winning coin.
	for i in range(winning_positions.size()):
		var position = winning_positions[i]
		var radius = 43.0 + pulse * 4.0

		draw_arc(position, radius, time * 0.8 + float(i), time * 0.8 + float(i) + 4.8, 32, Color(0.55, 0.45, 1.0, 0.55), 3.0)
		draw_arc(position, radius + 7.0, -time * 0.55 + float(i), -time * 0.55 + float(i) + 3.7, 28, Color(0.30, 0.70, 1.0, 0.38), 2.0)

		# A bright cosmic core pulses over each winning coin.
		draw_circle(position, 16.0 + pulse * 4.0, Color(0.45, 0.35, 1.0, 0.16))
		draw_circle(position, 5.0 + pulse * 1.5, Color(0.90, 0.94, 1.0, 0.95))


func draw_ice_freeze_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 4.5) + 1.0) * 0.5

	# Frost energy spreads directly along the winning line.
	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]
		var direction = (end - start).normalized()
		var perpendicular = Vector2(-direction.y, direction.x)

		draw_line(
			start,
			end,
			Color(0.45, 0.85, 1.0, 0.18 + pulse * 0.08),
			24.0 + pulse * 4.0
		)

		draw_line(
			start,
			end,
			Color(0.55, 0.90, 1.0, 0.88),
			8.0
		)

		draw_line(
			start,
			end,
			Color(0.90, 0.98, 1.0, 0.98),
			2.5
		)

		# Small drifting frost particles.
		for shard_index in range(4):
			var progress = fmod(time * 0.22 + float(shard_index) * 0.27 + float(i) * 0.12, 1.0)
			var shard_position = start.lerp(end, progress)
			var offset = sin(time * 2.5 + float(shard_index) * 1.7) * 5.0
			shard_position += perpendicular * offset

			draw_line(
				shard_position - perpendicular * 5.0,
				shard_position + perpendicular * 5.0,
				Color(0.80, 0.96, 1.0, 0.85),
				2.0
			)

	# Frosty rings and ice shards around the three winning coins.
	for i in range(winning_positions.size()):
		var position = winning_positions[i]
		var radius = 42.0 + pulse * 5.0

		draw_circle(
			position,
			radius,
			Color(0.55, 0.90, 1.0, 0.10)
		)

		draw_arc(
			position,
			radius,
			0.0,
			TAU,
			40,
			Color(0.78, 0.96, 1.0, 0.82),
			2.5
		)

		# Six small ice shards form a controlled frozen burst.
		for shard_index in range(6):
			var angle = TAU / 6.0 * float(shard_index) + time * 0.12 + float(i) * 0.3
			var shard_center = position + Vector2(cos(angle), sin(angle)) * (43.0 + pulse * 3.0)
			var shard_direction = Vector2(cos(angle), sin(angle))
			var side = Vector2(-shard_direction.y, shard_direction.x)

			draw_colored_polygon(
				PackedVector2Array([
					shard_center + shard_direction * 9.0,
					shard_center + side * 3.5,
					shard_center - shard_direction * 9.0,
					shard_center - side * 3.5
				]),
				Color(0.62, 0.92, 1.0, 0.88)
			)

			draw_line(
				shard_center - shard_direction * 8.0,
				shard_center + shard_direction * 8.0,
				Color(0.92, 1.0, 1.0, 0.95),
				1.5
			)

		# Bright cold center.
		draw_circle(position, 13.0 + pulse * 2.0, Color(0.70, 0.94, 1.0, 0.18))
		draw_circle(position, 4.5 + pulse, Color(0.95, 1.0, 1.0, 0.95))


func draw_crystal_burst_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 5.0) + 1.0) * 0.5

	# Bright crystal energy travels directly along the winning line.
	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]
		var direction = (end - start).normalized()
		var perpendicular = Vector2(-direction.y, direction.x)

		draw_line(start, end, Color(0.10, 0.65, 1.0, 0.28 + pulse * 0.10), 28.0 + pulse * 5.0)
		draw_line(start, end, Color(0.10, 0.55, 1.0, 0.95), 11.0)
		draw_line(start, end, Color(0.85, 1.0, 1.0, 1.0), 3.5)

		# Moving crystal sparks.
		for spark_index in range(7):
			var progress = fmod(time * 0.45 + float(spark_index) * 0.15 + float(i) * 0.08, 1.0)
			var spark_position = start.lerp(end, progress)
			spark_position += perpendicular * sin(time * 6.0 + float(spark_index) * 1.5) * 7.0
			draw_circle(spark_position, 3.0 + pulse * 1.5, Color(0.90, 1.0, 1.0, 1.0))

	# A crystal burst surrounds each of the three winning coins.
	for i in range(winning_positions.size()):
		var position = winning_positions[i]
		var glow_radius = 48.0 + pulse * 8.0

		draw_circle(position, glow_radius, Color(0.10, 0.70, 1.0, 0.14))
		draw_circle(position, 34.0 + pulse * 4.0, Color(0.35, 0.90, 1.0, 0.12))

		# Large visible crystal shards radiate outward.
		for shard_index in range(8):
			var angle = TAU / 8.0 * float(shard_index) + time * 0.55 + float(i) * 0.35
			var distance = 45.0 + sin(time * 3.0 + float(shard_index)) * 5.0
			var center = position + Vector2(cos(angle), sin(angle)) * distance
			var direction = Vector2(cos(angle), sin(angle))
			var side = Vector2(-direction.y, direction.x)

			var shard_length = 13.0 + pulse * 3.0
			var shard_width = 5.0

			draw_colored_polygon(
				PackedVector2Array([
					center + direction * shard_length,
					center + side * shard_width,
					center - direction * shard_length,
					center - side * shard_width
				]),
				Color(0.20, 0.78, 1.0, 0.95)
			)

			draw_line(
				center - direction * shard_length,
				center + direction * shard_length,
				Color(0.90, 1.0, 1.0, 1.0),
				2.0
			)

		# Bright crystal flash in the centre of each winning coin.
		draw_circle(position, 18.0 + pulse * 4.0, Color(0.35, 0.90, 1.0, 0.30))
		draw_circle(position, 7.0 + pulse * 2.0, Color(0.95, 1.0, 1.0, 1.0))

func draw_candy_pop_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 5.0) + 1.0) * 0.5
	var candy_colors = [
		Color(1.0, 0.35, 0.55, 0.90),
		Color(0.35, 0.75, 1.0, 0.90),
		Color(1.0, 0.78, 0.20, 0.90),
		Color(0.55, 0.95, 0.55, 0.90)
	]

	# Soft candy glow along the winning line.
	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]
		draw_line(
			start,
			end,
			Color(1.0, 0.45, 0.75, 0.12 + pulse * 0.06),
			16.0 + pulse * 3.0
		)
		draw_line(
			start,
			end,
			Color(1.0, 0.65, 0.85, 0.48),
			4.0
		)

	# Small candy pieces and sparkles pop around each winning coin.
	for i in range(winning_positions.size()):
		var position = winning_positions[i]
		var bounce = abs(sin(time * 5.5 + float(i) * 0.8))
		var pop_radius = 38.0 + bounce * 9.0

		draw_circle(
			position,
			pop_radius,
			Color(1.0, 0.55, 0.80, 0.08)
		)

		for candy_index in range(6):
			var angle = TAU / 6.0 * float(candy_index) + time * 0.7 + float(i) * 0.5
			var distance = 43.0 + bounce * 8.0 + sin(time * 3.0 + float(candy_index)) * 3.0
			var candy_position = position + Vector2(cos(angle), sin(angle)) * distance
			var candy_size = 5.0 + bounce * 2.0
			var candy_color = candy_colors[(candy_index + i) % candy_colors.size()]

			draw_circle(candy_position, candy_size, candy_color)
			draw_circle(candy_position, candy_size * 0.45, Color(1.0, 1.0, 1.0, 0.75))

		# Two small star-like sparkles.
		for sparkle_index in range(2):
			var sparkle_angle = time * 1.5 + float(i) + float(sparkle_index) * PI
			var sparkle_position = position + Vector2(cos(sparkle_angle), sin(sparkle_angle)) * (52.0 + bounce * 5.0)
			draw_line(
				sparkle_position + Vector2(-5.0, 0),
				sparkle_position + Vector2(5.0, 0),
				Color(1.0, 0.95, 0.75, 0.85),
				2.0
			)
			draw_line(
				sparkle_position + Vector2(0, -5.0),
				sparkle_position + Vector2(0, 5.0),
				Color(1.0, 0.95, 0.75, 0.85),
				2.0
			)

		# Bright pop flash at each winning coin.
		draw_circle(
			position,
			8.0 + pulse * 3.0,
			Color(1.0, 0.90, 0.55, 0.30)
		)
		draw_circle(
			position,
			3.0 + pulse,
			Color(1.0, 1.0, 1.0, 0.90)
		)

func draw_fire_line_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 4.5) + 1.0) * 0.5

	# Keep the fire effect clean and directly on the winning line.
	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]
		var direction = (end - start).normalized()
		var perpendicular = Vector2(-direction.y, direction.x)

		# Warm outer glow.
		draw_line(
			start,
			end,
			Color(1.0, 0.20, 0.02, 0.10 + pulse * 0.05),
			18.0 + pulse * 3.0
		)

		# Main orange fire line.
		draw_line(
			start,
			end,
			Color(1.0, 0.30, 0.02, 0.82),
			8.0
		)

		# Bright hot center.
		draw_line(
			start,
			end,
			Color(1.0, 0.82, 0.18, 0.95),
			2.5
		)

		# A few moving embers travel along the line.
		for ember_index in range(4):
			var progress = fmod(time * 0.45 + float(ember_index) * 0.24 + float(i) * 0.12, 1.0)
			var ember_position = start.lerp(end, progress)
			var wave = sin(time * 7.0 + float(ember_index) * 2.0) * 3.0
			ember_position += perpendicular * wave
			draw_circle(
				ember_position,
			2.5 + pulse * 1.2,
			Color(1.0, 0.92, 0.35, 0.90)
			)

	# Small controlled flames rise from the three winning coins.
	for i in range(winning_positions.size()):
		var position = winning_positions[i]
		var flicker = sin(time * 6.0 + float(i) * 1.7) * 3.0
		var width = 5.0 + pulse * 1.5

		draw_colored_polygon(
			PackedVector2Array([
				position + Vector2(-width, -26.0),
				position + Vector2(0, -37.0 + flicker),
				position + Vector2(width, -26.0)
			]),
			Color(1.0, 0.32, 0.02, 0.82)
		)

		draw_colored_polygon(
			PackedVector2Array([
				position + Vector2(-2.5, -27.0),
				position + Vector2(0, -34.0 + flicker * 0.6),
				position + Vector2(2.5, -27.0)
			]),
			Color(1.0, 0.88, 0.25, 0.95)
		)


func draw_thunder_strike_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 7.0) + 1.0) * 0.5

	# Clean electric glow directly along the winning line.
	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]
		var direction = (end - start).normalized()
		var perpendicular = Vector2(-direction.y, direction.x)

		# Soft blue electric glow.
		draw_line(
			start,
			end,
			Color(0.20, 0.60, 1.0, 0.12 + pulse * 0.08),
			20.0 + pulse * 4.0
		)

		# Main electric path.
		draw_line(
			start,
			end,
			Color(0.20, 0.65, 1.0, 0.80),
			6.0
		)

		# Bright white-blue core.
		draw_line(
			start,
			end,
			Color(0.85, 0.95, 1.0, 0.98),
			2.0
		)

		# Short animated lightning branches stay close to the winning line.
		for bolt_index in range(3):
			var progress = fmod(time * 0.9 + float(bolt_index) * 0.31 + float(i) * 0.17, 1.0)
			var center = start.lerp(end, progress)
			var side = -1.0 if bolt_index % 2 == 0 else 1.0
			var length = 14.0 + pulse * 5.0
			var p1 = center + perpendicular * (length * 0.35 * side)
			var p2 = center + direction * 8.0 + perpendicular * (-length * 0.25 * side)

			draw_line(
				center,
				p1,
				Color(0.35, 0.75, 1.0, 0.75),
				3.0
			)
			draw_line(
				p1,
				p2,
				Color(0.90, 0.98, 1.0, 0.95),
				2.0
			)

	# Small electric flashes around the three winning coins.
	for i in range(winning_positions.size()):
		var position = winning_positions[i]
		var rotation_offset = time * 2.5 + float(i) * 1.8
	
		for spark_index in range(4):
			var angle = rotation_offset + float(spark_index) * (TAU / 4.0)
			var inner = position + Vector2(cos(angle), sin(angle)) * 34.0
			var outer = position + Vector2(cos(angle), sin(angle)) * (44.0 + pulse * 5.0)
			draw_line(
				inner,
				outer,
				Color(0.75, 0.92, 1.0, 0.75),
				2.5
			)


# ==========================================
# WINNING HIGHLIGHT
# ==========================================

func draw_winner_highlight():

	if winning_positions.size() < 2:
		return

	# One clean highlight line connects the winning three coins.
	for i in range(winning_positions.size() - 1):
		draw_line(
			winning_positions[i],
			winning_positions[i + 1],
			Color(1.0, 0.85, 0.20, 0.20),
			22.0
		)
		draw_line(
			winning_positions[i],
			winning_positions[i + 1],
			Color(1.0, 0.86, 0.25, 0.85),
			5.0
		)

	# A single subtle ring marks each winning coin.
	for position in winning_positions:
		draw_arc(
			position,
			39.0,
			0.0,
			TAU,
			48,
			Color(1.0, 0.88, 0.25, 0.95),
			4.0
		)

func draw_victory_star(center, size):
	var points_star = PackedVector2Array()
	for i in range(8):
		var angle = -PI / 2.0 + (TAU / 8.0) * i
		var radius = size if i % 2 == 0 else size * 0.38
		points_star.append(center + Vector2(cos(angle), sin(angle)) * radius)
	draw_colored_polygon(points_star, Color(1.0, 0.90, 0.25, 0.95))


# ==========================================
# PLAYER COIN DRAWING
# ==========================================

func draw_player_coin(position, player, skin):

	var outer_color = Color(0.55, 0.32, 0.10)
	var inner_color = Color(0.92, 0.68, 0.20)
	var rim_color = Color(0.98, 0.82, 0.35)
	var emblem_color = Color(0.20, 0.12, 0.05)

	if player == 2:
		outer_color = Color(0.35, 0.25, 0.45)
		inner_color = Color(0.78, 0.55, 0.82)
		rim_color = Color(0.95, 0.72, 0.95)
		emblem_color = Color(0.20, 0.08, 0.22)

	# Shadow
	draw_circle(position + Vector2(3, 5), 31, Color(0.0, 0.0, 0.0, 0.25))

	# Coin body and raised rim
	draw_circle(position, 31, outer_color)
	draw_circle(position, 27, inner_color)
	draw_arc(position, 29, 0.0, TAU, 40, rim_color, 3.0)
	draw_arc(position, 23, 0.0, TAU, 40, outer_color, 2.0)

	if skin == "Pirate Coin":

		# Pirate skull
		draw_circle(position + Vector2(-7, -5), 7, emblem_color)
		draw_circle(position + Vector2(7, -5), 7, emblem_color)
		draw_rect(Rect2(position + Vector2(-11, -2), Vector2(22, 13)), emblem_color, true)

		# Skull eyes
		draw_circle(position + Vector2(-7, -5), 2.5, inner_color)
		draw_circle(position + Vector2(7, -5), 2.5, inner_color)

		# Crossbones
		draw_line(position + Vector2(-16, 12), position + Vector2(16, -12), emblem_color, 3)
		draw_line(position + Vector2(-16, -12), position + Vector2(16, 12), emblem_color, 3)

	elif skin == "Anime Coin":

		# Cute anime-inspired face
		draw_circle(position + Vector2(-9, -4), 5, emblem_color)
		draw_circle(position + Vector2(9, -4), 5, emblem_color)
		draw_circle(position + Vector2(-9, -4), 2, inner_color)
		draw_circle(position + Vector2(9, -4), 2, inner_color)
		draw_arc(position + Vector2(0, 4), 10, 0.2, PI - 0.2, 20, emblem_color, 2)

		# Anime sparkle
		draw_line(position + Vector2(14, -16), position + Vector2(14, -7), rim_color, 2)
		draw_line(position + Vector2(9.5, -11.5), position + Vector2(18.5, -11.5), rim_color, 2)

	else:

		# Classic star emblem
		draw_string(
			ThemeDB.fallback_font,
			position + Vector2(-13, 14),
			player1_symbol if player == 1 else player2_symbol,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			30,
			emblem_color
		)


# ==========================================
# BLUE CRYSTAL / ENERGY BACKGROUND
# ==========================================

func draw_crystal_energy_background():

	var board_rect = Rect2(35, 275, 650, 650)

	# Deep blue base
	draw_rect(
		board_rect,
		Color(0.015, 0.10, 0.28),
		true
	)

	# Large blue energy glow
	draw_circle(
		Vector2(360, 600),
		285,
		Color(0.02, 0.25, 0.65, 0.55)
	)

	draw_circle(
		Vector2(360, 600),
		220,
		Color(0.02, 0.45, 0.85, 0.28)
	)

	# Energy waves
	draw_arc(
		Vector2(360, 590),
		300,
		0.25,
		2.75,
		80,
		Color(0.05, 0.70, 1.0, 0.35),
		10,
		true
	)

	draw_arc(
		Vector2(360, 610),
		250,
		3.25,
		5.65,
		80,
		Color(0.10, 0.55, 1.0, 0.35),
		8,
		true
	)

	draw_arc(
		Vector2(360, 590),
		185,
		0.5,
		2.2,
		60,
		Color(0.25, 0.85, 1.0, 0.30),
		6,
		true
	)

	# Flowing energy lines
	draw_line(
		Vector2(50, 430),
		Vector2(220, 360),
		Color(0.10, 0.75, 1.0, 0.30),
		5
	)

	draw_line(
		Vector2(220, 360),
		Vector2(430, 430),
		Color(0.10, 0.75, 1.0, 0.30),
		5
	)

	draw_line(
		Vector2(430, 430),
		Vector2(670, 350),
		Color(0.10, 0.75, 1.0, 0.30),
		5
	)

	draw_line(
		Vector2(50, 770),
		Vector2(250, 850),
		Color(0.05, 0.65, 1.0, 0.30),
		5
	)

	draw_line(
		Vector2(250, 850),
		Vector2(470, 770),
		Color(0.05, 0.65, 1.0, 0.30),
		5
	)

	draw_line(
		Vector2(470, 770),
		Vector2(670, 850),
		Color(0.05, 0.65, 1.0, 0.30),
		5
	)

	# Crystal shapes - top left
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(55, 315),
			Vector2(80, 285),
			Vector2(95, 340),
			Vector2(75, 380),
			Vector2(50, 350)
		]),
		Color(0.20, 0.75, 1.0, 0.55)
	)

	draw_colored_polygon(
		PackedVector2Array([
			Vector2(85, 320),
			Vector2(105, 295),
			Vector2(120, 355),
			Vector2(100, 375)
		]),
		Color(0.35, 0.90, 1.0, 0.45)
	)

	# Crystal shapes - top right
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(625, 325),
			Vector2(650, 285),
			Vector2(675, 330),
			Vector2(655, 380),
			Vector2(635, 360)
		]),
		Color(0.20, 0.75, 1.0, 0.55)
	)

	draw_colored_polygon(
		PackedVector2Array([
			Vector2(600, 345),
			Vector2(620, 305),
			Vector2(635, 365),
			Vector2(615, 390)
		]),
		Color(0.35, 0.90, 1.0, 0.45)
	)

	# Crystal shapes - bottom left
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(50, 860),
			Vector2(75, 810),
			Vector2(100, 865),
			Vector2(80, 910),
			Vector2(55, 900)
		]),
		Color(0.15, 0.70, 1.0, 0.55)
	)

	draw_colored_polygon(
		PackedVector2Array([
			Vector2(90, 885),
			Vector2(110, 835),
			Vector2(130, 900),
			Vector2(110, 920)
		]),
		Color(0.35, 0.90, 1.0, 0.45)
	)

	# Crystal shapes - bottom right
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(620, 865),
			Vector2(645, 810),
			Vector2(675, 860),
			Vector2(650, 915),
			Vector2(630, 900)
		]),
		Color(0.15, 0.70, 1.0, 0.55)
	)

	draw_colored_polygon(
		PackedVector2Array([
			Vector2(590, 895),
			Vector2(610, 845),
			Vector2(630, 910),
			Vector2(610, 925)
		]),
		Color(0.35, 0.90, 1.0, 0.45)
	)

	# Small glowing particles
	var particles = [
		Vector2(120, 410),
		Vector2(180, 520),
		Vector2(270, 340),
		Vector2(430, 350),
		Vector2(540, 470),
		Vector2(590, 590),
		Vector2(140, 680),
		Vector2(230, 760),
		Vector2(350, 820),
		Vector2(520, 730),
		Vector2(590, 820),
		Vector2(90, 550)
	]

	for particle in particles:
		draw_circle(
			particle,
			4,
			Color(0.55, 0.95, 1.0, 0.85)
		)

		draw_circle(
			particle,
			10,
			Color(0.10, 0.70, 1.0, 0.15)
		)


# ==========================================
# INPUT
# ==========================================

func _input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			var mouse_position = get_global_mouse_position()


			# ==================================
			# LEVELS SCREEN
			# ==================================

			if levels_screen:

				if Rect2(70, 180, 580, 150).has_point(mouse_position):

					current_level = 1
					levels_screen = false
					reset_game()

					return

				if Rect2(70, 360, 580, 150).has_point(mouse_position):

					return

				if Rect2(210, 900, 300, 80).has_point(mouse_position):

					levels_screen = false
					queue_redraw()

					return

				return


			# ==================================
			# SKINS SCREEN
			# ==================================

			if skins_screen:

				if Rect2(70, 180, 580, 150).has_point(mouse_position):

					current_theme = "classic"
					queue_redraw()

					return

				if Rect2(70, 360, 580, 150).has_point(mouse_position):

					current_theme = "wooden"
					queue_redraw()

					return

				if Rect2(70, 540, 580, 150).has_point(mouse_position):

					current_theme = "space"
					queue_redraw()

					return

				if Rect2(210, 900, 300, 80).has_point(mouse_position):

					skins_screen = false
					queue_redraw()

					return

				return


			# ==================================
			# COIN SKINS SCREEN
			# ==================================

			if coin_skins_screen:

				if Rect2(35, 115, 300, 70).has_point(mouse_position):
					active_coin_player = 1
					queue_redraw()
					return

				if Rect2(385, 115, 300, 70).has_point(mouse_position):
					active_coin_player = 2
					queue_redraw()
					return

				var coin_card_positions = [
					Vector2(70, 220),
					Vector2(70, 400),
					Vector2(70, 580)
				]

				for i in range(coin_card_positions.size()):

					var card_rect = Rect2(
						coin_card_positions[i],
						Vector2(580, 150)
					)

					if card_rect.has_point(mouse_position):

						if active_coin_player == 1:
							player1_coin_skin = coin_skin_names[i]
						else:
							player2_coin_skin = coin_skin_names[i]

						queue_redraw()
						return

				if Rect2(210, 900, 300, 80).has_point(mouse_position):
					coin_skins_screen = false
					queue_redraw()
					return

				return


			# ==================================
			# VICTORY EFFECTS SCREEN
			# ==================================

			if victory_effects_screen:

				if Rect2(35, 135, 300, 75).has_point(mouse_position):

					active_effect_player = 1
					queue_redraw()

					return

				if Rect2(385, 135, 300, 75).has_point(mouse_position):

					active_effect_player = 2
					queue_redraw()

					return

				var card_positions = [
					Vector2(25, 285),
					Vector2(370, 285),
					Vector2(25, 455),
					Vector2(370, 455),
					Vector2(25, 625),
					Vector2(370, 625),
					Vector2(25, 795),
					Vector2(370, 795),
					Vector2(25, 965),
					Vector2(370, 965)
				]

				# EQUIP buttons
				for i in range(card_positions.size()):

					var equip_rect = Rect2(
						card_positions[i] + Vector2(190, 105),
						Vector2(115, 35)
					)

					if equip_rect.has_point(mouse_position):

						if active_effect_player == 1:
							player1_victory_effect = victory_effect_names[i]
						else:
							player2_victory_effect = victory_effect_names[i]

						queue_redraw()

						return

				if Rect2(210, 1145, 300, 70).has_point(mouse_position):

					victory_effects_screen = false
					queue_redraw()

					return

				return


			# ==================================
			# PLAY AGAIN
			# ==================================

			# Handle this BEFORE the menu buttons so the PLAY AGAIN
			# button cannot accidentally open the VICTORY screen.
			if game_over:

				if Rect2(210, 165, 300, 70).has_point(mouse_position):

					reset_game()
					return

				return


			# ==================================
			# LEVELS BUTTON
			# ==================================

			if Rect2(35, 165, 130, 55).has_point(mouse_position):

				levels_screen = true
				selected_piece = -1

				queue_redraw()

				return


			# ==================================
			# VICTORY BUTTON
			# ==================================

			if Rect2(280, 165, 160, 55).has_point(mouse_position):

				victory_effects_screen = true
				selected_piece = -1

				queue_redraw()

				return


			# ==================================
			# COINS BUTTON
			# ==================================

			if Rect2(280, 235, 160, 50).has_point(mouse_position):

				coin_skins_screen = true
				selected_piece = -1

				queue_redraw()

				return


			# ==================================
			# SKINS BUTTON
			# ==================================

			if Rect2(540, 165, 130, 55).has_point(mouse_position):

				skins_screen = true
				selected_piece = -1

				queue_redraw()

				return


			# ==================================
			# DO NOT ALLOW ACTION WHILE MOVING
			# ==================================

			if is_moving:
				return


			# ==================================
			# MOVEMENT PHASE
			# ==================================

			if movement_phase:

				for i in range(points.size()):

					if mouse_position.distance_to(points[i]) < 35:

						# Player 1 piece
						if current_player == 1 and player1_positions.has(points[i]):

							selected_piece = i
							queue_redraw()

						# Player 2 piece
						elif current_player == 2 and player2_positions.has(points[i]):

							selected_piece = i
							queue_redraw()

						# Move Player 1
						elif current_player == 1 and selected_piece != -1 and not occupied_positions.has(points[i]):

							if i in connections[selected_piece]:

								var old_position = points[selected_piece]
								var new_position = points[i]

								player1_positions.erase(old_position)
								occupied_positions.erase(old_position)
								occupied_positions.append(new_position)

								start_smooth_move(
									old_position,
									new_position,
									1
								)

						# Move Player 2
						elif current_player == 2 and selected_piece != -1 and not occupied_positions.has(points[i]):

							if i in connections[selected_piece]:

								var old_position = points[selected_piece]
								var new_position = points[i]

								player2_positions.erase(old_position)
								occupied_positions.erase(old_position)
								occupied_positions.append(new_position)

								start_smooth_move(
									old_position,
									new_position,
									2
								)


			# ==================================
			# PLACEMENT PHASE
			# ==================================

			else:

				for i in range(points.size()):

					# Player 1
					if mouse_position.distance_to(points[i]) < 35 and current_player == 1 and player1_pieces < 3 and not occupied_positions.has(points[i]):

						player1_pieces += 1
						player1_positions.append(points[i])
						occupied_positions.append(points[i])

						check_winner()

						if game_over:
							queue_redraw()
							return

						current_player = 2

						queue_redraw()

					# Player 2
					elif mouse_position.distance_to(points[i]) < 35 and current_player == 2 and player2_pieces < 3 and not occupied_positions.has(points[i]):

						player2_pieces += 1
						player2_positions.append(points[i])
						occupied_positions.append(points[i])

						check_winner()

						if game_over:
							queue_redraw()
							return

						current_player = 1

						if player1_pieces == 3 and player2_pieces == 3:

							movement_phase = true

						queue_redraw()


# ==========================================
# SMOOTH MOVEMENT
# ==========================================

func start_smooth_move(from_position, to_position, player):

	is_moving = true
	moving_position = from_position
	moving_target = to_position
	moving_player = player

	selected_piece = -1

	queue_redraw()

	var tween = create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_method(
		update_moving_position,
		from_position,
		to_position,
		0.4
	)

	tween.finished.connect(finish_smooth_move)


# ==========================================
# UPDATE MOVING POSITION
# ==========================================

func update_moving_position(new_position):

	moving_position = new_position

	queue_redraw()


# ==========================================
# FINISH SMOOTH MOVEMENT
# ==========================================

func finish_smooth_move():

	is_moving = false

	if moving_player == 1:

		player1_positions.append(moving_target)
		current_player = 2

		check_winner()

	elif moving_player == 2:

		player2_positions.append(moving_target)
		current_player = 1

		check_winner()

	moving_position = Vector2.ZERO
	moving_target = Vector2.ZERO
	moving_player = 0

	queue_redraw()


# ==========================================
# WINNER CHECK
# ==========================================

func check_winner():

	# Player 1
	for line in winning_lines:

		if player1_positions.has(points[line[0]]) and player1_positions.has(points[line[1]]) and player1_positions.has(points[line[2]]):

			game_over = true
			winner_player = 1
			winning_positions = [points[line[0]], points[line[1]], points[line[2]]]
			winner_text = "PLAYER 1 WINS!"
			star_celebration_started = true
			star_celebration_time = 0.0
			print("PLAYER 1 WINS!")

			queue_redraw()

			return


	# Player 2
	for line in winning_lines:

		if player2_positions.has(points[line[0]]) and player2_positions.has(points[line[1]]) and player2_positions.has(points[line[2]]):

			game_over = true
			winner_player = 2
			winning_positions = [points[line[0]], points[line[1]], points[line[2]]]
			winner_text = "PLAYER 2 WINS!"
			star_celebration_started = true
			star_celebration_time = 0.0

			print("PLAYER 2 WINS!")

			queue_redraw()

			return


# ==========================================
# RESET GAME
# ==========================================

func reset_game():

	player1_pieces = 0
	player1_positions.clear()

	player2_pieces = 0
	player2_positions.clear()

	occupied_positions.clear()

	current_player = 1

	movement_phase = false
	selected_piece = -1

	is_moving = false
	moving_position = Vector2.ZERO
	moving_target = Vector2.ZERO
	moving_player = 0

	game_over = false
	winner_text = ""
	winning_positions.clear()
	winner_player = 0

	skins_screen = false
	coin_skins_screen = false

	queue_redraw()
func draw_electric_chain_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 8.0) + 1.0) * 0.5

	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]
		var direction = (end - start).normalized()
		var perpendicular = Vector2(-direction.y, direction.x)

		draw_line(
			start,
			end,
			Color(0.15, 0.55, 1.0, 0.12 + pulse * 0.08),
			18.0 + pulse * 4.0
		)

		draw_line(
			start,
			end,
			Color(0.15, 0.65, 1.0, 0.78),
			6.0
		)

		draw_line(
			start,
			end,
			Color(0.88, 0.98, 1.0, 0.98),
			2.0
		)

		for bolt_index in range(4):
			var progress = fmod(
				time * 0.75 + float(bolt_index) * 0.24 + float(i) * 0.13,
				1.0
			)

			var center = start.lerp(end, progress)
			var side = 1.0 if bolt_index % 2 == 0 else -1.0
			var length = 18.0 + pulse * 5.0

			var p1 = center + perpendicular * (length * side)
			var p2 = center + direction * 8.0 + perpendicular * (-length * 0.55 * side)

			draw_line(
				center,
				p1,
				Color(0.25, 0.75, 1.0, 0.75),
				3.0
			)

			draw_line(
				p1,
				p2,
				Color(0.90, 0.98, 1.0, 0.95),
				2.0
			)

	for position in winning_positions:
		draw_circle(
			position,
			12.0 + pulse * 4.0,
			Color(0.20, 0.70, 1.0, 0.18)
		)

		draw_circle(
			position,
			4.0 + pulse * 1.5,
			Color(0.90, 1.0, 1.0, 0.95)
		)
func draw_portal_burst_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 5.0) + 1.0) * 0.5

	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]
		var direction = (end - start).normalized()

		# Portal energy along the winning line.
		draw_line(
			start,
			end,
			Color(0.45, 0.15, 1.0, 0.12 + pulse * 0.08),
			20.0 + pulse * 4.0
		)

		draw_line(
			start,
			end,
			Color(0.65, 0.25, 1.0, 0.75),
			7.0
		)

		draw_line(
			start,
			end,
			Color(0.95, 0.85, 1.0, 0.95),
			2.0
		)

	# Small portals around the winning coins.
	for i in range(winning_positions.size()):
		var position = winning_positions[i]

		draw_arc(
			position,
			28.0 + pulse * 5.0,
			0.0,
			TAU,
			40,
			Color(0.65, 0.25, 1.0, 0.75),
			5.0
		)

		draw_arc(
			position,
			18.0 + pulse * 3.0,
			-time * 3.0 + float(i),
			-time * 3.0 + float(i) + 4.5,
			30,
			Color(0.95, 0.75, 1.0, 0.95),
			3.0
		)

		draw_circle(
			position,
			7.0 + pulse * 3.0,
			Color(0.85, 0.55, 1.0, 0.30)
		)

	# Energy particles moving toward the center.
	var center = winning_positions[1]

	for i in range(6):
		var start_position = winning_positions[i % winning_positions.size()]
		var progress = fmod(time * 0.55 + float(i) * 0.16, 1.0)
		var particle_position = start_position.lerp(center, progress)

		draw_circle(
			particle_position,
			3.0 + pulse * 1.5,
			Color(0.90, 0.75, 1.0, 0.90)
		)

func draw_royal_victory_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 4.0) + 1.0) * 0.5

	# Regal golden glow along the winning line.
	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]

		draw_line(
			start,
			end,
			Color(1.0, 0.65, 0.05, 0.15 + pulse * 0.10),
			22.0 + pulse * 4.0
		)

		draw_line(
			start,
			end,
			Color(1.0, 0.75, 0.15, 0.90),
			7.0
		)

		draw_line(
			start,
			end,
			Color(1.0, 0.95, 0.65, 0.95),
			2.5
		)

	# Crown-like symbols above the winning coins.
	for i in range(winning_positions.size()):
		var position = winning_positions[i]
		var crown_y = position.y - 48.0
		var crown_width = 16.0 + pulse * 2.0

		var crown = PackedVector2Array([
			Vector2(position.x - crown_width, crown_y + 12.0),
			Vector2(position.x - crown_width * 0.85, crown_y - 5.0),
			Vector2(position.x - crown_width * 0.25, crown_y + 4.0),
			Vector2(position.x, crown_y - 12.0),
			Vector2(position.x + crown_width * 0.25, crown_y + 4.0),
			Vector2(position.x + crown_width * 0.85, crown_y - 5.0),
			Vector2(position.x + crown_width, crown_y + 12.0)
		])

		draw_colored_polygon(
			crown,
			Color(1.0, 0.72, 0.08, 0.95)
		)

		draw_polyline(
			PackedVector2Array([
				Vector2(position.x - crown_width, crown_y + 12.0),
				Vector2(position.x + crown_width, crown_y + 12.0)
			]),
			Color(1.0, 0.95, 0.55, 1.0),
			3.0
		)

		draw_circle(
			Vector2(position.x, crown_y + 7.0),
			3.0 + pulse,
			Color(1.0, 0.95, 0.65, 1.0)
		)

	# Soft golden aura around each winning coin.
	for position in winning_positions:
		draw_arc(
			position,
			44.0 + pulse * 4.0,
			0.0,
			TAU,
			48,
			Color(1.0, 0.78, 0.18, 0.45 + pulse * 0.25),
			3.0
		)

func draw_ultimate_combo_effect():
	if winning_positions.size() < 2:
		return

	var time = Time.get_ticks_msec() / 1000.0
	var pulse = (sin(time * 7.0) + 1.0) * 0.5

	# Powerful blue and fiery glow along the winning line.
	for i in range(winning_positions.size() - 1):
		var start = winning_positions[i]
		var end = winning_positions[i + 1]

		draw_line(
			start,
			end,
			Color(0.20, 0.45, 1.0, 0.16 + pulse * 0.10),
			24.0 + pulse * 5.0
		)

		draw_line(
			start,
			end,
			Color(1.0, 0.35, 0.06, 0.80),
			9.0
		)

		draw_line(
			start,
			end,
			Color(1.0, 0.90, 0.45, 0.98),
			3.0
		)

	# Energy bursts around all three winning coins.
	for i in range(winning_positions.size()):
		var position = winning_positions[i]
		var radius = 43.0 + pulse * 8.0

		draw_arc(
			position,
			radius,
			time * 1.8 + float(i),
			time * 1.8 + float(i) + 4.8,
			40,
			Color(0.30, 0.75, 1.0, 0.90),
			4.0
		)

		draw_arc(
			position,
			radius - 9.0,
			-time * 2.2 + float(i),
			-time * 2.2 + float(i) + 3.8,
			36,
			Color(1.0, 0.55, 0.12, 0.90),
			3.0
		)

	# Bright central burst.
	var center = winning_positions[1]

	draw_circle(
		center,
		16.0 + pulse * 8.0,
		Color(0.25, 0.65, 1.0, 0.22)
	)

	draw_circle(
		center,
		7.0 + pulse * 4.0,
		Color(1.0, 0.92, 0.60, 0.95)
	)

	# Moving sparks travel along the winning line.
	for i in range(8):
		var start_position = winning_positions[i % winning_positions.size()]
		var end_position = winning_positions[(i + 1) % winning_positions.size()]
		var progress = fmod(time * 0.65 + float(i) * 0.13, 1.0)
		var spark_position = start_position.lerp(end_position, progress)

		var spark_color = Color(1.0, 0.75, 0.20, 0.95)
		if i % 2 == 0:
			spark_color = Color(0.50, 0.85, 1.0, 0.95)

		draw_circle(
			spark_position,
			3.0 + pulse * 1.5,
			spark_color
		)

func draw_star_celebration():
	if not star_celebration_started:
		return

	var time = star_celebration_time
	var centers = [
		Vector2(250, 255),
		Vector2(360, 235),
		Vector2(470, 255)
	]

	# Three stars appear one after another with a bounce.
	for i in range(centers.size()):
		var delay = float(i) * 0.18
		var progress = clampf((time - delay) / 0.65, 0.0, 1.0)
		if progress <= 0.0:
			continue

		var bounce = absf(sin(progress * PI * 2.0))
		var scale_size = (0.75 + 0.25 * progress) * (1.0 + bounce * 0.18)
		var fade = minf(progress * 2.0, 1.0)
		var center = centers[i]
		var radius = (38.0 if i == 1 else 30.0) * scale_size
		var rotation = sin(time * 3.5 + float(i)) * 0.10

		# Layered glow behind each star.
		draw_circle(center, radius * 1.55, Color(1.0, 0.72, 0.08, 0.14 * fade))
		draw_circle(center, radius * 1.20, Color(1.0, 0.85, 0.25, 0.20 * fade))

		# Dark gold edge gives the star a raised 3D look.
		var edge_points = make_star_points(center + Vector2(1.5, 3.0), radius, rotation)
		draw_colored_polygon(edge_points, Color(0.48, 0.22, 0.015, fade))

		# Main golden face.
		var face_points = make_star_points(center + Vector2(-1.5, -2.0), radius * 0.88, rotation)
		draw_colored_polygon(face_points, Color(1.0, 0.68, 0.04, fade))

		# Bright inner face and top shine.
		var highlight_points = make_star_points(center + Vector2(-5.0, -6.0), radius * 0.55, rotation - 0.04)
		draw_colored_polygon(highlight_points, Color(1.0, 0.92, 0.42, fade))
		draw_circle(center + Vector2(-radius * 0.18, -radius * 0.30), radius * 0.09, Color(1.0, 1.0, 0.92, fade))

		# Fine bright outline.
		var outline_points = make_star_points(center, radius * 0.98, rotation)
		var closed_outline = outline_points.duplicate()
		closed_outline.append(outline_points[0])
		draw_polyline(closed_outline, Color(1.0, 0.96, 0.66, fade), 2.0)

	# Twinkling cross-shaped sparkles around the celebration.
	for j in range(12):
		var angle = time * 1.8 + float(j) * TAU / 12.0
		var distance = 82.0 + sin(time * 3.0 + float(j)) * 12.0
		var sparkle_center = Vector2(360, 250) + Vector2(cos(angle) * distance, sin(angle) * distance * 0.55)
		var sparkle_size = 2.5 + absf(sin(time * 5.0 + float(j))) * 3.5
		var sparkle_alpha = 0.45 + absf(sin(time * 4.0 + float(j))) * 0.5
		var sparkle_color = Color(1.0, 0.96, 0.62, sparkle_alpha)
		draw_line(sparkle_center - Vector2(sparkle_size, 0), sparkle_center + Vector2(sparkle_size, 0), sparkle_color, 2.0)
		draw_line(sparkle_center - Vector2(0, sparkle_size), sparkle_center + Vector2(0, sparkle_size), sparkle_color, 2.0)


func make_star_points(center: Vector2, radius: float, rotation: float = 0.0) -> PackedVector2Array:
	var points_array = PackedVector2Array()
	for point_index in range(10):
		var angle = -PI / 2.0 + float(point_index) * PI / 5.0 + rotation
		var point_radius = radius if point_index % 2 == 0 else radius * 0.45
		points_array.append(center + Vector2(cos(angle), sin(angle)) * point_radius)
	return points_array
func draw_wooden_background():
	var screen_size = get_viewport_rect().size

	# Wooden base color
	draw_rect(
		Rect2(Vector2.ZERO, screen_size),
		wood_base_color,
		true
	)

	# Horizontal wood grain lines
	for i in range(0, int(screen_size.y), 55):
		var y = float(i)

		draw_line(
			Vector2(0, y),
			Vector2(screen_size.x, y),
			wood_line_color,
			3.0
		)
