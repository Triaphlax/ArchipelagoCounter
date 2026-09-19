class_name LayoutTool_CheckCounterAdvanced
extends LayoutTool_CheckCounter

var game := ""

func _ready():
	Counter.update.connect(update)
	await Counter.loaded()
	update()

func setGame(pgame):
	game = pgame
	update()

func update():
	if game not in Counter.playerNames:
		modulate.a = 0.0
	else:
		modulate.a = 1.0
		update_text(game, Counter.game_checks[game], Counter.total_game_checks[game])

func update_text(game: String, checks: int, total_checks: int):
	var total_checks_digits := len(str(total_checks))
	var checks_str := str(checks).pad_zeros(total_checks_digits)
	var percent := str((float(checks) / float(total_checks)) * 100)
	percent = percent.pad_zeros(2)
	percent = percent.pad_decimals(2)
	
	#var cpm := str(60.0 * (float(checks) / Counter.save.timer))
	#cpm = cpm.pad_decimals(4)
	var game_time := 0
	if game in Counter.save.game_timer.keys():
		game_time = Counter.save.game_timer[game]
	text = text_format.format([checks, total_checks, percent, Utils.seconds_to_hms(game_time)])
		
